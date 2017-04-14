//
//  LGFClandar.m
//  DashBoard
//
//  Created by totyu3 on 17/2/16.
//  Copyright © 2017年 NIT. All rights reserved.
//
#import "LGFClandar.h"
#import "UnderlineView.h"
@interface ClandarDayCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *DayNum;
@end
@implementation ClandarDayCell

-(UILabel *)DayNum{
    if (!_DayNum) {
        _DayNum = [[UILabel alloc]initWithFrame:CGRectMake(1, 1, self.width-2, self.height-2)];
        _DayNum.textAlignment = NSTextAlignmentCenter;
        _DayNum.textColor = SystemColor(1.0);
    }
    return _DayNum;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.DayNum];
    }
    return self;
}
@end

@interface ClandarMonthReusableView : UICollectionReusableView
@property (nonatomic, strong) UILabel *MonthNum;
@property (nonatomic, strong) UIView *WeekView;
@end
@implementation ClandarMonthReusableView

-(UILabel *)MonthNum{
    if (!_MonthNum) {
        _MonthNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height/2)];
        _MonthNum.backgroundColor = SystemColor(1.0);
        _MonthNum.textAlignment = NSTextAlignmentCenter;
        _MonthNum.textColor = [UIColor whiteColor];
    }
    return _MonthNum;
}

-(UIView *)WeekView{
    if (!_WeekView) {
        _WeekView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height/2, self.width, self.height/2)];
        NSArray *WeekArray = @[@"日",@"月",@"火",@"水",@"木",@"金",@"土"];
        [WeekArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UILabel *WeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(idx*(self.width/7), 0, self.width/7, self.height/2)];
            WeekLabel.text = obj;
            WeekLabel.textColor = [UIColor blackColor];
            WeekLabel.textAlignment = NSTextAlignmentCenter;
            [_WeekView addSubview:WeekLabel];
        }];
    }
    return _WeekView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.MonthNum];
        [self addSubview:self.WeekView];
    }
    return self;
}
@end

@interface LGFClandar ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIDatePicker *TimeTitlePicker;
@property (nonatomic, strong) UIView *TimeTitleView;
@property (nonatomic, strong) UIView *Cover;
@property (nonatomic, strong) UICollectionView *ClandarCV;
@property (nonatomic, strong) NSMutableArray *ClandarDataArray;
@property (nonatomic, strong) NSDate *NewDate;
@end
@implementation LGFClandar

+(LGFClandar *)Clandar:(id)Super SelectDate:(NSString*)SelectDate{
    static LGFClandar*Clandar = nil;
    if (!Clandar) {
        Clandar = [[LGFClandar alloc]init];
        Clandar.backgroundColor = [UIColor clearColor];
    }
    NSDate *SDate = [Clandar AuToDateFormatter:@"yyyy-MM-dd" object:SelectDate];
    if (SelectDate) {
        Clandar.NewDate = SDate;
    } else {
        Clandar.NewDate = [NSDate date];
    }
    Clandar.delegate = Super;
    UIViewController *SuperView = Super;
    Clandar.frame = SuperView.view.bounds;
    [SuperView.view addSubview:Clandar];
    [Clandar ShowInView];
    return Clandar;
}

- (void)ShowInView{
    self.Cover.frame = CGRectMake(self.width, 0, 250, self.height);
    [self AddChildSubview];
    [UIView animateWithDuration:0.2 animations:^{
        self.Cover.frame = CGRectMake(self.width-250, 0, 250, self.height);
        self.Cover.alpha = 1.0;
    }];
    [self getAllDaysWithCalender];
    [self ClandarSelectDate:_NewDate];
}

/**
 添加子控件
 */
-(void)AddChildSubview{
    [self addSubview:self.Cover];
    [self.Cover addSubview:self.ClandarCV];
    [self.Cover addSubview:self.TimeTitleView];
    [self.TimeTitleView addSubview:self.TimeTitlePicker];
}

-(UIView *)Cover{
    if (!_Cover) {
        _Cover = [[UIView alloc]initWithFrame:CGRectMake(self.width, 0, 250, self.height)];
        _Cover.layer.shadowColor = [UIColor blackColor].CGColor;
        _Cover.layer.shadowOffset = CGSizeMake(1,1);
        _Cover.layer.shadowOpacity = 0.3;
    }
    return _Cover;
}
/**
 取得三十年日期
 */
-(NSMutableArray *)ClandarDataArray{
    if (!_ClandarDataArray) {
        _ClandarDataArray = [NSMutableArray array];
        NSCalendar*calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *Comps =  [[NSDateComponents alloc] init];
        NSMutableArray *YearMonthArray = [NSMutableArray array];
        
        for (int i = 0; i < 360; i++) {
            [Comps setMonth: - i];//每次循环月份减1
            NSDate *lastMonth = [calendar dateByAddingComponents:Comps toDate:[NSDate date] options:0];//获取减1月后的日期
            NSString *YearMonthStr = [self AuToDateFormatter:@"yyyy年MM月" object:lastMonth];
            [YearMonthArray addObject:YearMonthStr];
        }
        
        [YearMonthArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDate *MonthDate = [self AuToDateFormatter:@"yyyy年MM月" object:obj];
            NSInteger week = [[calendar components:NSCalendarUnitWeekday fromDate:MonthDate] weekday];
            NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit: NSCalendarUnitMonth forDate:MonthDate];
            NSMutableArray *DayArray = [NSMutableArray array];
            NSMutableArray *DayNumArray = [NSMutableArray array];
            for (int d = 1; d < range.length + week; d++) {
                if (d < week) {
                    [DayNumArray addObject:@""];
                    [DayArray addObject:@""];
                } else {
                    [DayNumArray addObject:[NSString stringWithFormat:@"%ld",d - (week - 1)]];
                    [DayArray addObject:[NSString stringWithFormat:@"%@%ld日",obj,d - (week - 1)]];
                }
            }
            NSDictionary *MonthDict = @{@"DayArray":DayArray,@"DayNumArray":DayNumArray,@"MonthNum":obj};
            [_ClandarDataArray addObject:MonthDict];
        }];
    }
    return _ClandarDataArray;
}

-(UIDatePicker *)TimeTitlePicker{
    if (!_TimeTitlePicker) {
        _TimeTitlePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, -10, self.TimeTitleView.width, self.TimeTitleView.height+20)];
        _TimeTitlePicker.datePickerMode = UIDatePickerModeDate;
        _TimeTitlePicker.maximumDate = [NSDate date];
        [_TimeTitlePicker setTimeZone:[NSTimeZone systemTimeZone]];
        NSArray *EndDayArray = [NSArray arrayWithArray:self.ClandarDataArray.lastObject[@"DayArray"]];
        _TimeTitlePicker.minimumDate = [self AuToDateFormatter:@"yyyy年MM月dd日" object:EndDayArray.lastObject];
        [_TimeTitlePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _TimeTitlePicker;
}

-(UIView *)TimeTitleView{
    if (!_TimeTitleView) {
        _TimeTitleView = [[UnderlineView alloc]initWithFrame:CGRectMake(0, 0, self.Cover.width, 35)];
        _TimeTitleView.backgroundColor = [UIColor whiteColor];
    }
    return _TimeTitleView;
}

-(UICollectionView *)ClandarCV{
    if (!_ClandarCV) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _ClandarCV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.TimeTitleView.height, self.Cover.width, self.Cover.height - self.TimeTitleView.height) collectionViewLayout:layout];
        layout.itemSize = CGSizeMake(_ClandarCV.width / 7, _ClandarCV.width / 7);
        layout.headerReferenceSize = CGSizeMake(_ClandarCV.width, 50);
        [_ClandarCV registerClass:[ClandarDayCell class]forCellWithReuseIdentifier:@"ClandarDayCell"];
        [_ClandarCV registerClass:[ClandarMonthReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ClandarMonthReusableView"];
        _ClandarCV.showsVerticalScrollIndicator = NO;
//        _ClandarCV.prefetchingEnabled = YES;
        _ClandarCV.bounces = NO;
        _ClandarCV.backgroundColor = [UIColor whiteColor];
        _ClandarCV.dataSource = self;
        _ClandarCV.delegate = self;
    }
    return _ClandarCV;
}

- (void)dateChange:(UIDatePicker*)sender{
    [self ClandarSelectDate:sender.date];
    [self.delegate SelectDate:sender.date];
}

- (void)ClandarSelectDate:(NSDate*)date{
    if (date) {
        _TimeTitlePicker.date = date;
        NSString * monthstr = [self AuToDateFormatter:@"yyyy年MM月" object:date];
        NSString * daystr = [self AuToDateFormatter:@"d" object:date];
        for (NSDictionary *dict in self.ClandarDataArray) {
            if ([dict[@"MonthNum"] isEqualToString:monthstr]) {
                NSIndexPath *indexpath = [NSIndexPath indexPathForItem:[dict[@"DayNumArray"] indexOfObject:daystr] inSection:[self.ClandarDataArray indexOfObject:dict]];
                [self.ClandarCV layoutIfNeeded];
                [self.ClandarCV reloadData];
                [self.ClandarCV scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
                [self.ClandarCV selectItemAtIndexPath:indexpath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredVertically];
            }
        }
    }
}

- (void)getAllDaysWithCalender{
    [self.ClandarCV reloadData];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"ClandarMonthReusableView";
    ClandarMonthReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *dict = self.ClandarDataArray[indexPath.section];
    view.MonthNum.text = dict[@"MonthNum"];
    return view;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.ClandarDataArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *dict = self.ClandarDataArray[section];
    NSMutableArray *daynumarr = dict[@"DayNumArray"];
    return daynumarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClandarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClandarDayCell" forIndexPath:indexPath];
    UIView* selectedBGView = [[UIView alloc] initWithFrame:cell.bounds];
    selectedBGView.backgroundColor = [UIColor yellowColor];
    selectedBGView.layer.cornerRadius = 5.0;
    cell.selectedBackgroundView = selectedBGView;
    NSDictionary *dict = self.ClandarDataArray[indexPath.section];
    NSMutableArray *daynumarr = dict[@"DayNumArray"];
    NSMutableArray *dayarr = dict[@"DayArray"];
    cell.DayNum.text = daynumarr[indexPath.item];
    if ([cell.DayNum.text isEqualToString:@""]) {
        cell.alpha = 0.0;
        cell.userInteractionEnabled = NO;
    } else {
        if ([self getDifferenceByDate:dayarr[indexPath.item]] <= 0 && ![dayarr[indexPath.item] isEqualToString:[self AuToDateFormatter:@"yyyy年MM月d日" object:[NSDate date]]]) {
            cell.alpha = 0.3;
            cell.userInteractionEnabled = NO;
        } else {
            cell.alpha = 1.0;
            cell.userInteractionEnabled = YES;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.ClandarDataArray[indexPath.section];
    NSMutableArray *arr = dict[@"DayArray"];
    [self.TimeTitlePicker setDate:[self AuToDateFormatter:@"yyyy年MM月d日" object:arr[indexPath.item]] animated:YES];
    [self.delegate SelectDate:self.TimeTitlePicker.date];
}

#pragma mark - 触摸

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint point = [touches.anyObject locationInView:self];
    CGPoint SelfLocation = [self convertPoint:point toView:self];
    if ([self pointInside:SelfLocation withEvent:event]) {
        [self ClandarHidden];
    }
}

- (void)ClandarHidden{
    [UIView animateWithDuration:0.2 animations:^{
        self.Cover.frame = CGRectMake(self.width, 0, 250, self.height);
        self.Cover.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self RemoveAllView];
    }];
}

- (int)getDifferenceByDate:(NSString *)date {
    NSDate *selectdate = [self AuToDateFormatter:@"yyyy年MM月d日" object:date];
    int nowtime = [[NSDate date] timeIntervalSince1970];
    int selecttime = [selectdate timeIntervalSince1970];
    int num = (nowtime - selecttime) / 3600 / 24;
    return num;
}

- (id)AuToDateFormatter:(NSString*)FormatterType object:(id)object{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setDateFormat:FormatterType];
    id NewObject = nil;
    if ([object isKindOfClass:[NSString class]]) {
        NewObject = [formatter dateFromString:object];
    } else {
        NewObject = [formatter stringFromDate:object];
    }
    return NewObject;
}

-(void)RemoveAllView{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
}

- (void)dealloc{
    [self RemoveAllView];
}

@end
