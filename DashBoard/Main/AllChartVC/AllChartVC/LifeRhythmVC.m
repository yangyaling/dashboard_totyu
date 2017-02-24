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
@property (weak, nonatomic) IBOutlet NITCollectionView *PageCV;
@property (weak, nonatomic) IBOutlet ColorSelectionCV *ColorSelectionCV;
@property (strong, nonatomic) NSMutableArray *controlarr;
@property (nonatomic, strong) NSDate *SelectDate;
@end

@implementation LifeRhythmVC

static NSString * const reuseIdentifier = @"PageVCCell";

-(NSMutableArray *)controlarr{
    
    if (!_controlarr) {
        NSMutableArray *reverscontrolarr = [NSMutableArray array];
        for (int i = 0; i< TotalWeek; i++) {
            LifeRhythmChartVC *lrcvc = [MainSB instantiateViewControllerWithIdentifier:@"LifeRhythmChartVCSB"];
            
            if (i==0) {
                lrcvc.DayStr = [NSDate needDateStatus:NotHaveType date:_SelectDate];
            }else{
                LifeRhythmChartVC *Previouslrcvc = reverscontrolarr[i-1];
                NSDate *Previousdate = [NSDate needDateStrStatus:NotHaveType datestr:Previouslrcvc.DayStr];
                int week = (int)[NSDate nowTimeType:LGFweek time:Previousdate];
                lrcvc.DayStr = [NSDate SotherDay:Previousdate symbols:LGFMinus dayNum:week];
            }
            
            lrcvc.delegate = self;
            [self addChildViewController:lrcvc];
            [reverscontrolarr addObject:lrcvc];
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

    [NITNotificationCenter addObserver:self selector:@selector(ReloadColor:) name:@"SystemReloadColor" object:nil];
    ScrollPage = TotalWeek-1;
    [self ReloadNewData:[NSDate date] ColorType:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
/**
 日期检索
 */
- (IBAction)DateRetrieval:(id)sender {
    
    [[LGFClandar Clandar] ShowInView:self Date:[NSDate needDateStatus:NotHaveType date:_SelectDate]];
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
    [_PageCV reloadData];
    [_PageCV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:ColorType ? ScrollPage : TotalWeek-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - UICollectionViewDataSource And Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.controlarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *view = [self.controlarr[indexPath.item]view];
    view.size = cell.size;
    [cell.contentView addSubview:view];
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    ScrollPage = (int)(scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%(TotalWeek);
    NSLog(@"%d",ScrollPage);
}

- (void)dealloc{
    
    [NITNotificationCenter removeObserver:self];
}
@end
