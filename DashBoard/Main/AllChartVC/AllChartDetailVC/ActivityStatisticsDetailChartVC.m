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
@property (weak, nonatomic) IBOutlet NITCollectionView *ChartCV;
@property (nonatomic, strong) NSMutableArray *DataArray;
@end

@implementation ActivityStatisticsDetailChartVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self LoadNewData];
    _ChartCV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJHeaderLoadNewData)];
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)_ChartCV.mj_header];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)MJHeaderLoadNewData{
    
    [self.delegate MJGetNewData];
}

-(void)LoadNewData{
    
    NSLog(@"%@",_DayStr);
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSDictionary *parameter = @{@"userid0":SystemUserDict[@"userid0"],@"basedate":_DayStr};
    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    [[SealAFNetworking NIT] PostWithUrl:LrinfoType parameters:parameter mjheader:_ChartCV.mj_header superview:self.view success:^(id success){
        NSDictionary *tmpDic = success;
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            NSDictionary *Dict = [NSDictionary dictionaryWithDictionary:[tmpDic valueForKey:@"lrlist"]];
            _DataArray = [NSMutableArray arrayWithArray:Dict[[[Dict allKeys] firstObject]][1]];
            [[NoDataLabel alloc] Show:@"データがない" SuperView:_ChartCV DataBool:_DataArray.count];
            
            NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
            NSMutableDictionary *removedict = [SystemUserDict objectForKey:@"actionremove"];
            
            [_DataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[removedict objectForKey:obj[@"actionid"]]isEqualToString:@"1"]) {
                    [_DataArray removeObjectAtIndex:[_DataArray indexOfObject:obj]];
                }
            }];
            
            [_ChartCV reloadData];
        }else{
            NSLog(@"errors: %@",tmpDic[@"errors"]);
            [[NoDataLabel alloc] Show:[tmpDic[@"errors"] firstObject] SuperView:_ChartCV DataBool:0];
        }
    }defeats:^(NSError *defeats){
    }];
}

#pragma mark - UICollectionViewDataSource And Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _DataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityStatisticsDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityStatisticsDetailCell" forIndexPath:indexPath];
    NSDictionary *DataDict = [NSDictionary dictionaryWithDictionary:_DataArray[indexPath.item]];
    cell.DeciceName.text = DataDict[@"actionname"];
    UIView *ChartView = [[LGFBarChart alloc]initWithFrame:cell.DeviceDataView.bounds BarData:DataDict BarType:1];
    [cell.DeviceDataView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.DeviceDataView addSubview:ChartView];
    return cell;
}

@end
