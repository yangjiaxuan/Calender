//
//  CalenderCellModel.m
//  Calender
//
//  Created by 杨森 on 16/6/20.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import "CalenderCellModel.h"

@implementation CalenderCellModel

- (instancetype)init{
    if (self = [super init]) {
        self.style = CellDayTypeFutur;
        self.state = CalenderCellDayStateMake(NO,NO,NO);
    }
    return self;
}

- (BOOL)cellDayStateHoliday{
    return self.state.CellDayStateHoliday;
}
- (void)setCellDayStateHoliday:(BOOL)cellDayStateHoliday{
    CalenderCellDayState state = self.state;
    state.CellDayStateHoliday = cellDayStateHoliday;
    self.state = state;
}
- (BOOL)cellDayStateWeek{
    return self.state.CellDayStateWeek;
}
- (void)setCellDayStateWeek:(BOOL)cellDayStateWeek{
    CalenderCellDayState state = self.state;
    state.CellDayStateWeek = cellDayStateWeek;
    self.state = state;
}
- (BOOL)cellDayStateClick{
    return self.state.CellDayStateClick;
}
- (void)setCellDayStateClick:(BOOL)cellDayStateClick{
    CalenderCellDayState state = self.state;
    state.CellDayStateClick = cellDayStateClick;
    self.state = state;
}

@end
