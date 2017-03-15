//
//  ActivityStatisticsChartVC.m
//  DashBoard
//
//  Created by totyu3 on 17/2/17.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "ActivityStatisticsChartVC.h"
#import "LGFChartNumBar.h"

@interface ActivityStatisticsChartCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *DeviceColorView;
@property (weak, nonatomic) IBOutlet UILabel *DeciceName;
@property (weak, nonatomic) IBOutlet UIView *DeviceDataView;
@end
@implementation ActivityStatisticsChartCell
@end

@interface ActivityStatisticsChartVC ()
@property (weak, nonatomic) IBOutlet NITCollectionView *ChartCV;
@property (weak, nonatomic) IBOutlet LGFChartNumBar *ChartNum;
@property (nonatomic, strong) NSMutableArray *DataArray;
@end

@implementation ActivityStatisticsChartVC

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

    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSLog(@"%@,%@号房间,活动集计传入日期：%@",SystemUserDict[@"userid0"],SystemUserDict[@"roomid"],_DayStr);
    NSDictionary *parameter = @{@"userid0":SystemUserDict[@"userid0"],@"basedate":_DayStr,@"sumflg":_SumFlg};
    [MBProgressHUD showMessage:@"後ほど..." toView:self.view];
    [[SealAFNetworking NIT] PostWithUrl:LrsuminfoType parameters:parameter mjheader:_ChartCV.mj_header superview:self.view success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            NSArray *datesArray = [tmpDic valueForKey:@"dates"];
            _ChartNum.YValuesArray = [NSArray arrayWithArray:datesArray];
            _DataArray = [NSMutableArray arrayWithArray:[tmpDic valueForKey:@"lrsumlist"]];
            if ([[NoDataLabel alloc] Show:@"データがない" SuperView:_ChartCV DataBool:_DataArray.count])return;
            NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
            NSMutableArray *systemactioninfo = [NSMutableArray arrayWithArray:[SystemUserDict objectForKey:@"systemactioninfo"]];
            
            NSMutableArray *DataArrayCopy = [_DataArray mutableCopy];
            
            int selecttype = 0;
      
            for (NSDictionary *DataDict in DataArrayCopy) {
                
                for (NSDictionary *removedict in systemactioninfo) {
                    if ([removedict[@"actionid"] isEqualToString:DataDict[@"actionid"]]) {
                        
                        if (removedict[@"selecttype"]) {
                            if ([removedict[@"selecttype"] isEqualToString:@"YES"]) {
                                [_DataArray removeObject:DataDict];
                            }
                        }
                    }
                    if ([removedict[@"actionselect"] isEqualToString:@"YES"]) {
                        selecttype = 1;
                    }
                }
            }
            
            if (selecttype==1) {
                for (NSDictionary *DataDict in DataArrayCopy) {
                    if (DataDict.count==8) {
                        [_DataArray removeObject:DataDict];
                    }
                }
            }
            

            [_ChartCV reloadData];
        
        }else{
            NSLog(@"errors: %@",tmpDic[@"errors"]);
            [[NoDataLabel alloc] Show:@"system errors" SuperView:_ChartCV DataBool:0];
        }
    }defeats:^(NSError *defeats){
    }];
}

#pragma mark - UICollectionViewDataSource And Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _DataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_ChartCV.width,_ChartCV.height/3);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityStatisticsChartCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityStatisticsChartCell" forIndexPath:indexPath];
    NSDictionary *DataDict = [NSDictionary dictionaryWithDictionary:_DataArray[indexPath.item]];

    cell.DeciceName.text = DataDict[@"actionname"];
    cell.DeviceColorView.backgroundColor = [UIColor colorWithHex:DataDict[@"actioncolor"]];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    UIView *ChartView = [[LGFLineChart alloc]initWithFrame:cell.DeviceDataView.bounds LineDict:DataDict LineType:[[NSString stringWithFormat:@"%@",DataDict[@"actionsummary"]] isEqualToString:@"1"] ? 1 : 2];
    [cell.DeviceDataView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.DeviceDataView addSubview:ChartView];
    return cell;
}

@end
