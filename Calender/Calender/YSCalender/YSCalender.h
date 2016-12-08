//
//  YSCalender.h
//  Calender
//
//  Created by 杨森 on 16/6/20.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalenderHeaderView.h"
#import "CalenderDataManager.h"
#import "NSDate+Calender.h"
#import "UIView+Frame.h"

@protocol YSCalenderDelegate;

typedef NS_ENUM(NSInteger, CalenderViewDateSelectType){

    CalenderViewDateSelectTypeSelectOneDate,   // 选择一个时间
    CalenderViewDateSelectTypeSelectedPeriod,  // 选择一个时间段
};

@interface YSCalender :UIView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CalenderHeaderViewDelegate>

@property (assign, nonatomic) CalenderViewStyle viewStyle;
@property (nonatomic)         NSArray *calenderDatas;
@property (nonatomic)         UICollectionView *collectionView;
@property (nonatomic)         NSIndexPath      *currentMonthPath;   // 现今月的indexPath
@property (nonatomic)         NSIndexPath      *selectedIndexPath1;
@property (nonatomic)         NSIndexPath      *selectedIndexPath2;

@property (assign, nonatomic) CalenderViewDateSelectType *dateSelectType;

@property (weak, nonatomic)  id <YSCalenderDelegate> delegate;

- (NSArray *)getCalenderDatas;
// 下一月
- (void)nextMonthWithCurrentCalenderModel:(CalenderCellModel *)calenderModel;
// 选择年月
- (void)selectMonthWithCurrentCalenderModel:(CalenderCellModel *)calenderModel;

// 调转到其他格式日历时调用
- (void)skipToOtherStyleCalenderWithCalenderModel:(CalenderCellModel *)calenderModel headerTitle:(NSString *)headerTitle;

// 上一月
- (void)lastMonthWithCurrentCalenderModel:(CalenderCellModel *)calenderModel;

- (void)reloadData;

@end

@protocol YSCalenderDelegate <NSObject>

- (BOOL)calender:(YSCalender *)calender canSelectDate:(CalenderCellModel *)dateModel;

- (BOOL)calender:(YSCalender *)calender canDeselectDate:(CalenderCellModel *)dateModel;

- (void)calender:(YSCalender *)calender didSelectDate:(CalenderCellModel *)dateModel;

- (void)calender:(YSCalender *)calender didDeselectDate:(CalenderCellModel *)dateModel;

@end
