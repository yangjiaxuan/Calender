//
//  CalenderCellModel.h
//  Calender
//
//  Created by 杨森 on 16/6/20.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CalenderCellDayType) {
    
    CellDayTypeEmpty,   //不显示
    CellDayTypePast,    //以前
    CellDayTypeNow,     //当前
    CellDayTypeFutur,   //以后
    
};

struct CalenderCellDayState{

    BOOL CellDayStateWeek;    //周末
    BOOL CellDayStateHoliday; //节假日
    BOOL CellDayStateClick;    //被点击的日期

};
typedef struct CalenderCellDayState CalenderCellDayState;
NS_INLINE CalenderCellDayState CalenderCellDayStateMake(BOOL CellDayStateWeek, BOOL CellDayStateHoliday, BOOL CellDayStateClick){
    return (CalenderCellDayState){CellDayStateWeek,CellDayStateHoliday,CellDayStateClick};
}

@interface CalenderCellModel : NSObject

@property (assign, nonatomic) NSUInteger day;  //天
@property (assign, nonatomic) NSUInteger month;//月
@property (assign, nonatomic) NSUInteger year; //年
@property (assign, nonatomic) NSUInteger week; //周
@property (strong, nonatomic) NSDate     *date;//日期

@property (copy, nonatomic) NSString *ChineseCalendar;//农历 或者 节假日

@property (assign, nonatomic) CalenderCellDayType originalStyle;//原有日期的类型
@property (assign, nonatomic) CalenderCellDayType style;        //日期的类型
@property (assign, nonatomic) CalenderCellDayState state;        //日期的状态

@property (assign, nonatomic) BOOL cellDayStateWeek;    //周末
@property (assign, nonatomic) BOOL cellDayStateHoliday; //节假日
@property (assign, nonatomic) BOOL cellDayStateClick;   //被点击的日期

@end
