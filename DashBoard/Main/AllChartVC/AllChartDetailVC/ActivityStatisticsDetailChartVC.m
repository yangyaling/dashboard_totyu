//
//  ActivityStatisticsDetailChartVC.m
//  DashBoard
//
//  Created by totyu3 on 17/2/14.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "ActivityStatisticsDetailChartVC.h"

@interface ActivityStatisticsDetailCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *DeciceName;
@property (weak, nonatomic) IBOutlet UIView *DeviceDataView;
@end
@implementation ActivityStatisticsDetailCell
@end

@interface ActivityStatisticsDetailChartVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *ChartCV;
@property (nonatomic, strong) NSMutableArray *DataArray;
@property (nonatomic, strong) NSMutableArray *LrList;
@property (nonatomic, strong) NSString *indexSelectedStr;
@end

@implementation ActivityStatisticsDetailChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self LoadNewData];
    _ChartCV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJHeaderLoadNewData)];
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)_ChartCV.mj_header];
    [NITNotificationCenter addObserver:self selector:@selector(ReloadData) name:_LoadCSNotificationName object:nil];
}

-(void)MJHeaderLoadNewData{
    [self.delegate MJGetNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)LoadNewData{
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSLog(@"%@,%@号房间,活动详细传入日期：%@",SystemUserDict[@"userid0"],SystemUserDict[@"roomid"],_DayStr);
    NSDictionary *parameter = @{@"userid0":SystemUserDict[@"userid0"],@"basedate":_DayStr};
    [MBProgressHUD showMessage:@"後ほど..." toView:_ChartCV];
    [[SealAFNetworking NIT] PostWithUrl:LrinfoType parameters:parameter mjheader:_ChartCV.mj_header superview:_ChartCV success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            NSDictionary *Dict = [NSDictionary dictionaryWithDictionary:[tmpDic valueForKey:@"lrlist"]];
            _LrList  = [NSMutableArray arrayWithArray:Dict[[[Dict allKeys] firstObject]][1]];
            if ([[NoDataLabel alloc] Show:@"データがない" SuperView:_ChartCV DataBool:_LrList.count]) {
                [self ReloadData];
            }
        } else {
            NSLog(@"errors: %@",tmpDic[@"errors"]);
            [MBProgressHUD showError:@"system errors" toView:_ChartCV];
//            [[NoDataLabel alloc] Show:@"system errors" SuperView:_ChartCV DataBool:0];
        }
    }defeats:^(NSError *defeats){
        NSLog(@"errors:%@",[defeats localizedDescription]);
        [CATransaction setCompletionBlock:^{
            [[TimeOutReloadButton alloc]Show:self SuperView:_ChartCV];
        }];
    }];
}

-(void)ReloadData{
    _DataArray = [NSMutableArray arrayWithArray:_LrList];
    if (_DataArray.count > 0){
        NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
        NSMutableArray *systemactioninfo = [NSMutableArray arrayWithArray: [SystemUserDict objectForKey:@"systemactioninfo"]];
        NSMutableArray *DataArrayCopy = [_DataArray mutableCopy];
        for (NSDictionary *DataDict in DataArrayCopy) {
            for (NSDictionary *removedict in systemactioninfo) {
                if ([removedict[@"actionid"] isEqualToString:DataDict[@"actionid"]]) {
                    if (removedict[@"selecttype"]) {
                        if ([removedict[@"selecttype"] isEqualToString:@"YES"]) {
                            [_DataArray removeObject:DataDict];
                        }
                    }
                }
            }
        }
    }
    [_ChartCV reloadData];
}

#pragma mark - UICollectionViewDataSource And Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _DataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_ChartCV.width,_ChartCV.height / 6);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ActivityStatisticsDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityStatisticsDetailCell" forIndexPath:indexPath];
    NSDictionary *DataDict = [NSDictionary dictionaryWithDictionary:_DataArray[indexPath.item]];
    cell.DeciceName.text = DataDict[@"actionname"];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    [cell.DeviceDataView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *ChartView = [[LGFBarChart alloc]initWithFrame:cell.DeviceDataView.bounds BarData:DataDict BarType:1];
    [cell.DeviceDataView addSubview:ChartView];
    return cell;
}

- (void)dealloc{
    [NITNotificationCenter removeObserver:self];
}
@end
