//
//  ChineseCalender.h
//  Calender
//
//  Created by 杨森 on 16/6/22.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalenderCellModel.h"

static NSString * const ChineseCalenderHolidayKeyHoliday   = @"holiday";
static NSString * const ChineseCalenderHolidayKeyISHoliday = @"isHoliday";

@interface ChineseCalender : NSObject

+ (id)shareChineseCalender;

// key:ChineseCalenderHolidayKeyHoliday ChineseCalenderHolidayKeyISHoliday
- (NSDictionary *)getChineseCalenderWithDateComponents:(NSDateComponents *)dateComplents;

// 获取国际节假日
- (NSString *)internationHolidayWithDateComponents:(NSDateComponents *)dateComponents;
// 获取中国传统节假日
- (NSString *)chineseHolidayWithDateComponents:(NSDateComponents *)dateComponents;

@end
