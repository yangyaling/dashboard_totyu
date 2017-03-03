//
//  NSDate+Extension.h
//
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 huangziliang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    HaveHMSType,
    JapanHMSType,
    JapanMDType,
    NotHaveType,
    DDType,
    YYYYType,
    hhmmssType,
    JapanHMDType,
    HMSType
    
}DateStatus;

typedef enum {

    LGFweekofyear = 10,
    LGFampm = 9,       //上午下午
    LGFyear = 8,       //年
    LGFmonth = 7,      //月
    LGFweek = 6,       //周
    LGFday = 5,        //日
    LGFhour24 = 4,     //24小时
    LGFhour12 = 3,     //12小时
    LGFminute = 2,     //分
    LGFsecond = 1,     //秒
    
    LGFPlus,           // +
    LGFMinus,          // -
    
}timeType;

@interface NSDate (Extension)

/**
 获取前三个月的日期
 */
+ (NSString *)getThreeMonthDate:(NSDate *)currentDate;



/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear;
/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday;


/**
  获取当前是星期几

 @param dateString 输入当前日期
 @return 返回当天星期
 */
+ (NSString *)getTheDayOfTheWeekByDateString:(NSString *)dateString;

/**
 *  获取今天的日期
 *
 *  @return 字符串型的今天
 */
+ (NSString *)SharedToday;

/**
 *  获取当前时间格式样式
 *
 *  @param type 需要的种类
 *
 *  @return 字符型格式
 */
+ (NSString *)needDateStatus:(DateStatus)type date:(NSDate*)date;
+ (NSDate *)needDateStrStatus:(DateStatus)type datestr:(NSString*)datestr;
//-----------------------------------------------------------------------------
/**
 *  单位时间取得
 *
 *  @param timeType 单位时间名字
 *  @param thisTime 传入时间
 *
 *  @return 时间格式化数字
 */
+(NSInteger)nowTimeType:(timeType)timeType time:(NSDate*)thisTime;
/**
 *  取得?天日期
 */
+(NSDate*)otherDay:(NSDate*)thisTime symbols:(timeType)symbols dayNum:(int)dayNum;
/**
 *  取得?周日期
 */
+(NSDate*)otherWeek:(NSDate*)thisTime;
/**
 *  取得?月日期
 */
+(NSDate*)otherMonth:(NSDate*)thisTime;
/**
 *  取得?天日期   字符串
 */
+ (NSString *)SotherDay:(NSDate *)thisTime symbols:(timeType)symbols dayNum:(int)dayNum;
+ (NSDate *)SotherDayDate:(NSDate *)thisTime symbols:(timeType)symbols dayNum:(int)dayNum;
/**
 取得与当前日期差值
 */
+ (NSInteger)getDifferenceByDate:(id)date;

//选择月日期范围
+ (NSString *)getMonthBeginAndEndWith:(NSDate*)date;
//选择周日期范围
+ (NSString *)getWeekBeginAndEndWith:(NSDate*)date;
//选择年日期范围
+ (NSString *)getYear:(NSDate*)date;
//选择十年日期范围
+ (NSString *)getTenYear:(NSDate*)date;

+ (NSString *)GetTenYearDate:(NSDate*)date;
@end
