//
//  YSSingalMonthCalender.m
//  Calender
//
//  Created by 杨森 on 16/6/24.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import "YSSingalMonthCalender.h"
#import "YSWindow.h"

static  YSWindow *_calenderDatePickerWindow;

@implementation CalenderDatePickView
{
    UIButton *_cacleBtn; // 取消按钮
    UIButton *_sureBtn;  // 确定按钮
    UIPickerView *_datePick;  // 日期选择器
    NSArray      *_dateArr;   // 日期数据
    NSDateComponents  *_selectDateComponents;
    CalenderDatePickViewCompleteBlock _completeBlock;
}

- (instancetype)initWithFrame:(CGRect)frame completeSelectWithBlock:(CalenderDatePickViewCompleteBlock)block{
    _completeBlock = block;
    return [self initWithFrame:frame];
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    
    CGFloat w = frame.size.width;
    CGFloat h = 300;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat x = (screenW - w)/2;
    CGFloat y = (screenH - h)/2;
    CGRect modifFrame = CGRectMake(x, y, w, h);
    if (self = [super initWithFrame:modifFrame]) {
        [self setupData];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{

    _datePick = [[UIPickerView alloc]initWithFrame:(CGRect){{0,0},{self.width,self.height*4/5}}];
    _datePick.delegate   = self;
    _datePick.dataSource = self;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:_datePick];
    
    CGFloat perYearMonthWidth = self.width/19;
    NSArray *selMonBtnTitles   = @[@"取消",@"确定"];
    NSMutableArray *selMonBtns = [NSMutableArray array];
    for (NSInteger i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = (CGRect){{perYearMonthWidth*(i?15:1),self.height*4/5},{perYearMonthWidth*3,self.height/5}};
        [btn setTitle:selMonBtnTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 200 + i;
        [selMonBtns addObject:btn];
        [self addSubview:btn];
    }
    _cacleBtn = selMonBtns.firstObject;
    _sureBtn = selMonBtns.lastObject;
}

- (void)btnClick:(UIButton *)sender{
    //取消
    if (sender.tag == 200) {
        _completeBlock(nil,0);
    }// 确定
    else{
        NSInteger year  = _selectDateComponents.year;
        NSInteger month = _selectDateComponents.month;
        if (year < [_dateArr[0] count] && month < [_dateArr[1] count]) {
            NSString *yearStr  = [[[_dateArr firstObject][year]componentsSeparatedByString:@"年"] firstObject];
            NSString *monthStr = [[[_dateArr lastObject][month] componentsSeparatedByString:@"月"] firstObject];
            _selectedDate = [NSDate dateFromString:[NSString stringWithFormat:@"%@-%@-01",yearStr,monthStr]];
            _completeBlock(_selectedDate,(year-20)*12+month-[[NSDate date] components].month+1);
            NSLog(@"month:%lu,current:%lu",month,[[NSDate date] components].month);
        }
        else{
            _completeBlock(nil,0);
        }
    }
    [_calenderDatePickerWindow hiddenWindow];
    _calenderDatePickerWindow = nil;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.width/_dateArr.count;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return [_dateArr count];
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_dateArr[component] count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _dateArr[component][row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        _selectDateComponents.year = row;
    }
    else if (component == 1){
        _selectDateComponents.month = row;
    }
}
- (void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;
    NSDateComponents *currentDataComp = [currentDate components];   // 当前选中日期com
    NSDateComponents *dateComp        = [[NSDate date] components]; // 当前日期
    NSInteger yearIndex   = currentDataComp.year - dateComp.year + 20;
    NSInteger monthIndex  = currentDataComp.month - 1;
    [_datePick selectRow:yearIndex  inComponent:0 animated:YES];
    [_datePick selectRow:monthIndex inComponent:1 animated:YES];
    _selectDateComponents = [[NSDateComponents alloc]init];
    _selectDateComponents.year  = yearIndex;
    _selectDateComponents.month = monthIndex;
}

- (void)setupData{
    NSDateComponents *currentDateCompon = [[NSDate date]components];
    NSMutableArray *yearDates  = [NSMutableArray array];
    NSMutableArray *monthDates = [NSMutableArray array];
    for (NSInteger i= currentDateCompon.year - 20; i<currentDateCompon.year+100; i++) {
        [yearDates addObject:[NSString stringWithFormat:@"%lu年",i]];
    }
    for (NSInteger i = 1; i < 13; i++) {
        [monthDates addObject:[NSString stringWithFormat:@"%lu月",i]];
    }
    _dateArr = @[yearDates,monthDates];
}

@end

@implementation YSSingalMonthCalender

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.viewStyle = CalenderViewStyleSelectDate;
    }
    return self;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    CalenderCellModel *cellModel = self.calenderDatas[indexPath.section][indexPath.row];
//    CalenderDataManager *calenderDataManager = [CalenderDataManager shareCalenderDataManager];
//    if (self.dateSelectType == CalenderViewDateSelectTypeSelectOneDate) {
//        
//        CalenderCellModel *lastCellModel = self.calenderDatas[self.selectedIndexPath1.section][self.selectedIndexPath1.row];
//        lastCellModel.cellDayStateClick  = NO;
//        
//        BOOL canDeselect = [super collectionView:collectionView shouldDeselectItemAtIndexPath:self.selectedIndexPath1];
//        if (canDeselect && lastCellModel) {
//            [super collectionView:collectionView didSelectItemAtIndexPath:self.selectedIndexPath1];
//        }
//        self.selectedIndexPath1           = indexPath;
//        cellModel.cellDayStateClick       = YES;
//        calenderDataManager.selectedDate1 = cellModel.date;
//        
//    }else{
//        if (!self.selectedIndexPath1) {
//            self.selectedIndexPath1           = indexPath;
//            cellModel.cellDayStateClick       = YES;
//            calenderDataManager.selectedDate1 = cellModel.date;
//        }
//        else if (![indexPath isEqual:self.selectedIndexPath1]&&!self.selectedIndexPath2){
//            self.selectedIndexPath2           = indexPath;
//            cellModel.cellDayStateClick       = YES;
//            calenderDataManager.selectedDate2 = cellModel.date;
//        }
//        else if ([indexPath isEqual:self.selectedIndexPath2]){
//            if ((self.selectedIndexPath2.section==indexPath.section)&&(self.selectedIndexPath2.row==indexPath.row)) {
//                
//                BOOL canDeselect = [super collectionView:collectionView shouldDeselectItemAtIndexPath:self.selectedIndexPath2];
//                if (canDeselect) {
//                    [super collectionView:collectionView didSelectItemAtIndexPath:self.selectedIndexPath2];
//                }
//                
//                cellModel.cellDayStateClick       = NO;
//                calenderDataManager.selectedDate2 = nil;
//                self.selectedIndexPath2           = nil;
//            }
//        }
//        else if ([indexPath isEqual:self.selectedIndexPath1]){
//            if ((self.selectedIndexPath1.section==indexPath.section)&&(self.selectedIndexPath1.row==indexPath.row)) {
//                
//                BOOL canDeselect = [super collectionView:collectionView shouldDeselectItemAtIndexPath:self.selectedIndexPath1];
//                if (canDeselect) {
//                    [super collectionView:collectionView didSelectItemAtIndexPath:self.selectedIndexPath1];
//                }
//                
//                cellModel.cellDayStateClick       = NO;
//                self.selectedIndexPath1           = self.selectedIndexPath2;
//                calenderDataManager.selectedDate1 = calenderDataManager.selectedDate2;
//                calenderDataManager.selectedDate2 = nil;
//                self.selectedIndexPath2           = nil;
//            }
//        }
//    }
//    [collectionView reloadData];
//    
//    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
//}

// 上个月
- (void)lastMonthWithCurrentCalenderModel:(CalenderCellModel *)calenderModel{
    self.calenderDatas = nil;
    _monthLastDayModel = calenderModel;
    [self getCalenderDatasWithIndex:-1];
}
// 下个月
- (void)nextMonthWithCurrentCalenderModel:(CalenderCellModel *)calenderModel{
    self.calenderDatas = nil;
    _monthLastDayModel = calenderModel;
    [self getCalenderDatasWithIndex:1];
}
// 选中月
- (void)setMonthLastDayModel:(CalenderCellModel *)monthLastDayModel{
    _monthLastDayModel = monthLastDayModel;
    
    [self getCalenderDatasWithIndex:0];
    CalenderDataManager *calenderDataManager = [CalenderDataManager shareCalenderDataManager];
    self.selectedIndexPath1 = [CalenderDataManager getDateIndexPathWithDate:calenderDataManager.selectedDate1 array:self.calenderDatas];
    self.selectedIndexPath2 = [CalenderDataManager getDateIndexPathWithDate:calenderDataManager.selectedDate2 array:self.calenderDatas];
    [self.collectionView reloadData];
}

- (void)selectMonthWithCurrentCalenderModel:(CalenderCellModel *)calenderModel{

    __weak typeof(self) weakSelf = self;
    CalenderDatePickView *pickView = [[CalenderDatePickView alloc]initWithFrame:(CGRect){{},{(self.width-40),0}} completeSelectWithBlock:^(NSDate *selectedDate, NSInteger index) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf getCalenderDatasFromCurrentDateWithIndex:index];
    }];
    pickView.currentDate      = calenderModel.date;
    _calenderDatePickerWindow = [YSWindow showView:pickView];
}

// -1:上个月 0:本月 1:上个月 根据当前model的数据的日期信息 获得相应的日期信息
- (NSArray *)getCalenderDatasWithIndex:(NSInteger)index{
    if (!self.calenderDatas&&_monthLastDayModel) {
        self.calenderDatas = [self getCalenderDatasWithdate:_monthLastDayModel.date Index:index];
        [self.collectionView reloadData];
    }
    return self.calenderDatas;
}

// -1:上个月 0:本月 1:上个月 根据当前日期的数据 获得相应的日期信息
- (NSArray *)getCalenderDatasFromCurrentDateWithIndex:(NSInteger)index{
    self.calenderDatas = [self getCalenderDatasWithdate:[NSDate date] Index:index];
    [self.collectionView reloadData];
    return  self.calenderDatas;
}
// 以date为参考 正为未来|months|月的数据，负为以前|months|月的数据
- (NSArray *)getCalenderDatasWithdate:(NSDate *)date Index:(NSInteger)index{
    return [NSArray arrayWithObject:[CalenderDataManager getCalenderDataFromDate:date andMonths:index]];
}

- (void)setViewStyle:(CalenderViewStyle)viewStyle{
    [super setViewStyle:viewStyle];
}

@end
