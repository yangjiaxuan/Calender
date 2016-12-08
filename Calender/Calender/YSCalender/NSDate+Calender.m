//
//  NSDate+Calender.m
//  Calender
//
//  Created by ys on 16/6/21.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import "NSDate+Calender.h"

@implementation NSDate (Calender)

// 比后面的date晚多少个月
- (NSInteger)numOfMonthsThanDate:(NSDate *)date{

    NSDateComponents *currentDataComp = [self components];
    NSDateComponents *dateComp        = [date components];
    NSInteger months = (currentDataComp.year - dateComp.year)*12 + currentDataComp.month - dateComp.month;
    return months;
}

// 是不是同一天
- (BOOL)isSameDayWithDate:(NSDate *)date{

    NSDateComponents *currentDataComp = [self components];
    NSDateComponents *dateComp        = [date components];
    if ((currentDataComp.year == dateComp.year)&&(currentDataComp.month == dateComp.month)&&(currentDataComp.day == dateComp.day)) {
        return YES;
    }
    else{
        return NO;
    }

}
/*计算这个月有多少天*/
- (NSUInteger)numberOfDaysInCurrentMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}


//获取这个月有多少周
- (NSUInteger)numberOfWeeksInCurrentMonth
{
    NSUInteger weekday = [[self firstDayOfCurrentMonth] week];
    NSUInteger days = [self numberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;
    
    if (weekday > 1) {
        weeks += 1, days -= (7 - weekday + 1);
    }
    
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    
    return weeks;
}

// 周几
- (NSUInteger)week
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}

- (NSDate *)firstDayOfCurrentMonth
{
    NSDate *startDate = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&startDate interval:NULL forDate:self];
    return startDate;
}

- (NSDate *)lastDayOfCurrentMonth
{
    NSCalendarUnit calendarUnit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:self];
    dateComponents.day = [self numberOfDaysInCurrentMonth];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

//上个月
- (NSDate *)dayInTheLastMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//下个月
- (NSDate *)dayInTheNextMonth
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//获取当前日期之后的几个月
- (NSDate *)dayInTheNextMonth:(NSInteger)month
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = month;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//获取当前日期之后的几个天
- (NSDate *)dayInTheNextDay:(NSInteger)day
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = day;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

//获取年月日对象
- (NSDateComponents *)components
{
    return [[NSCalendar currentCalendar] components:
            NSYearCalendarUnit|
            NSMonthCalendarUnit|
            NSDayCalendarUnit|
            NSWeekdayCalendarUnit fromDate:self];
}

//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)dateString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}



//NSDate转NSString
- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}


+ (NSInteger)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//日历控件对象
    NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:today toDate:beforday options:0];
    NSInteger day = [components day];//两个日历之间相差多少月//
    return day;
}

//周日:1，周一:2 ...
- (NSInteger)getWeekIntValueWithDate
{
    NSInteger weekIntValue = 0;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    NSDateComponents *comps= [calendar components:(NSYearCalendarUnit |
                                                   NSMonthCalendarUnit |
                                                   NSDayCalendarUnit |
                                                   NSWeekdayCalendarUnit) fromDate:self];
    return weekIntValue = [comps weekday];
}

- (NSString *)weekString
{
    NSDate *todate = [NSDate date];//今天
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    NSDateComponents *comps_today= [calendar components:(NSYearCalendarUnit |
                                                         NSMonthCalendarUnit |
                                                         NSDayCalendarUnit |
                                                         NSWeekdayCalendarUnit) fromDate:todate];
    
    
    NSDateComponents *comps_other= [calendar components:(NSYearCalendarUnit |
                                                         NSMonthCalendarUnit |
                                                         NSDayCalendarUnit |
                                                         NSWeekdayCalendarUnit) fromDate:self];
    
    
    //获取星期对应的数字
    NSInteger weekIntValue = [self getWeekIntValueWithDate];
    
    if (comps_today.year == comps_other.year &&
        comps_today.month == comps_other.month &&
        comps_today.day == comps_other.day) {
        return @"今天";
        
    }else if (comps_today.year == comps_other.year &&
              comps_today.month == comps_other.month &&
              (comps_today.day - comps_other.day) == -1){
        return @"明天";
        
    }else if (comps_today.year == comps_other.year &&
              comps_today.month == comps_other.month &&
              (comps_today.day - comps_other.day) == -2){
        return @"后天";
        
    }else{
        return [NSDate getWeekStringFromWeekNum:weekIntValue];//周几
    }
}

+ (NSString *)getWeekStringFromWeekNum:(NSInteger)week
{
    NSString *str_week;
    switch (week) {
        case 1:
            str_week = @"周日";
            break;
        case 2:
            str_week = @"周一";
            break;
        case 3:
            str_week = @"周二";
            break;
        case 4:
            str_week = @"周三";
            break;
        case 5:
            str_week = @"周四";
            break;
        case 6:
            str_week = @"周五";
            break;
        case 7:
            str_week = @"周六";
            break;
    }
    return str_week;
}

@end
