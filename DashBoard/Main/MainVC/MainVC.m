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
#import "LGFDropDown.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import <UserNotifications/UserNotifications.h>
#import <objc/runtime.h>

@interface MainVC ()<LGFDropDownDelegate>
{
    NSInteger pageCount;
    NSInteger PageNumArrayNum;
}
@property (weak, nonatomic) IBOutlet UIPageControl *UserPC;
@property (weak, nonatomic) IBOutlet AlertBar *AlertBarView;
@property (weak, nonatomic) IBOutlet UILabel *NowTime;
@property (weak, nonatomic) IBOutlet UICollectionView *UserListCV;
@property (weak, nonatomic) IBOutlet UILabel *NoticeNewDataTap;
@property (weak, nonatomic) IBOutlet UIButton *PageNumBtn;
@property (weak, nonatomic) IBOutlet LGFDropDown *BuildName;
@property (nonatomic, strong) NSArray *LoadAlertArray;
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
    [self LoadAlertData];
    [self LoadNoticeCount];
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
        _PageNumArray = @[@"4x5",@"5x6",@"6x7"];
        _PageTitleArray = @[@"大",@"中",@"小"];
    }else{
        _PageNumArray = @[@"2x4",@"3x5"];
        _PageTitleArray = @[@"大",@"中"];
    }
    PageNumArrayNum = 0;
    [self SelectPageNum:_PageNumBtn];
}

-(void)DidBecomeActive {
//    [self LoadBuildingInfoData];
    _AlertBarView.AlertArray = _LoadAlertArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _AlertBarView.AlertArray = _LoadAlertArray;
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
    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSString *staffid = SystemUserDict[@"staffid"];
    NSString *hostcd = SystemUserDict[@"hostcd"];
    [[SealAFNetworking NIT] PostWithUrl:ZwgetbuildinginfoType parameters:NSDictionaryOfVariableBindings(staffid,hostcd) mjheader:nil superview:self.view success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            _BuildName.delegate = self;
            _BuildName.DefaultTitle = tmpDic[@"buildingInfo"][0][@"facilityname2"];
            _BuildName.DataArray = tmpDic[@"buildingInfo"];
            [_BuildName selectRow:[SystemUserDict[@"mainvcrow"] integerValue] childrow:[SystemUserDict[@"mainvcchildrow"] integerValue]];
        } else {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
        }
    }defeats:^(NSError *defeats){
    }];
}
/**
 设施下拉框 代理
 */
-(void)nowSelectRow:(NSString *)selecttitle selectrow:(NSInteger)selectrow{
    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    [SystemUserDict setValue:selecttitle forKey:@"facilityname2floorno"];
    if ([SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO]) {
        BOOL hasAMPM = [[NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]] rangeOfString:@"a"].location != NSNotFound;
        _NowTime.text = [NSDate NeedDateFormat:[NSString stringWithFormat:@"yyyy年MM月dd日 %@%@:mm:ss",hasAMPM ? @"aa " : @"", hasAMPM ? @"hh" : @"HH"] ReturnType:returnstring date:[NSDate date]];
        [self LoadCustListData];
    }
}
/**
 获取user数据
 */
- (void)LoadCustListData{
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSString *facilitycd = SystemUserDict[@"mainvcfacilitycd"];
    NSString *floorno = SystemUserDict[@"mainvcfloorno"];
    NSString *staffid = SystemUserDict[@"staffid"];
    NSString *hostcd = SystemUserDict[@"hostcd"];
    if (facilitycd && staffid && floorno) {
        [[SealAFNetworking NIT] PostWithUrl:ZwgetcustlistType parameters:NSDictionaryOfVariableBindings(facilitycd,floorno,staffid,hostcd) mjheader:nil superview:self.view success:^(id success){
            NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
            if ([tmpDic[@"code"] isEqualToString:@"200"]) {
                self.UserLisrArray = tmpDic[@"custlist"];
                [[SDImageCache sharedImageCache] clearDisk];
                [[SDImageCache sharedImageCache] clearMemory];
                [[NoDataLabel alloc] Show:@"データがない" SuperView:self.view DataBool:self.UserLisrArray.count];
                [self CellHorizontalAlignment];
            } else {
                NSLog(@"errors: %@",tmpDic[@"errors"]);
                [MBProgressHUD showError:@"system errors" toView:self.view];
//                [[NoDataLabel alloc] Show:@"system errors" SuperView:self.view DataBool:0];
            }
        }defeats:^(NSError *defeats){
            NSLog(@"errors:%@",[defeats localizedDescription]);
//            [CATransaction setCompletionBlock:^{
//                [[TimeOutReloadButton alloc]Show:self SuperView:_UserListCV];
//            }];
        }];
    }
}
/**
 获取alert数据
 */
- (void)LoadAlertData{
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
//    NSString *facilitycd = SystemUserDict[@"mainvcfacilitycd"];
//    NSString *floorno = SystemUserDict[@"mainvcfloorno"];
    NSString *staffid = SystemUserDict[@"staffid"];
    [[SealAFNetworking NIT] PostWithUrl:ZwgetalertinfoType parameters:NSDictionaryOfVariableBindings(staffid) mjheader:nil superview:nil success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            _LoadAlertArray = [NSArray arrayWithArray:tmpDic[@"alertinfo"]];
            _CurrentAlertarrays = _LoadAlertArray.copy;
            _AlertBarView.AlertArray = _LoadAlertArray;
            NSArray *LoadHistoryArray = [NSArray arrayWithArray:tmpDic[@"historyinfo"]];
            if (_LoadAlertArray.count > 0) {
                NSDictionary *alertdict = _LoadAlertArray[_LoadAlertArray.count - 1];
                [self PostAlertNotice:alertdict alerttype:@"alertinfo"];
            }
            for (NSDictionary *historydict in LoadHistoryArray) {
                [self PostAlertNotice:historydict alerttype:@"historyinfo"];
            }
            [SystemUserDict setValue:[NSString stringWithFormat:@"%ld",LoadHistoryArray.count] forKey:@"historyinfocount"];
            [SystemUserDict writeToFile:SYSTEM_USER_DICT atomically:NO];
            [_UserListCV reloadData];
        } else {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
        }
    }defeats:^(NSError *defeats){
    }];
}

-(void)PostAlertNotice:(NSDictionary*)AlertDict alerttype:(NSString*)alerttype{
    //播放系统声音
    //                AudioServicesPlaySystemSound(1005);
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    BOOL hasAMPM = [[NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]] rangeOfString:@"a"].location != NSNotFound;
    NSDate *registdate;
    NSString *title;
    NSString *body;
    if ([alerttype isEqualToString:@"alertinfo"]) {
        registdate = [NSDate NeedDateFormat:@"YYYY-MM-dd HH:mm:ss" ReturnType:returndate date:AlertDict[@"registdate"]];
        title = [NSString stringWithFormat:@"%@",[NSDate NeedDateFormat:[NSString stringWithFormat:@"YYYY年MM月dd日 \n%@%@:mm:ss",hasAMPM ? @"aa " : @"", hasAMPM ? @"hh" : @"HH"] ReturnType:returnstring date:registdate]];
        body = [NSString stringWithFormat:@"%@ %@\n異常検知ありました\n%@ %@",AlertDict[@"roomname"],AlertDict[@"username0"],AlertDict[@"userid1"],AlertDict[@"username1"]];
    } else {
        registdate = [NSDate NeedDateFormat:@"YYYY-MM-dd HH:mm" ReturnType:returndate date:AlertDict[@"registdate"]];
        title = [NSString stringWithFormat:@"%@",[NSDate NeedDateFormat:[NSString stringWithFormat:@"YYYY年MM月dd日 \n%@%@:mm",hasAMPM ? @"aa " : @"", hasAMPM ? @"hh" : @"HH"] ReturnType:returnstring date:registdate]];
        body = [NSString stringWithFormat:@"%@ %@\nセンサーの設置情報が更新されました\n%@\n%@ %@",AlertDict[@"roomname"],AlertDict[@"username0"],[SystemUserDict[@"systemusertype"] isEqualToString:@"1"] ? @"【可視化設定情報を確認してください】" : @"【可視化設定情報を現在確認しています】",AlertDict[@"userid1"],AlertDict[@"username1"]];
    }
    NSString *Identifier = [NSString stringWithFormat:@"%@%@%@",AlertDict[@"roomname"],AlertDict[@"username0"],alerttype];
    if(SYSREM_VERSION(10.0)){
        //创建通知
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
        UNNotificationAction * actionone = [UNNotificationAction actionWithIdentifier:@"actionone" title:@"OK" options:UNNotificationActionOptionNone];
        UNNotificationCategory * category = [UNNotificationCategory categoryWithIdentifier:Identifier actions:@[actionone] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        //内容
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = title;
        content.subtitle = @"";
        content.body = body;
        content.badge = @1;
        content.categoryIdentifier = Identifier;
        content.sound = [UNNotificationSound defaultSound];
        content.userInfo = @{@"alerttype" : alerttype};
        NSString *requestIdentifier = Identifier;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier
                                                                              content:content
                                                                              trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category, nil]];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"推送已添加成功 %@", requestIdentifier);
            }
        }];
    }else{
        UILocalNotification *localNote = [[UILocalNotification alloc] init];
        localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        localNote.soundName = UILocalNotificationDefaultSoundName;
        localNote.timeZone=[NSTimeZone defaultTimeZone];
        localNote.alertBody = body;
        localNote.alertTitle = title;
        localNote.applicationIconBadgeNumber = 1;
        localNote.userInfo = @{@"alerttype" : alerttype};
        [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
    }
}

- (void)LoadNoticeCount{
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSString *registdate = SystemUserDict[@"newnoticetime"];
    NSString *staffid = SystemUserDict[@"staffid"];
    [[SealAFNetworking NIT] PostWithUrl:ZwgetvznoticecountType parameters:NSDictionaryOfVariableBindings(registdate,staffid) mjheader:nil superview:nil success:^(id success){
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
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(AutoTime) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(AlertMonitor) object:nil];
}
/**
 获取新数据
 */
- (IBAction)ButtonLoadNewData:(id)sender {
    [self LoadBuildingInfoData];
    [self LoadAlertData];
    [self LoadNoticeCount];
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
        [self LoadNewData];
        [self performSelector:@selector(AlertMonitor) withObject:nil afterDelay:alertpushnum];
    }
}

-(void)LoadNewData{
    [self LoadCustListData];
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
    if ((pageCount / Total) <= 1) {
        [_UserPC setHidden:YES];
    } else {
        [_UserPC setHidden:NO];
    }
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
        cell.RoomName.text = DataDict[@"roomid"];
        cell.UserName.text = DataDict[@"username0"];
        cell.UserSex.text = DataDict[@"usersex"];
        cell.UserAge.text = [NSString stringWithFormat:@"%@",DataDict[@"userold"]];
        cell.temperature.text = [NSString stringWithFormat:@"%@%@",DataDict[@"tvalue"],DataDict[@"tunit"]];
        NSString *str = DataDict[@"bd"];
        if ([str isEqualToString:@"明"]) {
            cell.luminance.text = @"明るい";
        } else if([str isEqualToString:@"暗"]){
            cell.luminance.text = @"暗い";
        } else {
            cell.luminance.text = @"";
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
