//
//  CalenderDataManager.m
//  Calender
//
//  Created by 杨森 on 16/6/21.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import "CalenderDataManager.h"
#import "NSDate+Calender.h"
#import "ChineseCalender.h"

@implementation CalenderDataManager

static CalenderDataManager *manager = nil;
+ (id)shareCalenderDataManager{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CalenderDataManager alloc]init];
    });
    return manager;
}
// 获得前后各year年的数据
+ (NSArray *)getCalenderDataWithPastAndFutureYears:(NSInteger)years{
    
    NSArray *futureData = [self getCalenderDataWithYears:years + 1];
    NSArray *pastData   = [self getCalenderDataWithYears:-years];
    NSMutableArray *data = [NSMutableArray arrayWithArray:pastData];
    [data addObjectsFromArray:futureData];
    return [data copy];
}

// 获取未来year年的数据
+ (NSArray *)getCalenderDataWithFutureYears:(NSInteger)years{
    return [self getCalenderDataWithYears:years + 1];;
}

// 正为未来|year|年的数据，负为以前|years|年的数据
+ (NSArray *)getCalenderDataWithYears:(NSInteger)years{

    NSDate *currentDate = [NSDate date];
    NSDate *firthMonthData = [currentDate firstDayOfCurrentMonth];
    NSMutableArray *yearArr = [NSMutableArray array];
    
    NSInteger monthNum = 0;
    NSInteger monthBeg = 0;
    if (years>0) {
        monthBeg = 0;
        monthNum = years*12;
    }
    else{
        monthBeg = years*12;
        monthNum = 0;
    }
    for (NSInteger month = monthBeg; month < monthNum; month ++) {
        NSDate *date = [firthMonthData dayInTheNextMonth:month];
        NSArray *monthArr = [self getCalenderDataFromDate:date andMonths:0];
        [yearArr addObject:monthArr];
    }
    return yearArr;
}

+ (NSArray *)getCurrentMonthData{
   return [[self getMonthDataWithDate:[NSDate date]]copy];
}

+ (NSArray *)getMonthDataWithDate:(NSDate *)date{
    return [[NSMutableArray arrayWithObject:[self getCalenderDataFromDate:date andMonths:0]]copy];
}
// 以date为参考 正为未来|months|月的数据，负为以前|months|月的数据
+ (NSArray *)getCalenderDataFromDate:(NSDate *)date andMonths:(NSInteger)months{

    CalenderDataManager *manager = [CalenderDataManager shareCalenderDataManager];
    NSDate *getMonthsDate    = [date dayInTheNextMonth:months];
    NSInteger monthCount     = [getMonthsDate numberOfDaysInCurrentMonth];
    NSMutableArray *monthArr = [NSMutableArray array];
    NSDate *firthMonthDate   = [getMonthsDate firstDayOfCurrentMonth];
    NSDate *currentDate      = [NSDate date];

    for (NSInteger day = 0; day < [firthMonthDate components].weekday-1; day ++) {
        CalenderCellModel *model = [[CalenderCellModel alloc]init];
        model.style = CellDayTypeEmpty;
        [monthArr addObject:model];
    }
    for (NSInteger day = 0; day < monthCount; day ++) {
        NSDate *dayDate            = [firthMonthDate dayInTheNextDay:day];
        NSDateComponents *dateComp = [dayDate components];
        CalenderCellModel *model = [[CalenderCellModel alloc]init];
        model.day   = dateComp.day;
        model.week  = dateComp.weekday;
        model.month = dateComp.month;
        model.year  = dateComp.year;
        model.date  = dayDate;
        NSDictionary *holidayDic = [[ChineseCalender shareChineseCalender]getChineseCalenderWithDateComponents:dateComp];
        model.ChineseCalendar = [holidayDic objectForKey:ChineseCalenderHolidayKeyHoliday];
        if ([dayDate isSameDayWithDate:currentDate]) {
            model.style = CellDayTypeNow;
        }
        if ([[holidayDic objectForKey:ChineseCalenderHolidayKeyISHoliday] integerValue]) {
            model.cellDayStateHoliday = YES;
        }
        if (dateComp.weekday == 1 || dateComp.weekday == 7) {
            model.cellDayStateWeek = YES;
        }

        if ([manager.selectedDate1 isSameDayWithDate:dayDate]||[manager.selectedDate2 isSameDayWithDate:dayDate]) {
            model.cellDayStateClick = YES;
        }
        model.originalStyle   = model.style;
        [monthArr addObject:model];
    }
    return [monthArr copy];
}

+ (NSIndexPath *)getCurrentMonthIndexPathWithArr:(NSArray < NSArray<CalenderCellModel *> *>*)array{
    
    return [self getMonthIndexPathWithDate:[NSDate date] array:array];
}

+ (NSIndexPath *)getMonthIndexPathWithDate:(NSDate *)date array:(NSArray < NSArray<CalenderCellModel *> *>*)array{
    
    return [self getDateIndexPathWithDate:date isDay:NO array:array];

}

+ (NSIndexPath *)getDateIndexPathWithDate:(NSDate *)date array:(NSArray < NSArray<CalenderCellModel *> *>*)array{

    return [self getDateIndexPathWithDate:date isDay:YES array:array];

}
+ (NSIndexPath *)getDateIndexPathWithDate:(NSDate *)date isDay:(BOOL)isDay array:(NSArray < NSArray<CalenderCellModel *> *>*)array{
    
    NSInteger firItemYear  = 0;
    NSInteger firItemMonth = 0;

    CalenderCellModel *firModel = [array[0] lastObject];
    firItemYear                 = firModel.year;
    firItemMonth                = firModel.month;
    
    NSDateComponents *curDateComp = [date components];
    NSInteger curItemYear         = curDateComp.year;
    NSInteger curItemMonth        = curDateComp.month;

    NSInteger section = (curItemYear - firItemYear)*12 + curItemMonth - firItemMonth;
    if (section <= array.count) {
        if (!isDay) {
            return [NSIndexPath indexPathForItem:0 inSection:section];
        }
        else{
            NSArray   *monthDatas          = array[section];
            NSInteger curItemDay           = curDateComp.day;
            NSInteger firItemSDay          = 0;
            CalenderCellModel *firModelS   = [monthDatas lastObject];
            firItemSDay                    = firModelS.day;
            NSInteger row = monthDatas.count - firItemSDay + curItemDay - 1;
            if (row >= 0 && row < monthDatas.count) {
                return [NSIndexPath indexPathForItem:row inSection:section];
            }
        }
    }
    return nil;

}
@end
