//
//  YSCalender.m
//  Calender
//
//  Created by 杨森 on 16/6/20.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import "YSCalender.h"
#import "CalenderCell.h"

@implementation YSCalender

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupDatas];
        [self setupUI];
    }
    return self;
}

- (void)setupDatas{
    self.calenderDatas  = [self getCalenderDatas];
    self.dateSelectType = CalenderViewDateSelectTypeSelectOneDate;
}

- (void)setupUI{
    [self setCollectionView];
}

- (void)setCollectionView{

    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.minimumLineSpacing      = 0;
        flow.minimumInteritemSpacing = 0;
        flow.sectionInset = (UIEdgeInsets){};
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:flow];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[CalenderHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CalenderHeaderView"];
        [_collectionView registerClass:[CalenderCell class] forCellWithReuseIdentifier:@"CalenderCell"];
        [self addSubview:_collectionView];
    }

}
#pragma mark collection 代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
        return self.calenderDatas.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return [self.calenderDatas[section] count];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return (CGSize){self.width,self.width/4};
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CalenderHeaderView *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CalenderHeaderView" forIndexPath:indexPath];
    sectionHeader.headerStyle = self.viewStyle;
    sectionHeader.delegate    = self;
    if ([self.calenderDatas[indexPath.section][indexPath.row] isKindOfClass:[CalenderCellModel class]]) {
        sectionHeader.model   = [self.calenderDatas[indexPath.section]lastObject];
    }
    return sectionHeader;

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemWidth  = self.width/7;
    CGFloat itemHeight = itemWidth*CELL_SCALE;
    return (CGSize){itemWidth,itemHeight};
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    CalenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalenderCell" forIndexPath:indexPath];
    if ([self.calenderDatas[indexPath.section][indexPath.row] isKindOfClass:[CalenderCellModel class]]) {
        cell.cellModel = self.calenderDatas[indexPath.section][indexPath.row];
    }
    return cell;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CalenderCellModel *cellModel = self.calenderDatas[indexPath.section][indexPath.row];
    if (cellModel.style == CellDayTypeEmpty) {
        return NO;
    }
    if ([self.delegate respondsToSelector:@selector(calender:canSelectDate:)]) {
        return [self.delegate calender:self canSelectDate:self.calenderDatas[indexPath.section][indexPath.row]];
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(calender:canDeselectDate:)]) {
        return [self.delegate calender:self canDeselectDate:self.calenderDatas[indexPath.section][indexPath.row]];
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(calender:didDeselectDate:)]) {
        [self.delegate calender:self didDeselectDate:self.calenderDatas[indexPath.section][indexPath.row]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.calenderDatas.count) {
        return;
    }
    CalenderCellModel *cellModel = self.calenderDatas[indexPath.section][indexPath.row];
    CalenderDataManager *calenderDataManager = [CalenderDataManager shareCalenderDataManager];
    if (self.dateSelectType == CalenderViewDateSelectTypeSelectOneDate) {
        
        CalenderCellModel *lastCellModel = self.calenderDatas[self.selectedIndexPath1.section][self.selectedIndexPath1.row];
        lastCellModel.cellDayStateClick  = NO;
        
        BOOL canDeselect = [self collectionView:collectionView shouldDeselectItemAtIndexPath:self.selectedIndexPath1];
        if (canDeselect && lastCellModel) {
            [self collectionView:collectionView didDeselectItemAtIndexPath:self.selectedIndexPath1];
        }
        self.selectedIndexPath1           = indexPath;
        cellModel.cellDayStateClick       = YES;
        calenderDataManager.selectedDate1 = cellModel.date;
        
    }else{
        if (!self.selectedIndexPath1) {
            self.selectedIndexPath1           = indexPath;
            cellModel.cellDayStateClick       = YES;
            calenderDataManager.selectedDate1 = cellModel.date;
        }
        else if (![indexPath isEqual:self.selectedIndexPath1]&&!self.selectedIndexPath2){
            self.selectedIndexPath2           = indexPath;
            cellModel.cellDayStateClick       = YES;
            calenderDataManager.selectedDate2 = cellModel.date;
        }
        else if ([indexPath isEqual:self.selectedIndexPath2]){
            if ((self.selectedIndexPath2.section==indexPath.section)&&(self.selectedIndexPath2.row==indexPath.row)) {
                
                BOOL canDeselect = [self collectionView:collectionView shouldDeselectItemAtIndexPath:self.selectedIndexPath2];
                if (canDeselect) {
                    [self collectionView:collectionView didDeselectItemAtIndexPath:self.selectedIndexPath2];
                }
                
                cellModel.cellDayStateClick       = NO;
                calenderDataManager.selectedDate2 = nil;
                self.selectedIndexPath2           = nil;
            }
        }
        else if ([indexPath isEqual:self.selectedIndexPath1]){
            if ((self.selectedIndexPath1.section==indexPath.section)&&(self.selectedIndexPath1.row==indexPath.row)) {
                
                BOOL canDeselect = [self collectionView:collectionView shouldDeselectItemAtIndexPath:self.selectedIndexPath1];
                if (canDeselect) {
                    [self collectionView:collectionView didDeselectItemAtIndexPath:self.selectedIndexPath1];
                }
                
                cellModel.cellDayStateClick       = NO;
                self.selectedIndexPath1           = self.selectedIndexPath2;
                calenderDataManager.selectedDate1 = calenderDataManager.selectedDate2;
                calenderDataManager.selectedDate2 = nil;
                self.selectedIndexPath2           = nil;
            }
        }
    }
    [collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(calender:didSelectDate:)]) {
        [self.delegate calender:self didSelectDate:self.calenderDatas[indexPath.section][indexPath.row]];
    }
}

#pragma mark CalenderHeaderViewDelegate

- (void)calenderHeaderView:(CalenderHeaderView *)headerView didTapTitle:(NSString *)title{
    [self selectMonthWithCurrentCalenderModel:headerView.model];
}

- (void)calenderHeaderViewDidClickLastMonthBtn:(CalenderHeaderView *)headerView{
    [self lastMonthWithCurrentCalenderModel:headerView.model];
}

- (void)calenderHeaderViewDidClickNextMonthBtn:(CalenderHeaderView *)headerView{
    [self nextMonthWithCurrentCalenderModel:headerView.model];
}

- (void)calenderHeaderView:(CalenderHeaderView *)headerView didLongPressTitle:(NSString *)title{
    [self skipToOtherStyleCalenderWithCalenderModel:headerView.model headerTitle:title];
}

- (void)lastMonthWithCurrentCalenderModel:(CalenderCellModel *)calenderModel{}
- (void)nextMonthWithCurrentCalenderModel:(CalenderCellModel *)calenderModel{}
- (void)selectMonthWithCurrentCalenderModel:(CalenderCellModel *)calenderModel{}
- (void)skipToOtherStyleCalenderWithCalenderModel:(CalenderCellModel *)calenderModel headerTitle:(NSString *)headerTitle{}
- (void)reloadData{}
- (NSArray *)getCalenderDatas{
    return nil;
}

- (void)setViewStyle:(CalenderViewStyle)viewStyle{
    _viewStyle = viewStyle;
    if (_currentMonthPath&&self.viewStyle==CalenderViewStyleNomal) {
        [_collectionView selectItemAtIndexPath:_currentMonthPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredVertically];
    }
}
@end
