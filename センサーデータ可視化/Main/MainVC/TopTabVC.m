//
//  TopTabVC.m
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/19.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import "TopTabVC.h"
#import "AlertBar.h"
#import "OneVCCell.h"
#import "OneVCModel.h"
#import "OneVCDetailMain.h"

@interface CollectionCellWhite : OneVCCell

@end

@implementation CollectionCellWhite

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end

@interface TopTabVC ()
{
    UIView  *vcview;
}
@property (weak, nonatomic) IBOutlet UIPageControl *OnePageView;
@property (weak, nonatomic) IBOutlet UICollectionView *TestUserListCV;
@property (weak, nonatomic) IBOutlet AlertBar *AlertBarView;
@property (weak, nonatomic) IBOutlet UILabel *NowTime;
@property (nonatomic, strong) NSMutableArray *mimamorareruArray;
@property (nonatomic, assign) NSUInteger pageCount;
@end

@implementation TopTabVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // [self addPagerController];
    
    [NITUserDefaults setObject:@"0" forKey:@"logintype"];
    
    _NowTime.text = [[NSDate date]needDateStatus:JapanHMSType];
    [self performSelector:@selector(autoTime) withObject:nil afterDelay:1];
    
    [self collectionViewsets];
    [self loadNewData];
}

- (void)autoTime{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoTime) object:nil];
    _NowTime.text = [[NSDate date]needDateStatus:JapanHMSType];
    [self performSelector:@selector(autoTime) withObject:nil afterDelay:1];
}
- (IBAction)logout:(id)sender {
    UIStoryboard *notificationsb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TopTabVC *vc = [notificationsb instantiateViewControllerWithIdentifier:@"LoginView"];
    MasterKeyWindow.rootViewController = vc;
}
- (IBAction)getnewdata:(id)sender {
    [self loadNewData];
}

/**
 *  发送请求获取新数据
 */
- (void)loadNewData{
    
    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    //body 参数
    NSString *userid1 = [NITUserDefaults objectForKey:@"userid1"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userid1"] = userid1;
    parameters[@"hassensordata"] = @"1";
    [[SealAFNetworking NIT] PostWithUrl:UserURLType parameters:parameters mjheader:self.TestUserListCV.mj_header superview:self.view success:^(id success){
        NSDictionary *tmpDic = success;
        NSArray *lifeUsersArr = [OneVCModel mj_objectArrayWithKeyValuesArray:[tmpDic objectForKey:@"custlist"]];
        if (lifeUsersArr.count == 0) {
            [_mimamorareruArray removeAllObjects];
            [MBProgressHUD showError:@"見守り対象者を追加してください" toView:self.view];
        }else{
            _mimamorareruArray = [NSMutableArray array];
            for (int i = 0; i<12; i++) {
                
                if(i==1){
                    [_mimamorareruArray addObject:lifeUsersArr[1]];
                }else{
                    [_mimamorareruArray addObject:lifeUsersArr[0]];
                }
            }
            //            _mimamorareruArray = [NSMutableArray arrayWithArray:lifeUsersArr];
        }
        _OnePageView.numberOfPages = _mimamorareruArray.count%6;
        _pageCount = _mimamorareruArray.count;
        //一排显示四个,两排就是八个
        while (_pageCount % 6 != 0) {
            ++_pageCount;
            NSLog(@"%zd", _pageCount);
        }
        [self.view addSubview:self.OnePageView];
        [self.TestUserListCV reloadData];
        
        NSMutableArray *AlertArray = [NSMutableArray array];
        for (OneVCModel *model in _mimamorareruArray) {
            if (![model.resultname isEqualToString:@"設定なし"]&&![model.resultname isEqualToString:@"異常検知なし"]) {
                [AlertArray addObject:[NSString stringWithFormat:@"%@ %@",model.roomname,@"14:12"]];
            }
        }
        _AlertBarView.AlertArray = AlertArray;
        
    }defeats:^(NSError *defeats){
    }];
}

-(void)collectionViewsets{
    
    UICollectionViewFlowLayout *layout = [LWLCollectionViewHorizontalLayout new];
    CGSize itemSize = CGSizeMake(self.TestUserListCV.width/3,self.TestUserListCV.height/2);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = itemSize;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.TestUserListCV.collectionViewLayout = layout;
    self.TestUserListCV.showsHorizontalScrollIndicator = NO;
    self.TestUserListCV.pagingEnabled =YES;
    //    self.collectionView.bounces = NO;
    [self.TestUserListCV registerClass:[CollectionCellWhite class]
            forCellWithReuseIdentifier:@"CellWhite"];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _pageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    OneVCCell *cell = nil;
    if (indexPath.item >= _mimamorareruArray.count) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellWhite"
                                                         forIndexPath:indexPath];
        cell.userInteractionEnabled = NO;
    } else {
        cell = [OneVCCell cellWithTableView:self.TestUserListCV indexPath:indexPath];
        OneVCModel *model = _mimamorareruArray[indexPath.item];
        cell.RoomName.text = model.roomname;
        cell.UserName.text = model.user0name;
        [cell.UserImage setImage:[UIImage imageNamed:indexPath.item==0 ? @"headwoman" : @"headman"]];
        cell.UserAge.text = @"70";
        cell.UserSex.text = indexPath.item==0 ? @"女性" : @"男性";
        cell.temperature.text = [NSString stringWithFormat:@"%0.1f%@",[model.tvalue floatValue],model.tunit];
        cell.luminance.text = model.bd;
        if (![model.resultname isEqualToString:@"設定なし"]&&![model.resultname isEqualToString:@"異常検知なし"]) {
            cell.alerttype = @"1";
        }else{
            cell.alerttype = @"0";
        }
    }
    return cell;
}

//ShowChartPush
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"ShowChartPush" sender:self];
}

//segue跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"ShowChartPush"]){
        
        OneVCDetailMain *vc = segue.destinationViewController;
        NSIndexPath *indexPath = self.TestUserListCV.indexPathsForSelectedItems.firstObject;
        vc.model = _mimamorareruArray[indexPath.item];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int page = scrollView.contentOffset.x / scrollView.width;
    NSLog(@"%d",page);
    self.OnePageView.currentPage = page;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
