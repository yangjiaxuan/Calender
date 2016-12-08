//
//  CalenderHeaderView.h
//  Calender
//
//  Created by 杨森 on 16/6/20.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalenderCellModel.h"

typedef NS_ENUM(NSInteger, CalenderViewStyle){
    CalenderViewStyleNomal,     // 正常的状态
    CalenderViewStyleSelectDate // 可以选择年份月份
};

@class CalenderHeaderView;

typedef void (^MonthBtnClickBlock)(CalenderHeaderView *headerView);
typedef void (^TitleClickBlock)(CalenderHeaderView *headerView, NSString *title);

@protocol CalenderHeaderViewDelegate <NSObject>

// title长按 当前的年月
- (void)calenderHeaderView:(CalenderHeaderView *)headerView didTapTitle:(NSString *)title;

// 点击上一月
- (void)calenderHeaderViewDidClickLastMonthBtn:(CalenderHeaderView *)headerView;
// 点击下一月
- (void)calenderHeaderViewDidClickNextMonthBtn:(CalenderHeaderView *)headerView;
// title长按 当前的年月
- (void)calenderHeaderView:(CalenderHeaderView *)headerView didLongPressTitle:(NSString *)title;

@end

@interface CalenderHeaderView : UICollectionReusableView

@property (strong, nonatomic)CalenderCellModel *model;
@property (assign, nonatomic)CalenderViewStyle headerStyle; // 日历透视图格式
@property (weak, nonatomic) id <CalenderHeaderViewDelegate> delegate;
@property (copy, nonatomic) TitleClickBlock     titleTapBlock;

// 只有在 headerStyle = CalenderViewStyleSelectDate 状态下下边属性才会起作用
@property (copy, nonatomic) MonthBtnClickBlock  lastMonthBtnClickBlock;
@property (copy, nonatomic) MonthBtnClickBlock  nextMonthBtnClickBlock;
@property (copy, nonatomic) TitleClickBlock     titleLongPressBlock;

@end
