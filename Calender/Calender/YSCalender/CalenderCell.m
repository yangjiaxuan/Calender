//
//  CalenderCell.m
//  Calender
//
//  Created by 杨森 on 16/6/20.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import "CalenderCell.h"

#define SELF_WIDTH  self.frame.size.width
#define SELF_HEIGHT self.frame.size.height
#define PER_HEIGHT  (SELF_HEIGHT/11)


@implementation CalenderCell
{
    UIView  *_backView;   // 背景视图
    UILabel *_dayLabel;   // 第几天
    UILabel *_titleLabel; // 周末或者节假日
    UIImageView *_imageView; // 第几天后面的圆形视图
}
- (instancetype)initWithFrame:(CGRect)frame{

    CGPoint origin = frame.origin;
    CGSize  size   = frame.size;
    frame = (CGRect){{origin.x,origin.y},{size.height*CELL_SCALE, size.height}};
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        _scale = CELL_SCALE;
    }
    return self;
}

- (void)setupUI{

    self.backgroundColor = [UIColor whiteColor];
    _backView         = [UIView new];
    _backView.frame   = self.bounds;
    [self addSubview:_backView];
    
    _imageView        = [UIImageView new];
    _imageView.frame  = (CGRect){{PER_HEIGHT,0},{PER_HEIGHT*6, PER_HEIGHT*6}};
    [_backView addSubview:_imageView];
    
    _dayLabel         = [UILabel new];
    _dayLabel.frame   = (CGRect){{0,0},{PER_HEIGHT*6, PER_HEIGHT*6}};
    _dayLabel.font    = [UIFont systemFontOfSize:floor(PER_HEIGHT*6*3/5)];
    _dayLabel.textAlignment = NSTextAlignmentCenter;
    [_imageView addSubview:_dayLabel];
    
    _titleLabel       = [UILabel new];
    _titleLabel.font  = [UIFont systemFontOfSize:floor(PER_HEIGHT*3*3/5)];
    _titleLabel.frame = (CGRect){{0,SELF_HEIGHT-5*PER_HEIGHT},{SELF_HEIGHT/CELL_SCALE, PER_HEIGHT*3}};
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
}

- (void)setCellModel:(CalenderCellModel *)cellModel{
    _cellModel = cellModel;
    if (cellModel.style == CellDayTypeEmpty) {
        _backView.hidden = YES;
    }
    else if (cellModel.style == CellDayTypePast) {
        _backView.hidden = NO;
        _imageView.image = self.nomalImage;
        _dayLabel.textColor   = [UIColor lightGrayColor];
        _titleLabel.textColor = [UIColor lightGrayColor];
    }
    else if (cellModel.style == CellDayTypeNow) {
        _backView.hidden = NO;
        _imageView.image = self.todayImage;
        _dayLabel.textColor   = [UIColor whiteColor];
        _titleLabel.textColor = [UIColor blackColor];
    }
    else if (cellModel.style == CellDayTypeFutur) {
        _backView.hidden = NO;
        _imageView.image = self.nomalImage;
        _dayLabel.textColor   = [UIColor blackColor];
        _titleLabel.textColor = [UIColor blackColor];
    }
    if (cellModel.cellDayStateHoliday) {
        _backView.hidden = NO;
        _imageView.image = self.nomalImage;
        _dayLabel.textColor   = [UIColor blackColor];
        _titleLabel.textColor = [UIColor purpleColor];
    }
    if (cellModel.cellDayStateWeek) {
        _backView.hidden = NO;
        _imageView.image = self.nomalImage;
        _dayLabel.textColor   = [UIColor redColor];
        if (!cellModel.cellDayStateHoliday) {
            _titleLabel.textColor = [UIColor redColor];
        }
    }
    if (cellModel.state.CellDayStateClick) {
        _backView.hidden = NO;
        _imageView.image = self.selectedImage;
        _dayLabel.textColor   = [UIColor whiteColor];
        if (!cellModel.cellDayStateHoliday && !cellModel.cellDayStateWeek) {
            _titleLabel.textColor = [UIColor blackColor];
        }
    }
    _dayLabel.text   = [NSString stringWithFormat:@"%lu",cellModel.day];
    _titleLabel.text = cellModel.ChineseCalendar;
    
}

- (UIImage *)nomalImage{
    if (!_nomalImage) {
        _nomalImage = nil;
    }
    return _nomalImage;
}

- (UIImage *)selectedImage{
    if (!_selectedImage) {
        _selectedImage = [UIImage imageNamed:@"selectCell"];
    }
    return _selectedImage;

}

- (UIImage *)todayImage{
    if (!_todayImage) {
        _todayImage = [UIImage imageNamed:@"todayCell"];
    }
    return _todayImage;
}

@end
