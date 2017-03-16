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
        for (int i = 0; i<WeekArray.count; i++) {
            UILabel *WeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*(self.width/7), 0, self.width/7, self.height/2)];
            WeekLabel.text = WeekArray[i];
            WeekLabel.textColor = [UIColor blackColor];
            WeekLabel.textAlignment = NSTextAlignmentCenter;
            [_WeekView addSubview:WeekLabel];
        }
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
{
    NSDate *NewDate;
    UIView *superview;
}
@property (nonatomic, strong) UIDatePicker *TimeTitlePicker;
@property (nonatomic, strong) UIView *TimeTitleView;
@property (nonatomic, strong) UIView *Cover;
@property (nonatomic, strong) UICollectionView *ClandarCV;
@property (nonatomic, strong) NSMutableArray *ClandarDataArray;
@end
@implementation LGFClandar

+(LGFClandar *)Clandar{
    static LGFClandar*Clandar = nil;
    if (!Clandar) {
        Clandar = [[LGFClandar alloc]init];
        Clandar.layer.shadowColor = [UIColor blackColor].CGColor;
        Clandar.layer.shadowOffset = CGSizeMake(1,1);
        Clandar.layer.shadowOpacity = 0.3;
    }
    return Clandar;
}

- (void)ShowInView:(id)SuperSelf Date:(NSString*)Date{
    NSDate *SelectDate = [self AuToDateFormatter:@"yyyy-MM-dd" object:Date];
    if (SelectDate) {
        NewDate = SelectDate;
    }else{
        NewDate = [NSDate date];
    }
    self.delegate = SuperSelf;
    UIViewController *SuperView = SuperSelf;
    superview = SuperView.view;
    [self AddChildSubview];
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(superview.width-280, 0, 280, superview.height);
        self.TimeTitleView.alpha = 1.0;
        self.ClandarCV.alpha = 1.0;
        self.Cover.alpha = 1.0;
    }];
    [self getAllDaysWithCalender];
    [self ClandarSelectDate:NewDate];
}

/**
 添加子控件
 */
-(void)AddChildSubview{
    [superview addSubview:self.Cover];
    self.frame = CGRectMake(superview.width, 0, 280, superview.height);
    [self.Cover addSubview:self];
    [self addSubview:self.ClandarCV];
    [self addSubview:self.TimeTitleView];
    [self.TimeTitleView addSubview:self.TimeTitlePicker];
}

-(UIView *)Cover{
    if (!_Cover) {
        _Cover = [[UIView alloc]initWithFrame:superview.bounds];
        _Cover.backgroundColor = [UIColor clearColor];
    }
    return _Cover;
}

-(NSMutableArray *)ClandarDataArray{
    if (!_ClandarDataArray) {
        _ClandarDataArray = [NSMutableArray array];
        NSCalendar*calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [calendar components:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear fromDate:[NSDate date]];
        NSMutableArray *montharr = [NSMutableArray array];
        for (int i = 0; i<360; i++) {
            NSDate *lastMonth = [calendar dateFromComponents:comps];
            NSString * str = [self AuToDateFormatter:@"yyyy年MM月" object:lastMonth];
            [montharr addObject:str];
            [comps setMonth:([comps month] - 1)];
        }
        for (int i = 0; i<montharr.count; i++) {
            NSDate *MonthDate = [self AuToDateFormatter:@"yyyy年MM月" object:montharr[i]];
            NSInteger week = [[calendar components:NSCalendarUnitWeekday fromDate:MonthDate] weekday];
            NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit: NSCalendarUnitMonth forDate:MonthDate];
            NSMutableArray *DayArray = [NSMutableArray array];
            NSMutableArray *DayNumArray = [NSMutableArray array];
            for (int d = 1; d < range.length+week; d++) {
                if (d<week) {
                    [DayNumArray addObject:@""];
                    [DayArray addObject:@""];
                }else{
                    [DayNumArray addObject:[NSString stringWithFormat:@"%ld",d-(week-1)]];
                    [DayArray addObject:[NSString stringWithFormat:@"%@%ld日",montharr[i],d-(week-1)]];
                }
            }
            NSDictionary *MonthDict = @{@"DayArray":DayArray,@"DayNumArray":DayNumArray,@"MonthNum":montharr[i]};
            [_ClandarDataArray addObject:MonthDict];
        }
    }
    return _ClandarDataArray;
}

-(UIDatePicker *)TimeTitlePicker{
    if (!_TimeTitlePicker) {
        _TimeTitlePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, -10, self.TimeTitleView.width, self.TimeTitleView.height+20)];
        _TimeTitlePicker.datePickerMode = UIDatePickerModeDate;
        _TimeTitlePicker.maximumDate = [NSDate date];
        NSArray *EndDayArray = [NSArray arrayWithArray:self.ClandarDataArray.lastObject[@"DayArray"]];
        _TimeTitlePicker.minimumDate = [self AuToDateFormatter:@"yyyy年MM月dd日" object:EndDayArray.lastObject];
        [_TimeTitlePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _TimeTitlePicker;
}

-(UIView *)TimeTitleView{
    if (!_TimeTitleView) {
        _TimeTitleView = [[UnderlineView alloc]initWithFrame:CGRectMake(0, 0, 280, 35)];
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
        _ClandarCV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 35, 280, WindowView.height-149) collectionViewLayout:layout];
        layout.itemSize = CGSizeMake(_ClandarCV.width/7, _ClandarCV.width/7);
        layout.headerReferenceSize = CGSizeMake(_ClandarCV.width,50);
        [_ClandarCV registerClass:[ClandarDayCell class]forCellWithReuseIdentifier:@"ClandarDayCell"];
        [_ClandarCV registerClass:[ClandarMonthReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ClandarMonthReusableView"];
        _ClandarCV.showsVerticalScrollIndicator = NO;
        _ClandarCV.prefetchingEnabled = YES;
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
    }else{
        if ([self getDifferenceByDate:dayarr[indexPath.item]]<=0&&![dayarr[indexPath.item] isEqualToString:[self AuToDateFormatter:@"yyyy年MM月d日" object:[NSDate date]]]) {
            cell.alpha = 0.3;
            cell.userInteractionEnabled = NO;
        }else{
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
/**
 *  子控件超出父控件fram依旧响应点击事件
 */
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self){
        [self ClandarHidden];
        return nil;
    }else{
        return [super hitTest:point withEvent:event];
    }
}
/**
 *  点击非本控件收起菜单
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return YES;
}

#pragma mark - 触摸

- (void)ClandarHidden{
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(superview.width, 0, 350, superview.height);
        self.TimeTitleView.alpha = 0.0;
        self.ClandarCV.alpha = 0.0;
        self.Cover.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self RemoveAllView];
    }];
}

- (int)getDifferenceByDate:(NSString *)date {    
    NSDate *selectdate = [self AuToDateFormatter:@"yyyy年MM月d日" object:date];
    int nowtime = [[NSDate date] timeIntervalSince1970];
    int selecttime = [selectdate timeIntervalSince1970];
    int num = (nowtime - selecttime)/3600/24;
    return num;
}

- (id)AuToDateFormatter:(NSString*)FormatterType object:(id)object{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:FormatterType];
    id NewObject;
    if ([object isKindOfClass:[NSString class]]) {
        NewObject = [formatter dateFromString:object];
    }else{
        NewObject = [formatter stringFromDate:object];
    }
    return NewObject;
}

-(void)RemoveAllView{
    [self.TimeTitlePicker removeFromSuperview];
    [self.TimeTitleView removeFromSuperview];
    [self.ClandarCV removeFromSuperview];
    [self.Cover removeFromSuperview];
    [self removeFromSuperview];
    self.Cover = nil;
}

@end
