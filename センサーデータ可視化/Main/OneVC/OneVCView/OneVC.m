//
//  OneVC.m
//  センサーデータ可視化
//
//  Created by totyu3 on 16/12/21.
//  Copyright © 2016年 LGF. All rights reserved.
//

#import "OneVC.h"
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

@interface OneVC ()
@property (nonatomic, strong) NSMutableArray *mimamorareruArray;
@property (nonatomic, strong) UIPageControl *OnePageView;
@property (nonatomic, assign) NSUInteger pageCount;
@end

@implementation OneVC

-(UIPageControl *)OnePageView{
    
    if (!_OnePageView) {
        _OnePageView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, NITScreenH-220, NITScreenW, 30)];
        _OnePageView.pageIndicatorTintColor = [UIColor lightGrayColor];
        _OnePageView.currentPageIndicatorTintColor = [UIColor blackColor];
        _OnePageView.numberOfPages = _pageCount<7 ? 0 : _pageCount/6;
        _OnePageView.userInteractionEnabled = NO;
        int page = self.collectionView.contentOffset.x / self.collectionView.width;
        _OnePageView.currentPage = page;
    }
    return _OnePageView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self collectionViewsets];
    [self loadNewData];
    [NITNotificationCenter addObserver:self selector:@selector(loadNewData) name:@"loadnewdata" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
//    [self loadNewData];
    
//    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)self.collectionView.mj_header];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [self.OnePageView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
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
    [[SealAFNetworking NIT] PostWithUrl:UserURLType parameters:parameters mjheader:self.collectionView.mj_header superview:self.view success:^(id success){
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
        _pageCount = _mimamorareruArray.count;
        
        //一排显示四个,两排就是八个
        while (_pageCount % 6 != 0) {
            ++_pageCount;
            NSLog(@"%zd", _pageCount);
        }
        [self.view addSubview:self.OnePageView];
        [self.collectionView reloadData];
        
        NSMutableArray *AlertArray = [NSMutableArray array];
        for (OneVCModel *model in _mimamorareruArray) {
            if (![model.resultname isEqualToString:@"設定なし"]&&![model.resultname isEqualToString:@"異常検知なし"]) {
                [AlertArray addObject:[NSString stringWithFormat:@"%@ %@",model.roomname,@"14:12"]];
            }
        }
        
        [NITNotificationCenter removeObserver:self name:@"getalertarray" object:nil];
        //创建一个消息对象
        NSNotification * notice = [NSNotification notificationWithName:@"getalertarray" object:nil userInfo:@{@"AlertArray" : AlertArray}];
        //发送消息
        [NITNotificationCenter postNotification:notice];
        
    }defeats:^(NSError *defeats){
    }];
}

-(void)collectionViewsets{
    
    UICollectionViewFlowLayout *layout = [LWLCollectionViewHorizontalLayout new];
    CGSize itemSize = CGSizeMake(self.collectionView.width/3,(self.collectionView.height-185)/2);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = itemSize;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled =YES;
//    self.collectionView.bounces = NO;
    [self.collectionView registerClass:[CollectionCellWhite class]
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
        cell = [OneVCCell cellWithTableView:self.collectionView indexPath:indexPath];
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
        NSIndexPath *indexPath = self.collectionView.indexPathsForSelectedItems.firstObject;
        vc.model = _mimamorareruArray[indexPath.item];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    int page = scrollView.contentOffset.x / scrollView.width;
    NSLog(@"%d",page);
    self.OnePageView.currentPage = page;
}


@end
