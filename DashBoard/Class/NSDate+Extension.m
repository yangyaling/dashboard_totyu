//
//  NSDate+Extension.m
//  
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 huangziliang. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)


/**
   获取前三个月的日期
 */
+ (NSString *)getThreeMonthDate:(NSDate *)currentDate {
    
    
    NSCalendar*calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setYear:0];
    
    [comps setMonth:-3];
    
    [comps setDay:0];
    
    NSDate *newdate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    return [self NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:newdate];
    
}

///根据用户输入的时间(dateString)确定当天是星期几,输入的时间格式 yyyy-MM-dd ,如 2015-12-18
+ (NSString *)getTheDayOfTheWeekByDateString:(NSString *)dateString{
    
    NSDate *formatterDate=[self NeedDateFormat:@"yyyy-MM-dd" ReturnType:returndate date:dateString];

    NSInteger DateWeek = [NSDate nowTimeType:LGFweek time:formatterDate]-1;
    NSArray *WeekArray = @[@"月",@"火",@"水",@"木",@"金",@"土",@"日"];

    NSString *ruStr = [NSString stringWithFormat:@"%@(%@)",[self NeedDateFormat:@"yyyy年MM月dd日" ReturnType:returnstring date:formatterDate],WeekArray[DateWeek]];
     
    return ruStr;
}

+ (id)NeedDateFormat:(NSString*)DateFormat ReturnType:(ReturnType)ReturnType date:(id)date{

    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setTimeZone:[NSTimeZone systemTimeZone]];
    [fmt setLocale:[NSLocale systemLocale]];
    fmt.dateFormat = DateFormat;
    
    if ([date isKindOfClass:[NSDate class]]) {
        
        if (ReturnType == returnstring) {
            return [fmt stringFromDate:date];
        } else {
            return [fmt dateFromString:[fmt stringFromDate:date]];
        }
    } else {
        if (ReturnType == returnstring) {
            return [fmt stringFromDate:[fmt dateFromString:date]];
        } else {
            return [fmt dateFromString:date];
        }
    }
}

+ (NSString *)SharedToday
{
    //当前时间
    NSDate *nowDate = [NSDate new];
    return [self NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:nowDate];
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
    [fmt setTimeZone:[NSTimeZone systemTimeZone]];
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
    [fmt setTimeZone:[NSTimeZone systemTimeZone]];
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
    
    NSInteger hour12 = [[self NeedDateFormat:@"K" ReturnType:returnstring date:thisTime]intValue]-1;
    NSInteger ampm = [[self NeedDateFormat:@"aa" ReturnType:returnstring date:thisTime] isEqualToString:@"AM"]?0:1;
    
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
            } else {
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
    
    NSString *dateString = [self NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:LGFdate];
    
    
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
    if (date) {
        NSDate *selectdate;
        
        if ([date isKindOfClass:[NSString class]]) {
            selectdate = [self NeedDateFormat:@"yyyy-MM-dd" ReturnType:returndate date:date];
        } else {
            
            selectdate = date;
            
        }
        
        NSInteger nowtime = [[NSDate date] timeIntervalSince1970];
        
        NSInteger selecttime = [selectdate timeIntervalSince1970];
        
        NSInteger num = (nowtime - selecttime)/3600/24;
        
        return num;
    } else {
        return 0;
    }
}

+ (NSString *)getYear:(NSDate*)date{
    if (date) {
        NSString * yearstr = [NSString stringWithFormat:@"%@年",[NSDate NeedDateFormat:@"yyyy" ReturnType:returnstring date:date]];
        return yearstr;
    } else {
        return @"error";
    }
}

+ (NSString *)getTenYear:(NSDate*)date{
    if (date) {
        NSString * yearstr = [NSString stringWithFormat:@"%@年",[NSDate NeedDateFormat:@"yyyy" ReturnType:returnstring date:date]];
        
        NSString * tenyearstr = [NSString stringWithFormat:@"%@年",[NSDate NeedDateFormat:@"yyyy" ReturnType:returnstring date:[NSDate NeedDateFormat:@"yyyy-MM-dd" ReturnType:returndate date:[NSDate GetTenYearDate:date]]]];
        
        return [NSString stringWithFormat:@"%@~%@",tenyearstr,yearstr];
    } else {
        return @"error";
    }
}

+ (NSString *)getMonthBeginAndEndWith:(NSDate*)date{
    
    if (date) {
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

        NSString *beginString = [self NeedDateFormat:@"MM月dd日" ReturnType:returnstring date:beginDate];
        NSString *endString = [self NeedDateFormat:@"MM月dd日" ReturnType:returnstring date:endDate];
        NSInteger beginDateWeek = [NSDate nowTimeType:LGFweek time:beginDate];
        NSInteger endDateWeek = [NSDate nowTimeType:LGFweek time:endDate];
        NSArray *WeekArray = @[@"月",@"火",@"水",@"木",@"金",@"土",@"日"];
        
        NSString *s = [NSString stringWithFormat:@"%@（%@）〜　%@（%@）",beginString,WeekArray[beginDateWeek-1],endString,WeekArray[endDateWeek-1]];
        return s;
    } else {
        return @"error";
    }
}

+ (NSString *)getWeekBeginAndEndWith:(NSDate*)date{
    
    if (date) {

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
        } else {
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
        
        NSInteger beginDateWeek = [NSDate nowTimeType:LGFweek time:firstDayOfWeek];
        NSInteger endDateWeek = [NSDate nowTimeType:LGFweek time:lastDayOfWeek];
        NSArray *WeekArray = @[@"月",@"火",@"水",@"木",@"金",@"土",@"日"];
        
        NSString *s = [NSString stringWithFormat:@"%@（%@）〜　%@（%@）",[self NeedDateFormat:@"MM月dd日" ReturnType:returnstring date:firstDayOfWeek],WeekArray[beginDateWeek-1],[self NeedDateFormat:@"MM月dd日" ReturnType:returnstring date:lastDayOfWeek],WeekArray[endDateWeek-1]];
        
        return s;
    } else {
        return @"error";
    }
}

+ (NSString *)GetTenYearDate:(NSDate*)date{
    
    if (date) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
        
        [comp setYear:comp.year-10];
        
        return [self NeedDateFormat:@"yyyy-MM-dd" ReturnType:returnstring date:[calendar dateFromComponents:comp]];
    } else {
        return @"error";
    }
}
//比较日期大小
+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate{
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateformater setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *dta = [dateformater dateFromString:aDate];
    NSDate *dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dtb compare:dta];
    if (result == NSOrderedAscending){
        //bDate比aDate大
        return 0;
    } else if (result == NSOrderedSame){
        return 1;
    } else {
        return 2;
    }
}


@end
