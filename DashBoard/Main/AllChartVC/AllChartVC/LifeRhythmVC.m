//
//  LifeRhythmVC.m
//  DashBoard
//
//  Created by totyu3 on 17/1/20.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "LifeRhythmVC.h"
#import "ColorSelectionCV.h"
#import "LifeRhythmChartVC.h"

@interface LifeRhythmVC ()<LGFClandarDelegate,LifeRhythmChartVCDelegate>
{
    int ScrollPage;
}
@property (weak, nonatomic) IBOutlet UILabel *FloorTitle;
@property (weak, nonatomic) IBOutlet UILabel *RoomTitle;
@property (weak, nonatomic) IBOutlet UILabel *UserNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;


@property (weak, nonatomic) IBOutlet UICollectionView *PageCV;
@property (weak, nonatomic) IBOutlet UIView *ColorSelectionView;
@property (strong, nonatomic) NSMutableArray *controlarr;
@property (nonatomic, strong) NSDate *SelectDate;
@end

@implementation LifeRhythmVC

static NSString * const reuseIdentifier = @"PageVCCell";
/**
 视图控制器数组
 */
-(NSMutableArray *)controlarr{
    if (!_controlarr) {
        _controlarr = [NSMutableArray array];
        for (int i = 0; i <= TotalWeek; i++) {
            LifeRhythmChartVC *lrcvc = [MainSB instantiateViewControllerWithIdentifier:@"LifeRhythmChartVCSB"];
            lrcvc.DayStr = [NSDate SotherDay:_SelectDate symbols:LGFMinus dayNum:(TotalWeek - i) * 7];
            lrcvc.delegate = self;
            [self addChildViewController:lrcvc];
            [_controlarr addObject:lrcvc];
        }
    }
    return _controlarr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_PageCV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [_ColorSelectionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    ColorSelectionCV *cscv = [MainSB instantiateViewControllerWithIdentifier:@"ColorSelectionSB"];
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
    //刷新数据
    [self ReloadNewData:[NSDate date] ColorType:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    LifeRhythmChartVC *lcvc = self.controlarr[ScrollPage];
    [NITNotificationCenter postNotification:[NSNotification notificationWithName:@"SystemLoadColorSelection" object:nil userInfo:@{@"basedate" : lcvc.DayStr ,@"forweekly" : @"1"}]];
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
}
/**
 刷新数据 回到日期检索(LGFClandar)选中日期页
 */
-(void)SelectDate:(NSDate *)date{
    [self ReloadNewData:date ColorType:NO];
}
/**
 刷新数据逻辑封装
 */
-(void)ReloadNewData:(NSDate*)date ColorType:(BOOL)ColorType{
    //确保子控制器每次刷新数据
    self.controlarr = nil;
    //非调色板颜色刷新数据设置
    if (!ColorType){
        ScrollPage = TotalWeek;
        _SelectDate = date;
        _DateLabel.text = [NSDate getWeekBeginAndEndWith:date];
        [NITNotificationCenter postNotification:[NSNotification notificationWithName:@"SystemLoadColorSelection" object:nil userInfo:@{@"basedate" : [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:_SelectDate] ,@"forweekly" : @"1"}]];
    }
    [_PageCV reloadData];
    MAIN([_PageCV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:ScrollPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];);//PageCV reloadData完毕 滚动到指定页
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
    LifeRhythmChartVC *lcvc = self.controlarr[ScrollPage];
    NSDate *Previousdate = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returndate date:lcvc.DayStr];
    _DateLabel.text = [NSDate getWeekBeginAndEndWith:Previousdate];
    [NITNotificationCenter postNotification:[NSNotification notificationWithName:@"SystemLoadColorSelection" object:nil userInfo:@{@"basedate" : lcvc.DayStr ,@"forweekly" : @"1"}]];}

- (void)dealloc{
    [NITNotificationCenter removeObserver:self];
}

@end
