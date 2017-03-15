//
//  LifeRhythmVC.m
//  DashBoard
//
//  Created by totyu3 on 17/1/20.
//  Copyright © 2017年 NIT. All rights reserved.
//

#import "LifeRhythmVC.h"
#import "LifeRhythmChartVC.h"

@interface LifeRhythmVC ()<LGFClandarDelegate,LifeRhythmChartVCDelegate>
{
    int ScrollPage;
    NSDate *ColorSelectDate;
}
@property (weak, nonatomic) IBOutlet UILabel *FloorTitle;
@property (weak, nonatomic) IBOutlet UILabel *RoomTitle;
@property (weak, nonatomic) IBOutlet UILabel *UserNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;


@property (weak, nonatomic) IBOutlet NITCollectionView *PageCV;
@property (weak, nonatomic) IBOutlet ColorSelectionCV *ColorSelectionCV;
@property (strong, nonatomic) NSMutableArray *controlarr;
@property (nonatomic, strong) NSDate *SelectDate;
@end

@implementation LifeRhythmVC

static NSString * const reuseIdentifier = @"PageVCCell";

-(NSMutableArray *)controlarr{
    
    if (!_controlarr) {
        _controlarr = [NSMutableArray array];
        for (int i = 0; i<= TotalWeek; i++) {
            LifeRhythmChartVC *lrcvc = [MainSB instantiateViewControllerWithIdentifier:@"LifeRhythmChartVCSB"];
            lrcvc.DayStr = [NSDate SotherDay:_SelectDate symbols:LGFMinus dayNum:(TotalWeek-i)*7];
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
    
    NSMutableDictionary *SystemUserDict = [NSMutableDictionary dictionaryWithContentsOfFile:SYSTEM_USER_DICT];
    _FloorTitle.text = SystemUserDict[@"displayname"];
    _RoomTitle.text = SystemUserDict[@"roomname"];
    _UserNameTitle.text = SystemUserDict[@"username0"];

    [NITNotificationCenter addObserver:self selector:@selector(ReloadColor:) name:@"SystemReloadColor" object:nil];
    ScrollPage = TotalWeek;
    [self ReloadNewData:[NSDate date] ColorType:NO];
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
    
    if (ColorSelectDate) {
        [self ReloadNewData:ColorSelectDate ColorType:YES];
    }else{
        [self ReloadNewData:[NSDate date] ColorType:YES];
    }
}

-(void)MJGetNewData{
    
    [self ReloadNewData:[NSDate date] ColorType:NO];
}

-(void)SelectDate:(NSDate *)date{
    
    ColorSelectDate = date;
    [self ReloadNewData:date ColorType:NO];
}

-(void)ReloadNewData:(NSDate*)date ColorType:(BOOL)ColorType{
    
    self.controlarr = nil;
    _SelectDate = date;
    if (!ColorType)_DateLabel.text = [NSDate getWeekBeginAndEndWith:date];
    [_PageCV reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_PageCV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:ColorType ? ScrollPage : TotalWeek inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
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
    
    ScrollPage = (int)(scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%(TotalWeek+1);
    
    LifeRhythmChartVC *Previousascvc = self.controlarr[ScrollPage];
    
    NSDate *Previousdate = [NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returndate date:Previousascvc.DayStr];
    
    _DateLabel.text = [NSDate getWeekBeginAndEndWith:Previousdate];
}

- (void)dealloc{
    
    [NITNotificationCenter removeObserver:self];
}
@end
