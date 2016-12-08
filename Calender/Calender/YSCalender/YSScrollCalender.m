//
//  YSScrollCalender.m
//  Calender
//
//  Created by 杨森 on 16/6/24.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import "YSScrollCalender.h"
#import "YSSingalMonthCalender.h"
#import "YSWindow.h"
@interface YSScrollCalender()<YSWindowDelegete>

@end

@implementation YSScrollCalender
{
    YSWindow *_subWindow;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.viewStyle = CalenderViewStyleNomal;
    }
    return self;
}

- (void)skipToOtherStyleCalenderWithCalenderModel:(CalenderCellModel *)calenderModel headerTitle:(NSString *)headerTitle{
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat singalMonthCalenderH = screenW * 1.2;
    YSSingalMonthCalender *singalMonthCalender = [[YSSingalMonthCalender alloc]initWithFrame:(CGRect){{0,screenH - singalMonthCalenderH},{screenW,singalMonthCalenderH}}];
    singalMonthCalender.monthLastDayModel = calenderModel;
    _subWindow = [YSWindow showView:singalMonthCalender];
    _subWindow.delegate = self;
}

- (NSArray *)getCalenderDatas{
    if (!self.calenderDatas) {
        self.calenderDatas = [CalenderDataManager getCalenderDataWithPastAndFutureYears:1];
        self.currentMonthPath = [CalenderDataManager getCurrentMonthIndexPathWithArr:self.calenderDatas];
        CalenderDataManager *calenderDataManager = [CalenderDataManager shareCalenderDataManager];
        self.selectedIndexPath1 = [CalenderDataManager getDateIndexPathWithDate:calenderDataManager.selectedDate1 array:self.calenderDatas];
        self.selectedIndexPath2 = [CalenderDataManager getDateIndexPathWithDate:calenderDataManager.selectedDate2 array:self.calenderDatas];
    }
    return self.calenderDatas;
}

- (void)setViewStyle:(CalenderViewStyle)viewStyle{
    [super setViewStyle:viewStyle];
}

- (void)reloadData{
    self.calenderDatas = nil;
    [self getCalenderDatas];
    [self.collectionView reloadData];
}

#pragma mark window 代理
- (void)windowWillDismissWithWindow:(YSWindow *)window{
    [self reloadData];
}
- (void)windowDidDismissWithWindow:(YSWindow *)window{


}

@end
