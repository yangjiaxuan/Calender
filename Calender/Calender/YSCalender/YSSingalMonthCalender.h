//
//  YSSingalMonthCalender.h
//  Calender
//
//  Created by 杨森 on 16/6/24.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import "YSCalender.h"

typedef void(^CalenderDatePickViewCompleteBlock)(NSDate *selectedDate, NSInteger index);

@interface CalenderDatePickView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSDate *currentDate;  // 初始化时显示的日期  只要求年月精确即可

@property (strong, nonatomic) NSDate *selectedDate; // 仅年月有效

- (instancetype)initWithFrame:(CGRect)frame completeSelectWithBlock:(CalenderDatePickViewCompleteBlock)block;

@end

@class YSSingalMonthCalender;
@protocol YSSingalMonthCalenderDelegate <YSCalenderDelegate>

- (void)singalMonthCalenderWillDismissWithCalender:(YSSingalMonthCalender *)singalMonthCalender;
- (void)singalMonthCalenderDidDismissWithCalender:(YSSingalMonthCalender *)singalMonthCalender;

@end


@interface YSSingalMonthCalender : YSCalender

@property (strong, nonatomic) CalenderCellModel *monthLastDayModel;

@end
