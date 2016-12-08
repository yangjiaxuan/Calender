//
//  CalenderDataManager.h
//  Calender
//
//  Created by 杨森 on 16/6/21.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CalenderCellModel.h"

@interface CalenderDataManager : NSObject

@property (strong, nonatomic) NSDate *selectedDate1;    // 选中的日期1
@property (strong, nonatomic) NSDate *selectedDate2;    // 选中的日期2

+ (id)shareCalenderDataManager;

// 获得当前年份前后各years年的数据
+ (NSArray *)getCalenderDataWithPastAndFutureYears:(NSInteger)years;

// 获取未来year年的数据
+ (NSArray *)getCalenderDataWithFutureYears:(NSInteger)years;

// 获得当月的日历
+ (NSArray *)getCurrentMonthData;

// 获取日期当月的日历数据
+ (NSArray *)getMonthDataWithDate:(NSDate *)date;

// 以date为参考 正为未来|months|年的数据，负为以前|months|年的数据
+ (NSArray *)getCalenderDataFromDate:(NSDate *)date andMonths:(NSInteger)months;

// 获得当月在日期数组中的index section有效
+ (NSIndexPath *)getCurrentMonthIndexPathWithArr:(NSArray < NSArray<CalenderCellModel *> *>*)array;

// 获得某一月在日期数组中的index section有效
+ (NSIndexPath *)getMonthIndexPathWithDate:(NSDate *)date array:(NSArray < NSArray<CalenderCellModel *> *>*)array;

// 获得某一天在日期数组中的index section row 均有效
+ (NSIndexPath *)getDateIndexPathWithDate:(NSDate *)date array:(NSArray < NSArray<CalenderCellModel *> *>*)array;

@end
