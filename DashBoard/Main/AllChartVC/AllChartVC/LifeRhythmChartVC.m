//
//  LifeRhythmChartVC.m
//  DashBoard
//
//  Created by totyu3 on 17/2/13.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "LifeRhythmChartVC.h"
#import "AllChartDetailVC.h"

@interface LifeRhythmChartCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *WeekTitle;
@property (weak, nonatomic) IBOutlet UIView *DayDataView;
@property (weak, nonatomic) IBOutlet UILabel *DayTitle;
@end
@implementation LifeRhythmChartCell

@end

@interface LifeRhythmChartVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *ChartCV;
@property (nonatomic, strong) NSArray *WeekArray;
@property (nonatomic, strong) NSArray *DataArray;
@end

@implementation LifeRhythmChartVC

-(NSArray *)WeekArray{
    if (!_WeekArray) {
        _WeekArray = @[@"月",@"火",@"水",@"木",@"金",@"土",@"日"];
    }
    return _WeekArray;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self LoadNewData];
    _ChartCV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJHeaderLoadNewData)];
    [NITRefreshInit MJRefreshNormalHeaderInit:(MJRefreshNormalHeader*)_ChartCV.mj_header];
    [NITNotificationCenter addObserver:self selector:@selector(ReloadData) name:_LoadCSNotificationName object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)MJHeaderLoadNewData{
    [self.delegate MJGetNewData];
}

-(void)LoadNewData{
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    NSLog(@"%@,%@号房间,生活一览传入日期：%@",SystemUserDict[@"userid0"],SystemUserDict[@"roomid"],_DayStr);
    NSDictionary *parameter = @{@"userid0":SystemUserDict[@"userid0"],@"basedate":_DayStr};
    [MBProgressHUD showMessage:@"後ほど..." toView:_ChartCV];
    [[SealAFNetworking NIT] PostWithUrl:WeeklylrinfoType parameters:parameter mjheader:_ChartCV.mj_header superview:_ChartCV success:^(id success){
        NSDictionary *tmpDic = [LGFNullCheck CheckNSNullObject:success];
        if ([tmpDic[@"code"] isEqualToString:@"200"]) {
            _DataArray = [NSArray arrayWithArray:[tmpDic valueForKey:@"lrlist"]];
            [[NoDataLabel alloc] Show:@"データがない" SuperView:_ChartCV DataBool:_DataArray.count];
            [self ReloadData];
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
    [_ChartCV reloadData];
}

#pragma mark - UICollectionViewDataSource And Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _DataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_ChartCV.width,_ChartCV.height / 7);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LifeRhythmChartCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LifeRhythmChartCell" forIndexPath:indexPath];
    if ([_DataArray[indexPath.item]isKindOfClass:[NSDictionary class]] || [_DataArray[indexPath.item]isKindOfClass:[NSMutableDictionary class]]) {
        NSDictionary *DataDict = [NSDictionary dictionaryWithDictionary:_DataArray[indexPath.item]];
        cell.WeekTitle.text = self.WeekArray[indexPath.row];
        cell.DayTitle.text = [[DataDict allKeys] firstObject];
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        NSString *SelectDate = [[DataDict allKeys] firstObject];
        NSArray *ActionArray = [NSArray arrayWithArray:DataDict[SelectDate][1]];
        [cell.DayDataView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UIView *ChartView = [[LGFBarChart alloc]initWithFrame:cell.DayDataView.bounds BarData:ActionArray BarType:1];
        [cell.DayDataView addSubview:ChartView];
    } else {
        cell.alpha = 0.0;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"AllChartDetailVCPush" sender:self];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"AllChartDetailVCPush"]){
        //传感器数据图表
        AllChartDetailVC *advc = segue.destinationViewController;
        NSIndexPath *indexPath = _ChartCV.indexPathsForSelectedItems.lastObject;
        NSDictionary *DataDict = [NSDictionary dictionaryWithDictionary:_DataArray[indexPath.item]];
        advc.SelectDay = [[DataDict allKeys] firstObject];
        advc.Weekdate = _WeekArray[indexPath.item];
    }
}

- (void)dealloc{
    [NITNotificationCenter removeObserver:self];
}
@end
