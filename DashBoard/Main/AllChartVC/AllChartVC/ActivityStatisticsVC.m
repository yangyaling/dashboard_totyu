//
//  ActivityStatisticsVC.m
//  DashBoard
//
//  Created by totyu3 on 17/1/20.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "ActivityStatisticsVC.h"
#import "ActivityStatisticsChartVC.h"
#import "ColorSelectionCV.h"
#import "NITSegmented.h"

@interface ActivityStatisticsVC ()<LGFClandarDelegate,ActivityStatisticsChartVCDelegate>
{
    NSInteger TimeSelectSegIndex;
    int TotalRange;
    int ScrollPage;
}
@property (weak, nonatomic) IBOutlet UILabel *FloorTitle;
@property (weak, nonatomic) IBOutlet UILabel *RoomTitle;
@property (weak, nonatomic) IBOutlet UILabel *UserNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *TimeFrameTitle;
@property (weak, nonatomic) IBOutlet NITSegmented *TimeSelectSeg;
@property (weak, nonatomic) IBOutlet UICollectionView *PageCV;
@property (weak, nonatomic) IBOutlet UIView *ColorSelectionView;

@property (strong, nonatomic) NSMutableArray *controlarr;
@property (nonatomic, strong) NSDate *SelectDate;
@property (nonatomic, copy) NSString *LoadCSNotificationName;
@property (nonatomic, copy) NSString *SelectSumFlg;
@end

@implementation ActivityStatisticsVC

static NSString * const reuseIdentifier = @"ActivityStatisticsPageCell";
/**
 视图控制器数组
 */
-(NSMutableArray *)controlarr{
    if (!_controlarr) {
        NSMutableArray *reverscontrolarr = [NSMutableArray array];
        for (int i = 0; i<= TotalRange; i++) {
            ActivityStatisticsChartVC *ascvc = [MainSB instantiateViewControllerWithIdentifier:@"ActivityStatisticsChartVCSB"];   
            if (TimeSelectSegIndex == 0) {//日
                if (i == 0) {
                    ascvc.DayStr = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:_SelectDate];
                } else {
                    ActivityStatisticsChartVC *Previousascvc = reverscontrolarr[i - 1];
                    NSDate *Previousdate = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returndate date:Previousascvc.DayStr];
                    int week = (int)[NSDate nowTimeType:LGFweek time:Previousdate];
                    ascvc.DayStr = [NSDate SotherDay:Previousdate symbols:LGFMinus dayNum:week];
                }
                ascvc.SumFlg = @"d";
                    
            }else if(TimeSelectSegIndex == 1){//周
                if (i == 0) {
                    ascvc.DayStr = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:_SelectDate];
                } else {
                    ActivityStatisticsChartVC *Previousascvc = reverscontrolarr[i - 1];
                    NSDate *Previousdate = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returndate date:Previousascvc.DayStr];
                    NSString *tmpdate = [NSDate getThreeMonthDate:Previousdate];
                    ascvc.DayStr = tmpdate;
                }
                ascvc.SumFlg = @"w";
            }else if(TimeSelectSegIndex == 2){//月
                if (i == 0) {
                    ascvc.DayStr = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:_SelectDate];
                } else {
                    ActivityStatisticsChartVC *Previousascvc = reverscontrolarr[i - 1];
                    NSDate *Previousdate = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returndate date:Previousascvc.DayStr];
                    ascvc.DayStr = [NSDate SotherDay:Previousdate symbols:LGFMinus dayNum:[[NSDate NeedDateFormat:@"DD" ReturnType:returnstring date:Previousdate] intValue]];
                }
                ascvc.SumFlg = @"m";
            }else if(TimeSelectSegIndex == 3){//年 q
                if (i == 0) {
                    ascvc.DayStr = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:_SelectDate];
                } else {
                    ActivityStatisticsChartVC *Previousascvc = reverscontrolarr[i - 1];
                    NSDate *Previousdate = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returndate date:Previousascvc.DayStr];
                    ascvc.DayStr = [NSDate GetTenYearDate:Previousdate];
                }
                ascvc.SumFlg = @"y";
            }
            ascvc.delegate = self;
            [self addChildViewController:ascvc];
            [reverscontrolarr addObject:ascvc];
        }
        _controlarr = [NSMutableArray arrayWithArray:[[reverscontrolarr reverseObjectEnumerator]allObjects]];
    }
    return _controlarr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _LoadCSNotificationName = @"ActivityStatisticsVCLCSNN";
    [_PageCV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [_ColorSelectionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    ColorSelectionCV *cscv = [MainSB instantiateViewControllerWithIdentifier:@"ColorSelectionSB"];
    cscv.LoadCSNotificationName = _LoadCSNotificationName;
    [self addChildViewController:cscv];
    [_ColorSelectionView layoutIfNeeded];
    UIView *view = [cscv view];
    view.size = _ColorSelectionView.size;
    [_ColorSelectionView addSubview:view];
    
    //设置楼层信息
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    _FloorTitle.text = SystemUserDict[@"facilityname2floorno"];
    _RoomTitle.text = SystemUserDict[@"roomid"];
    _UserNameTitle.text = SystemUserDict[@"username0"];
    //添加 SystemReloadColor 通知
    [NITNotificationCenter addObserver:self selector:@selector(ReloadColor:) name:@"SystemReloadColor" object:nil];
    //日周月年 Segmented 默认选中
    [self ReloadNewData:[NSDate date] ColorType:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    ActivityStatisticsChartVC *ascvc = self.controlarr[ScrollPage];
    [self ReloadCSData:[NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returndate date:ascvc.DayStr] sumflg:_SelectSumFlg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 日期检索
 */
- (IBAction)DateRetrieval:(id)sender {
    [LGFClandar Clandar:self SelectDate:[NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:_SelectDate]];
}
/**
 日周月年 Segmented 点击方法
 */
- (IBAction)TimeSelect:(UISegmentedControl *)sender {
    TimeSelectSegIndex = sender.selectedSegmentIndex;
    if (TimeSelectSegIndex == 0) {//日
        TotalRange = 4;
    } else {
        TotalRange = 2;
    }
    ScrollPage = TotalRange;
    [self ReloadNewData:[NSDate date] ColorType:NO];
    [self ReloadCSData:[NSDate date] sumflg:_SelectSumFlg];
}
/**
 点击调色板颜色刷新数据 回到当前页
 */
-(void)ReloadColor:(id)sender{
    [self ReloadNewData:_SelectDate ColorType:YES];
}
/**
 MJ下拉刷新数据(默认回到当前日期页)
 */
-(void)MJGetNewData{
    [self ReloadNewData:[NSDate date] ColorType:NO];
    [self ReloadCSData:[NSDate date] sumflg:_SelectSumFlg];
}
/**
 刷新数据 回到日期检索(LGFClandar)选中日期页
 */
-(void)SelectDate:(NSDate *)date{
    [self ReloadNewData:date ColorType:NO];
    [self ReloadCSData:date sumflg:_SelectSumFlg];
}
/**
 刷新数据逻辑封装
 */
-(void)ReloadNewData:(NSDate*)date ColorType:(BOOL)ColorType{
    //确保子控制器每次刷新数据
    self.controlarr = nil;
    //非调色板颜色刷新数据设置
    if (!ColorType){
        ScrollPage = TotalRange;
        _SelectDate = date;
        [self TimeFrameTitleSetValue:date];
    }
    [_PageCV reloadData];
    MAIN([_PageCV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:ScrollPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];);//PageCV reloadData完毕 滚动到指定页
}
/**
 刷新调色板数据
 */
-(void)ReloadCSData:(NSDate*)date sumflg:(NSString*)sumflg{
    [NITNotificationCenter postNotification:[NSNotification notificationWithName:_LoadCSNotificationName object:nil userInfo:@{@"basedate" : [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:date] ,@"forweekly" : @"2" ,@"sumflg" : sumflg}]];
}


#pragma mark - UICollectionViewDataSource And Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.controlarr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_PageCV.width,_PageCV.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //确保自动适配完毕
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    //cell添加子控制器
    UIView *view = [self.controlarr[indexPath.item]view];
    view.size = cell.size;
    [cell.contentView addSubview:view];
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取分页page
    ScrollPage = scrollView.contentOffset.x / scrollView.width;
    //分页分页改变日期
    ActivityStatisticsChartVC *ascvc = self.controlarr[ScrollPage];
    NSDate *Previousdate = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returndate date:ascvc.DayStr];
    [self TimeFrameTitleSetValue:Previousdate];
    [self ReloadCSData:Previousdate sumflg:ascvc.SumFlg];
}

-(void)TimeFrameTitleSetValue:(NSDate*)date{
    if (TimeSelectSegIndex == 0) {//日
        _TimeFrameTitle.text = [NSDate getWeekBeginAndEndWith:date];
        _SelectSumFlg = @"d";
    }else if(TimeSelectSegIndex == 1){//周
        _TimeFrameTitle.text = @"";
        _SelectSumFlg = @"w";
    }else if(TimeSelectSegIndex == 2){//月
        _TimeFrameTitle.text = [NSDate getYear:date];
        _SelectSumFlg = @"m";
    }else if(TimeSelectSegIndex == 3){//年
        _TimeFrameTitle.text = [NSDate getTenYear:date];
        _SelectSumFlg = @"y";
    }
}

- (void)dealloc{
    [NITNotificationCenter removeObserver:self];
}

@end
