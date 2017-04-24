//
//  MainVC.m
//  DashBoard
//
//  Created by totyu3 on 17/1/17.
//  Copyright © 2017年 NIT. All rights reserved.
//

#define alertpushnum 60

#import "MainVC.h"
#import "AlertBar.h"
#import "UserListCVCell.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

@interface MainVC ()
{
    NSInteger pageCount;
    int PageNumArrayNum;
}
@property (weak, nonatomic) IBOutlet UIPageControl *UserPC;
@property (weak, nonatomic) IBOutlet AlertBar *AlertBarView;
@property (weak, nonatomic) IBOutlet UILabel *NowTime;
@property (weak, nonatomic) IBOutlet UILabel *BuildName;
@property (weak, nonatomic) IBOutlet UICollectionView *UserListCV;
@property (weak, nonatomic) IBOutlet UILabel *NoticeNewDataTap;
@property (weak, nonatomic) IBOutlet UIButton *PageNumBtn;
@property (nonatomic, strong) UIAlertController *UserAlert;
@property (nonatomic, strong) NSArray *UserLisrArray;
@property (nonatomic, strong) NSArray *BuildingArray;
@property (nonatomic, strong) NSArray *CurrentAlertarrays;
@property (nonatomic, strong) NSArray *PageNumArray;
@property (nonatomic, strong) NSArray *PageTitleArray;
@end

@implementation MainVC

static NSString * const reuseIdentifier = @"MainVCell";

-(NSArray *)UserLisrArray{
    if (!_UserLisrArray) {
        _UserLisrArray = [NSArray array];
    }
    return _UserLisrArray;
}

-(NSArray *)BuildingArray{
    if (!_BuildingArray) {
        _BuildingArray = [NSArray array];
    }
    return _BuildingArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self LoadBuildingInfoData];
    [self performSelector:@selector(AutoTime) withObject:nil afterDelay:1];
    [self performSelector:@selector(AlertMonitor) withObject:nil afterDelay:alertpushnum];
    [NITNotificationCenter addObserver:self selector:@selector(DidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    [SystemUserDict setValue:@"1" forKey:@"logintype"];
    [SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO];
    if(NITScreenW == 1024){
        _PageNumArray = @[@"3x4",@"4x5",@"5x6"];
        _PageTitleArray = @[@"大",@"中",@"小"];
    }else if(NITScreenW == 1366){
        _PageNumArray = @[@"5x6",@"6x7",@"7x8"];
        _PageTitleArray = @[@"大",@"中",@"小"];
    }else{
        _PageNumArray = @[@"2x4",@"3x5"];
        _PageTitleArray = @[@"大",@"中"];
    }
    PageNumArrayNum = 0;
    [self SelectPageNum:_PageNumBtn];
}

-(void)DidBecomeActive {
    [self LoadBuildingInfoData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)SelectPageNum:(UIButton *)sender {

    [_PageNumBtn setTitle:_PageTitleArray[PageNumArrayNum] forState:UIControlStateNormal];
    [_PageNumBtn setBackgroundImage:[UIImage imageNamed:_PageTitleArray[PageNumArrayNum]] forState:UIControlStateNormal];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSArray *rowandcolumn=[_PageNumArray[PageNumArrayNum] componentsSeparatedByString:@"x"];
    [SystemUserDict setObject:@{@"row" : rowandcolumn[0] , @"column" : rowandcolumn[1]} forKey:@"rowandcolumn"];
    if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO]) {
        [self CellHorizontalAlignment];
    }
    if (PageNumArrayNum == _PageNumArray.count-1) {
        PageNumArrayNum = 0;
    }else{
        PageNumArrayNum++;
    }
}

/**
 发送请求获取新数据
 */
- (void)LoadBuildingInfoData{
    [MBProgressHUD showMessage:@"後ほど..." toView:_UserListCV];
    [[SealAFNetworking NIT] PostWithUrl:ZwgetbuildinginfoType parameters:nil mjheader:nil superview:nil success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            self.BuildingArray = tmpDic[@"buildingInfo"];
            NSDictionary *buildingdict = self.BuildingArray[2];
            NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
            [SystemUserDict setValue:buildingdict[@"buildingid"] forKey:@"buildingid"];
            [SystemUserDict setValue:buildingdict[@"floorno"] forKey:@"floorno"];
            [SystemUserDict setValue:buildingdict[@"displayname"] forKey:@"displayname"];
            if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO]) {
                BOOL hasAMPM = [[NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]] rangeOfString:@"a"].location != NSNotFound;
                _BuildName.text = buildingdict[@"displayname"];
                _NowTime.text = [NSDate NeedDateFormat:[NSString stringWithFormat:@"yyyy年MM月dd日 %@%@:mm:ss",hasAMPM ? @"aa " : @"", hasAMPM ? @"hh" : @"HH"] ReturnType:returnstring date:[NSDate date]];
                [self LoadAllData];
            }
        } else {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
        }
    }defeats:^(NSError *defeats){
    }];
}
/**
 获取user数据
 */
- (void)LoadNewData{
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSString *buildingid = SystemUserDict[@"buildingid"];
    NSString *floorno = SystemUserDict[@"floorno"];
    [[SealAFNetworking NIT] PostWithUrl:ZwgetcustlistType parameters:NSDictionaryOfVariableBindings(buildingid,floorno) mjheader:nil superview:_UserListCV success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            self.UserLisrArray = tmpDic[@"custlist"];
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            if ([[NoDataLabel alloc] Show:@"データがない" SuperView:self.view DataBool:self.UserLisrArray.count])return;
            [self CellHorizontalAlignment];
        } else {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
            [[NoDataLabel alloc] Show:@"system errors" SuperView:self.view DataBool:0];
        }
    }defeats:^(NSError *defeats){
        NSLog(@"errors:%@",[defeats localizedDescription]);
//        [[TimeOutReloadButton alloc]Show:self SuperView:_UserListCV];
    }];
}
/**
 获取alert数据
 */
- (void)LoadAlertData{
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSString *buildingid = SystemUserDict[@"buildingid"];
    NSString *floorno = SystemUserDict[@"floorno"];
    [[SealAFNetworking NIT] PostWithUrl:ZwgetalertinfoType parameters:NSDictionaryOfVariableBindings(buildingid,floorno) mjheader:nil superview:nil success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            NSArray *alertarray = [NSArray arrayWithArray:tmpDic[@"alertinfo"]];
            _CurrentAlertarrays = alertarray.copy;
            _AlertBarView.AlertArray = alertarray;
            if (alertarray.count > 0) {
                //播放系统声音
//                AudioServicesPlaySystemSound(1005);
                //弹出alert框之前先dismiss
                [_UserAlert dismissViewControllerAnimated:YES completion:nil];
                //在KeyWindow上弹出alert框(每个页面都能看到)
                NSDictionary *alertdict = alertarray[alertarray.count - 1];
                BOOL hasAMPM = [[NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]] rangeOfString:@"a"].location != NSNotFound;
                NSDate *registdate = [NSDate NeedDateFormat:@"YYYY-MM-dd HH:mm:ss" ReturnType:returndate date:alertdict[@"registdate"]];
                _UserAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ %@",alertdict[@"roomname"],[NSDate NeedDateFormat:[NSString stringWithFormat:@"YYYY年MM月dd日 \n%@%@:mm:ss",hasAMPM ? @"aa " : @"", hasAMPM ? @"hh" : @"HH"] ReturnType:returnstring date:registdate]] message:[NSString stringWithFormat:@"%@ %@\nアラート通知",alertdict[@"roomname"],alertdict[@"username0"]] preferredStyle:UIAlertControllerStyleAlert];
                [_UserAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }]];
                [LGFKeyWindow.rootViewController presentViewController:_UserAlert animated:YES completion:nil];
            }
            [_UserListCV reloadData];
        } else {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
        }
    }defeats:^(NSError *defeats){
    }];
}

- (void)LoadNoticeCount{
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSDictionary *parameter = @{@"registdate":SystemUserDict[@"newnoticetime"]};
    [[SealAFNetworking NIT] PostWithUrl:ZwgetvznoticecountType parameters:parameter mjheader:nil superview:nil success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            if ([tmpDic[@"vznoticecount"] intValue] == 0) {
                _NoticeNewDataTap.alpha = 0.0;
            } else {
                _NoticeNewDataTap.alpha = 1.0;
                if ([tmpDic[@"vznoticecount"] intValue] > 99) {
                    _NoticeNewDataTap.text = @"99+";
                } else {
                    _NoticeNewDataTap.text = [NSString stringWithFormat:@"%@",tmpDic[@"vznoticecount"]];
                }
            }
        } else {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
        }
    }defeats:^(NSError *defeats){
    }];
}

/**
 登出
 */
- (IBAction)Logout:(id)sender {
    UIAlertController *testalert = [UIAlertController alertControllerWithTitle:@"" message:@"ログアウトします。よろしいですか？" preferredStyle:UIAlertControllerStyleAlert];
    [testalert addAction:[UIAlertAction actionWithTitle:@"いいえ" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
    }]];
    [testalert addAction:[UIAlertAction actionWithTitle:@"はい" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self cleanCaches];
        LGFKeyWindow.rootViewController = [MainSB instantiateViewControllerWithIdentifier:@"LoginView"];
    }]];
    [LGFKeyWindow.rootViewController presentViewController:testalert animated:YES completion:nil];
}
/**
 清除全部缓存
 */
- (void)cleanCaches{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:NITFilePath]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:NITFilePath];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [NITFilePath stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}
/**
 获取新数据
 */
- (IBAction)ButtonLoadNewData:(id)sender {

    [self LoadBuildingInfoData];
}
/**
 警报一览
 */
- (IBAction)AllAlert:(id)sender {

}
/**
 可视化设定
 */
- (IBAction)VisualSetting:(id)sender {
    [self performSegueWithIdentifier:@"DBVisualSettingPush" sender:self];
}
/**
 通知一览
 */
- (IBAction)Notice:(id)sender {
    [self performSegueWithIdentifier:@"DBNoticePush" sender:self];
    _NoticeNewDataTap.alpha = 0.0;
}
/**
 帮助
 */
- (IBAction)Help:(id)sender {
    [self performSegueWithIdentifier:@"DBHelpPush" sender:self];
}
/**
 生活リズム
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *DataDict = self.UserLisrArray[indexPath.item];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    [SystemUserDict setValue:DataDict[@"userid0"] forKey:@"userid0"];
    [SystemUserDict setValue:DataDict[@"roomid"] forKey:@"roomid"];
    [SystemUserDict setValue:DataDict[@"roomname"] forKey:@"roomname"];
    [SystemUserDict setValue:DataDict[@"username0"] forKey:@"username0"];
    [SystemUserDict removeObjectForKey:@"systemactioninfo"];
    if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO]) {
        [self performSegueWithIdentifier:@"AllChartVCPush" sender:self];
    }
}
/**
 **************** segue跳转 *****************
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

}

#pragma mark - 循环调用

/**
 自动时间
 */
- (void)AutoTime{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(AutoTime) object:nil];
    BOOL hasAMPM = [[NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]] rangeOfString:@"a"].location != NSNotFound;
    _NowTime.text = [NSDate NeedDateFormat:[NSString stringWithFormat:@"yyyy年MM月dd日 %@%@:mm:ss",hasAMPM ? @"aa " : @"", hasAMPM ? @"hh" : @"HH"] ReturnType:returnstring date:[NSDate date]];
    [self performSelector:@selector(AutoTime) withObject:nil afterDelay:1];
}
/**
 Alert监听
 */
- (void)AlertMonitor{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(AlertMonitor) object:nil];
    NSLog(@"--SYSTEM_USER_DICT--:%@",SYSTEM_USER_DICT);
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    if ([[SystemUserDict valueForKey:@"logintype"] isEqualToString:@"1"]) {
        [self LoadAllData];
        [self performSelector:@selector(AlertMonitor) withObject:nil afterDelay:alertpushnum];
    }
}

-(void)LoadAllData{
    
    [self LoadNewData];
    [self LoadAlertData];
    [self LoadNoticeCount];
}

#pragma mark - UICollectionView Delegate and DataSource

/**
 Cell横向排列
 */
-(void)CellHorizontalAlignment{
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    int Total = [SystemUserDict[@"rowandcolumn"][@"row"] intValue] * [SystemUserDict[@"rowandcolumn"][@"column"] intValue];
    pageCount = self.UserLisrArray.count;
    while (pageCount % Total != 0) ++pageCount;
    _UserPC.numberOfPages = pageCount / Total;
    [_UserListCV registerClass:[UICollectionViewCell class]
    forCellWithReuseIdentifier:@"CellWhite"];
    [_UserListCV reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return pageCount;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    return CGSizeMake(_UserListCV.width / [SystemUserDict[@"rowandcolumn"][@"column"] intValue],_UserListCV.height / [SystemUserDict[@"rowandcolumn"][@"row"] intValue]);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item >= self.UserLisrArray.count) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellWhite" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.userInteractionEnabled = NO;
        return cell;
    } else {
        UserListCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        cell.CellBGView.backgroundColor = [UIColor whiteColor];
        cell.CellBGView.layer.borderColor = NITColor(220.0, 220.0, 220.0).CGColor;
        cell.CellBGView.layer.borderWidth = 0.5;
        [cell.alert removeFromSuperview];
        NSDictionary *DataDict = self.UserLisrArray[indexPath.item];

        [cell.UserImage sd_setImageWithURL:[NSURL URLWithString:DataDict[@"picpath"]]
                  placeholderImage:[UIImage imageNamed:@"placeholderImage"]
                           options:SDWebImageRetryFailed
                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                              float showProgress = (float)receivedSize/(float)expectedSize;
                              cell.UserImage.alpha = showProgress;
                          } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              cell.UserImage.alpha = 1.0;
                          }];
        cell.RoomName.text = DataDict[@"roomname"];
        cell.UserName.text = DataDict[@"username0"];
        cell.UserSex.text = DataDict[@"usersex"];
        cell.UserAge.text = [NSString stringWithFormat:@"%@",DataDict[@"userold"]];
        cell.temperature.text = [NSString stringWithFormat:@"%@%@",DataDict[@"tvalue"],DataDict[@"tunit"]];
        NSString *str = DataDict[@"bd"];
        if ([str isEqualToString:@"明"]) {
            cell.luminance.text = @"明るい";
        } else {
            cell.luminance.text = @"暗い";
        }
        if (_CurrentAlertarrays.count > 0) {
            cell.alertArray = _CurrentAlertarrays.copy;
            cell.alerttype = DataDict[@"roomid"];
        }
        return cell;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / scrollView.width;
    _UserPC.currentPage = page;
}

-(void)dealloc{
    [NITNotificationCenter removeObserver:self];
}

@end
