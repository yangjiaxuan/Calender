//
//  NSDate+Calender.h
//  Calender
//
//  Created by ys on 16/6/21.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Calender)

// 比后面的date晚多少个月 正为晚，负为早
- (NSInteger)numOfMonthsThanDate:(NSDate *)date;
// 本月天数
- (NSUInteger)numberOfDaysInCurrentMonth;
// 本月周数
- (NSUInteger)numberOfWeeksInCurrentMonth;
// 周几
- (NSUInteger)week;
// 当月第一天的日期
- (NSDate *)firstDayOfCurrentMonth;
// 当月最后一天的日期
- (NSDate *)lastDayOfCurrentMonth;
// 
- (NSDate *)dayInTheLastMonth;

- (NSDate *)dayInTheNextMonth;

- (NSDate *)dayInTheNextMonth:(NSInteger)month;//获取当前日期之后的几个月

- (NSDate *)dayInTheNextDay:(NSInteger)day;//获取当前日期之后的几个天

- (NSDateComponents *)components;

+ (NSDate *)dateFromString:(NSString *)dateString;//NSString转NSDate

- (NSString *)stringFromDate:(NSDate *)date;//NSDate转NSString

+ (NSInteger)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday;

- (NSInteger)getWeekIntValueWithDate;


//今天,明天,后天,周一
-(NSString *)weekString;

//通过数字返回星期几
+(NSString *)getWeekStringFromWeekNum:(NSInteger)week;

// 判断是否为同一天
- (BOOL)isSameDayWithDate:(NSDate *)date;

@end
