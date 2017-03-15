//
//  ActivityStatisticsVC.m
//  DashBoard
//
//  Created by totyu3 on 17/1/20.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "ActivityStatisticsVC.h"
#import "ActivityStatisticsChartVC.h"
#import "NITSegmented.h"

@interface ActivityStatisticsVC ()<LGFClandarDelegate,ActivityStatisticsChartVCDelegate>
{
    NSInteger TimeSelectSegIndex;
    int TotalRange;
    int ScrollPage;
    NSDate *ColorSelectDate;
}
@property (weak, nonatomic) IBOutlet UILabel *FloorTitle;
@property (weak, nonatomic) IBOutlet UILabel *RoomTitle;
@property (weak, nonatomic) IBOutlet UILabel *UserNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *TimeFrameTitle;
@property (weak, nonatomic) IBOutlet NITSegmented *TimeSelectSeg;
@property (weak, nonatomic) IBOutlet NITCollectionView *PageCV;
@property (weak, nonatomic) IBOutlet ColorSelectionCV *ColorSelectionCV;
@property (strong, nonatomic) NSMutableArray *controlarr;
@property (nonatomic, strong) NSDate *SelectDate;
@end

@implementation ActivityStatisticsVC

static NSString * const reuseIdentifier = @"ActivityStatisticsPageCell";

-(NSMutableArray *)controlarr{
    
    if (!_controlarr) {
        NSMutableArray *reverscontrolarr = [NSMutableArray array];
        for (int i = 0; i< TotalRange; i++) {
            ActivityStatisticsChartVC *ascvc = [MainSB instantiateViewControllerWithIdentifier:@"ActivityStatisticsChartVCSB"];   
            if (TimeSelectSegIndex==0) {//日

                if (i==0) {
                    ascvc.DayStr = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:_SelectDate];
                }else{
                    ActivityStatisticsChartVC *Previousascvc = reverscontrolarr[i-1];
                    NSDate *Previousdate = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returndate date:Previousascvc.DayStr];
                    int week = (int)[NSDate nowTimeType:LGFweek time:Previousdate];
                    ascvc.DayStr = [NSDate SotherDay:Previousdate symbols:LGFMinus dayNum:week];
                }
                ascvc.SumFlg = @"d";
                    
            }else if(TimeSelectSegIndex==1){//周

                if (i==0) {
                    ascvc.DayStr = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:_SelectDate];
                }else{
                    ActivityStatisticsChartVC *Previousascvc = reverscontrolarr[i-1];
                    NSDate *Previousdate = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returndate date:Previousascvc.DayStr];
                    NSString *tmpdate = [NSDate getThreeMonthDate:Previousdate];
                    ascvc.DayStr = tmpdate;
//                    int day = (int)[NSDate nowTimeType:LGFday time:Previousdate];
//                    ascvc.DayStr = [NSDate SotherDay:Previousdate symbols:LGFMinus dayNum:day];
                }

                ascvc.SumFlg = @"w";

            }else if(TimeSelectSegIndex==2){//月
                
                if (i==0) {
                    ascvc.DayStr = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:_SelectDate];
                }else{
                    ActivityStatisticsChartVC *Previousascvc = reverscontrolarr[i-1];
                    NSDate *Previousdate = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returndate date:Previousascvc.DayStr];
                    ascvc.DayStr = [NSDate SotherDay:Previousdate symbols:LGFMinus dayNum:[[NSDate NeedDateFormat:@"DD" ReturnType:returnstring date:Previousdate] intValue]];
                }
                
                ascvc.SumFlg = @"m";
            }else if(TimeSelectSegIndex==3){//年 q
                
                if (i==0) {
                    ascvc.DayStr = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:_SelectDate];
                }else{
                    ActivityStatisticsChartVC *Previousascvc = reverscontrolarr[i-1];
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
    
    [_PageCV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    _FloorTitle.text = SystemUserDict[@"displayname"];
    _RoomTitle.text = SystemUserDict[@"roomname"];
    _UserNameTitle.text = SystemUserDict[@"username0"];
    [self TimeFrameTitleSetValue:[NSDate date]];

    [NITNotificationCenter addObserver:self selector:@selector(ReloadColor:) name:@"SystemReloadColor" object:nil];
    TimeSelectSegIndex=0;
    TotalRange = 5;
    ScrollPage = TotalRange-1;
    [self ReloadNewData:[NSDate date] ColorType:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 日期检索
 */
- (IBAction)DateRetrieval:(id)sender {
    
    [[LGFClandar Clandar] ShowInView:self Date:[NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:_SelectDate]];
}

- (IBAction)TimeSelect:(UISegmentedControl *)sender {
    TimeSelectSegIndex = sender.selectedSegmentIndex;
    if (TimeSelectSegIndex==0) {//日
        TotalRange = 5;
    }else if(TimeSelectSegIndex==1){//周
        TotalRange = 3;
    }else if(TimeSelectSegIndex==2){//月
        TotalRange = 3;
    }else if(TimeSelectSegIndex==3){//年
        TotalRange = 3;
    }
    [self ReloadNewData:[NSDate date] ColorType:NO];
}

-(void)ReloadColor:(id)sender{
    
    if (ColorSelectDate) {
        [self ReloadNewData:ColorSelectDate ColorType:YES];
    }else{
        [self ReloadNewData:[NSDate date] ColorType:YES];
    }
}

-(void)MJGetNewData:(NSString *)dateString{
    
    if (dateString.length) {
        _TimeFrameTitle.text = dateString;
    } else {
        [self ReloadNewData:[NSDate date] ColorType:NO];
    }
}

-(void)SelectDate:(NSDate *)date{
    
    ColorSelectDate = date;
    [self ReloadNewData:date ColorType:NO];
}

-(void)ReloadNewData:(NSDate*)date ColorType:(BOOL)ColorType{
    
    self.controlarr = nil;
    _SelectDate = date;
    if (!ColorType)[self TimeFrameTitleSetValue:date];
    [_PageCV reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_PageCV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:ColorType ? ScrollPage : TotalRange-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    });
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
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *view = [self.controlarr[indexPath.item]view];
    view.size = cell.size;
    [cell.contentView addSubview:view];
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    ScrollPage = (int)(scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%(TotalRange);

    ActivityStatisticsChartVC *Previousascvc = self.controlarr[ScrollPage];
    
    NSDate *Previousdate = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returndate date:Previousascvc.DayStr];
    
    [self TimeFrameTitleSetValue:Previousdate];
}

-(void)TimeFrameTitleSetValue:(NSDate*)date{
    if (TimeSelectSegIndex==0) {//日
        
        _TimeFrameTitle.text = [NSDate getWeekBeginAndEndWith:date];
    }else if(TimeSelectSegIndex==1){//周
        
        _TimeFrameTitle.text = @"";
    }else if(TimeSelectSegIndex==2){//月
        
        _TimeFrameTitle.text = [NSDate getYear:date];
    }else if(TimeSelectSegIndex==3){//年
        _TimeFrameTitle.text = [NSDate getTenYear:date];
    }
}

- (void)dealloc{
    
    [NITNotificationCenter removeObserver:self];
}
@end
