//
//  NSDate+Extension.m
//  
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 huangziliang. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)


+ (NSString *)needDateStatus:(DateStatus)type date:(NSDate*)date
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    if (type == HaveHMSType) {
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    } else if (type == NotHaveType) {
        fmt.dateFormat = @"yyyy-MM-dd";
    } else if(type == JapanHMSType){
        fmt.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    }else if(type == JapanMDType){
        fmt.dateFormat = @"MM月dd日";
    }else if(type == DDType){
        fmt.dateFormat = @"DD";
    }else if(type == YYYYType){
        fmt.dateFormat = @"yyyy";
    }else if(type == hhmmssType){
        fmt.dateFormat = @"HH:mm:ss";
    }
    return [fmt stringFromDate:date];
}

+ (NSDate *)needDateStrStatus:(DateStatus)type datestr:(NSString*)datestr
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    if (type == HaveHMSType) {
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    } else if (type == NotHaveType) {
        fmt.dateFormat = @"yyyy-MM-dd";
    } else if(type == JapanHMSType){
        fmt.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    }else if(type == JapanMDType){
        fmt.dateFormat = @"MM月dd日";
    }else if(type == DDType){
        fmt.dateFormat = @"DD";
    }else if(type == YYYYType){
        fmt.dateFormat = @"YYYY";
    }else {
        fmt.dateFormat = @"HH:mm:ss";
    }
    return [fmt dateFromString:datestr];
}


+ (NSString *)SharedToday
{
    //当前时间
    NSDate *nowDate = [NSDate new];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    return [fmt stringFromDate:nowDate];
}


/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获得某个时间的年月日时分秒
    NSDateComponents *dateCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    return dateCmps.year == nowCmps.year;
}


/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday
{
    NSDate *now = [NSDate date];
    
    // date ==  2014-04-30 10:05:28 --> 2014-04-30 00:00:00
    // now == 2014-05-01 09:22:10 --> 2014-05-01 00:00:00
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 2014-04-30
    NSString *dateStr = [fmt stringFromDate:self];
    // 2014-10-18
    NSString *nowStr = [fmt stringFromDate:now];
    
    // 2014-10-30 00:00:00
    NSDate *date = [fmt dateFromString:dateStr];
    // 2014-10-18 00:00:00
    now = [fmt dateFromString:nowStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}


/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday
{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    
    return [dateStr isEqualToString:nowStr];
}


//-----------------------------------------------------------------------------
/**
 *  单位时间格式化
 *
 *  @param timeType 单位时间名字
 *  @param thisTime 传入时间
 *
 *  @return 时间格式化数字
 */
+(NSInteger)nowTimeType:(timeType)timeType time:(NSDate*)thisTime
{
    NSCalendar*calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags =  NSCalendarUnitEra |
    NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond |
    NSCalendarUnitWeekday |
    NSCalendarUnitWeekdayOrdinal |
    NSCalendarUnitQuarter |
    NSCalendarUnitWeekOfMonth |
    NSCalendarUnitWeekOfYear |
    NSCalendarUnitYearForWeekOfYear |
    NSCalendarUnitCalendar |
    NSCalendarUnitTimeZone;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [calendar components:unitFlags fromDate:thisTime];
    
    NSInteger second = [comps second];
    NSInteger minute = [comps minute];
    NSInteger hour24 = [comps hour];
    NSInteger day = [comps day];
    NSInteger week = [comps weekday];
    NSInteger month = [comps month];
    NSInteger year = [comps year];
    NSInteger weekofyear = [comps weekOfYear];
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"K"];
    NSInteger hour12 = [[format stringFromDate:thisTime]intValue]-1;
    NSDateFormatter *formatTwo = [[NSDateFormatter alloc] init];
    [formatTwo setDateFormat:@"aa"];
    NSInteger ampm = [[format stringFromDate:thisTime] isEqualToString:@"AM"]?0:1;
    
    switch (timeType) {
        case 1:
            return second;
            break;
            
        case 2:
            return minute;
            break;
            
        case 3:
            return hour12;
            break;
            
        case 4:
            return hour24;
            break;
            
        case 5:
            return day;
            break;
            
        case 6:
            if (week==1) {
                return 7;
            }else{
                return week-1;
            }
            break;
            
        case 7:
            return month;
            break;
            
        case 8:
            return year;
            break;
            
        case 9:
            return ampm;
            break;
        case 10:
            return weekofyear;
            break;
        default:
            return second;
            break;
    }
}
/**
 *  取得?天日期   字符串
 *
 *  @param thisTime 传入日期
 *  @param qian     天数
 *
 *  @return ?天日期
 */
+ (NSString *)SotherDay:(NSDate *)thisTime symbols:(timeType)symbols dayNum:(int)dayNum
{
    
    NSDate *LGFdate;
    
    if (symbols == LGFPlus) {
        
        LGFdate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] + dayNum*24*3600)];
        
    }else if (symbols == LGFMinus) {
        
        LGFdate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] - dayNum*24*3600)];
        
    }
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateString =  [fmt stringFromDate:LGFdate];
    
    
    return dateString;
    
}

+ (NSDate *)SotherDayDate:(NSDate *)thisTime symbols:(timeType)symbols dayNum:(int)dayNum
{
    
    NSDate *LGFdate;
    
    if (symbols == LGFPlus) {
        
        LGFdate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] + dayNum*24*3600)];
        
    }else if (symbols == LGFMinus) {
        
        LGFdate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] - dayNum*24*3600)];
        
    }

    return LGFdate;
}

/**
 *  取得?天日期
 *
 *  @param thisTime 传入日期
 *  @param qian     天数
 *
 *  @return ?天日期
 */
+(NSDate*)otherDay:(NSDate *)thisTime symbols:(timeType)symbols dayNum:(int)dayNum
{
    NSDate *LGFdate;
    if (symbols == LGFPlus) {
        
        LGFdate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] + dayNum*24*3600)];
        
    }else if (symbols == LGFMinus) {
        
        LGFdate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] - dayNum*24*3600)];
    }
    return LGFdate;
}
/**
 *  取得?周日期
 *
 *  @param thisTime 传入当前日期
 *  @param qian     周数
 *
 *  @return ?周日期
 */
+(NSDate*)otherWeek:(NSDate*)thisTime
{
    
    NSDate *LGFWeekDate;

    NSInteger week =  [self nowTimeType:LGFweek time:thisTime];

    if (week == 1) {
        week = 8;
    }
    
    LGFWeekDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] - (week-1)*24*3600)];
    
    return LGFWeekDate;
    
}
/**
 *  取得?月日期
 *
 *  @param thisTime 传入当前日期
 *  @param qian     月数
 *
 *  @return ?月日期
 */
+(NSDate*)otherMonth:(NSDate*)thisTime
{
    
    NSDate *LGFMonthDate;
    
    NSInteger monthDay =  [self nowTimeType:LGFday time:thisTime];

    LGFMonthDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([thisTime timeIntervalSinceReferenceDate] - monthDay*24*3600)];
    
    return LGFMonthDate;
    
}
/**
 取得与当前日期差值
 */
+ (NSInteger)getDifferenceByDate:(id)date {
    
    NSDate *selectdate;
    
    if ([date isKindOfClass:[NSString class]]) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd";
        
        selectdate = [fmt dateFromString:date];
    }else{
    
        selectdate = date;
        
    }
    
    NSInteger nowtime = [[NSDate date] timeIntervalSince1970];
    
    NSInteger selecttime = [selectdate timeIntervalSince1970];
    
    NSInteger num = (nowtime - selecttime)/3600/24;
    
    return num;
}

+ (NSString *)getYear:(NSDate*)date{
    
    NSString * yearstr = [NSString stringWithFormat:@"%@年",[NSDate needDateStatus:YYYYType date:date]];
    return yearstr;
}

+ (NSString *)getTenYear:(NSDate*)date{
    
    NSString * yearstr = [NSString stringWithFormat:@"%@年",[NSDate needDateStatus:YYYYType date:date]];

    NSString * tenyearstr = [NSString stringWithFormat:@"%@年",[NSDate needDateStatus:YYYYType date:[NSDate needDateStrStatus:NotHaveType datestr:[NSDate GetTenYearDate:date]]]];
 
    return [NSString stringWithFormat:@"%@~%@",tenyearstr,yearstr];
}

+ (NSString *)getMonthBeginAndEndWith:(NSDate*)date{
    
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:date];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @"";
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"MM月dd日"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    NSInteger beginDateWeek = [NSDate nowTimeType:LGFweek time:beginDate];
    NSInteger endDateWeek = [NSDate nowTimeType:LGFweek time:endDate];
    NSArray *WeekArray = @[@"月",@"火",@"水",@"木",@"金",@"土",@"日"];
    
    NSString *s = [NSString stringWithFormat:@"%@（%@）〜　%@（%@）",beginString,WeekArray[beginDateWeek-1],endString,WeekArray[endDateWeek-1]];
    return s;
}

+ (NSString *)getWeekBeginAndEndWith:(NSDate*)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday
                                         fromDate:date];

    NSInteger weekDay = [comp weekday];

    NSInteger day = [comp day];

    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = -6;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 8 - weekDay;
    }
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"MM月dd日"];
    
    NSInteger beginDateWeek = [NSDate nowTimeType:LGFweek time:firstDayOfWeek];
    NSInteger endDateWeek = [NSDate nowTimeType:LGFweek time:lastDayOfWeek];
    NSArray *WeekArray = @[@"月",@"火",@"水",@"木",@"金",@"土",@"日"];
    
    NSString *s = [NSString stringWithFormat:@"%@（%@）〜　%@（%@）",[formater stringFromDate:firstDayOfWeek],WeekArray[beginDateWeek-1],[formater stringFromDate:lastDayOfWeek],WeekArray[endDateWeek-1]];
    
    return s;
}

+ (NSString *)GetTenYearDate:(NSDate*)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    [comp setYear:comp.year-10];

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    return [fmt stringFromDate:[calendar dateFromComponents:comp]];
}

@end
