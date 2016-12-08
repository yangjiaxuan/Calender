//
//  ViewController.m
//  Calender
//
//  Created by 杨森 on 16/6/20.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import "ViewController.h"
#import "YSScrollCalender.h"

@interface ViewController ()<YSCalenderDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YSScrollCalender *calender = [[YSScrollCalender alloc]initWithFrame:self.view.bounds];
    calender.delegate = self;
    [self.view addSubview:calender];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (BOOL)calender:(YSCalender *)calender canSelectDate:(CalenderCellModel *)dateModel{
    return YES;
}

- (BOOL)calender:(YSCalender *)calender canDeselectDate:(CalenderCellModel *)dateModel{
    return YES;
}

- (void)calender:(YSCalender *)calender didSelectDate:(CalenderCellModel *)dateModel{
    NSLog(@"选择了日期：%@",dateModel.date);
}

- (void)calender:(YSCalender *)calender didDeselectDate:(CalenderCellModel *)dateModel{
     NSLog(@"取消选择了日期：%@",dateModel.date);
}

@end
