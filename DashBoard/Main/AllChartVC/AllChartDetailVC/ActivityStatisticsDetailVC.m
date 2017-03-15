//
//  ActivityStatisticsDetailVC.m
//  DashBoard
//
//  Created by totyu3 on 17/1/20.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "ActivityStatisticsDetailVC.h"
#import "ActivityStatisticsDetailChartVC.h"

@interface ActivityStatisticsDetailVC ()<LGFClandarDelegate,ActivityStatisticsDetailChartVCDelegate>
{
    int ScrollPage;
}
@property (weak, nonatomic) IBOutlet UILabel *FloorTitle;
@property (weak, nonatomic) IBOutlet UILabel *RoomTitle;
@property (weak, nonatomic) IBOutlet UILabel *UserNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *TimeFrameTitle;
@property (weak, nonatomic) IBOutlet NITCollectionView *PageCV;
@property (weak, nonatomic) IBOutlet ColorSelectionCV *ColorSelectionCV;
@property (strong, nonatomic) NSMutableArray *controlarr;
@property (nonatomic, strong) NSDate *SelectDate;
@end

@implementation ActivityStatisticsDetailVC

static NSString * const reuseIdentifier = @"ActivityStatisticsPageDetailCVCell";

-(NSMutableArray *)controlarr{
    
    if (!_controlarr) {
        _controlarr = [NSMutableArray array];
        for (int i = 0; i<= TotalDay; i++) {
            ActivityStatisticsDetailChartVC *asdcvc = [MainSB instantiateViewControllerWithIdentifier:@"ActivityStatisticsDetailChartVCSB"];
            asdcvc.DayStr = [NSDate SotherDay:_SelectDate symbols:LGFMinus dayNum:TotalDay - i];
            asdcvc.delegate = self;
            [self addChildViewController:asdcvc];
            [_controlarr addObject:asdcvc];
        }
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
    _TimeFrameTitle.text = [NSDate getTheDayOfTheWeekByDateString:[NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:_SelectDay]];
    
    [NITNotificationCenter addObserver:self selector:@selector(ReloadColor:) name:@"SystemReloadColor" object:nil];
    [self ReloadNewData:[NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returndate date:_SelectDay] ColorType:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 日期检索
 */
- (IBAction)DateRetrieval:(id)sender {
    [[LGFClandar Clandar] ShowInView:self Date:[NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:_SelectDate]];
}

-(void)ReloadColor:(id)sender{
    
    [self ReloadNewData:_SelectDate ColorType:YES];
}

-(void)MJGetNewData{
    
    [self ReloadNewData:[NSDate date] ColorType:NO];
}

-(void)SelectDate:(NSDate *)date{

    [self ReloadNewData:date ColorType:NO];
}

-(void)ReloadNewData:(NSDate*)date ColorType:(BOOL)ColorType{

    self.controlarr = nil;
    if(!ColorType){
        ScrollPage = TotalDay;
        _SelectDate = date;
        _TimeFrameTitle.text = [NSDate getTheDayOfTheWeekByDateString:[NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:date]];
    }
    [_PageCV reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_PageCV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:ColorType ? ScrollPage : TotalDay inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
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
    
    ScrollPage = (int)(scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%(TotalDay+1);
    _TimeFrameTitle.text = [NSDate getTheDayOfTheWeekByDateString:[NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:[NSDate SotherDayDate:_SelectDate symbols:LGFMinus dayNum:TotalDay-ScrollPage]]];
}

- (void)dealloc{
    
    [NITNotificationCenter removeObserver:self];
}
@end
