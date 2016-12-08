//
//  CalenderHeaderView.m
//  Calender
//
//  Created by 杨森 on 16/6/20.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import "CalenderHeaderView.h"
#import "UIView+Frame.h"

@implementation CalenderHeaderView
{
    UIView   *_yearMonthView;
    UIButton *_lastMonthBtn;
    UIButton *_nextMonthBtn;
    UILabel  *_titleLabel;
    
    UILongPressGestureRecognizer *_titleLongPressG;
    UITapGestureRecognizer       *_titleTapG;
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{

    _yearMonthView = [[UIView alloc]initWithFrame:(CGRect){{0,self.height/5},{self.width,self.height*2/5}}];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:_yearMonthView];
    
    CGFloat perYearMonthWidth = _yearMonthView.width/19;
    _titleLabel = [[UILabel alloc]initWithFrame:(CGRect){{perYearMonthWidth*5,0},{perYearMonthWidth*9,_yearMonthView.height}}];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor     = [UIColor blackColor];
    _titleLongPressG = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(titleLongPress:)];
    _titleTapG       = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTapAction)];
    [_titleLabel addGestureRecognizer:_titleLongPressG];
    [_titleLabel addGestureRecognizer:_titleTapG];
    _titleLabel.userInteractionEnabled = YES;
    [_yearMonthView addSubview:_titleLabel];
    
    NSArray *selMonBtnTitles   = @[@"上一月",@"下一月"];
    NSMutableArray *selMonBtns = [NSMutableArray array];
    for (NSInteger i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = (CGRect){{perYearMonthWidth*(i?15:1)},{perYearMonthWidth*3,_yearMonthView.height}};
        [btn setTitle:selMonBtnTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(monthBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
        [selMonBtns addObject:btn];
        [_yearMonthView addSubview:btn];
    }
    _lastMonthBtn = selMonBtns.firstObject;
    _nextMonthBtn = selMonBtns.lastObject;
    
    UIView *dayView = [[UIView alloc]initWithFrame:(CGRect){{0,self.height*3/5},{self.width,self.height*2/5}}];
    [self addSubview:dayView];
    NSArray *dayArr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    CGFloat dayPerWidth = dayView.width/7;
    for (NSInteger day = 0; day < dayArr.count; day++) {
        UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){{dayPerWidth*day,0},{dayPerWidth,dayView.height}}];
        label.text = dayArr[day];
        label.textAlignment = NSTextAlignmentCenter;
        if (day==0||day==6) {
            label.textColor = [UIColor redColor];
        }
        else{
            label.textColor = [UIColor blackColor];
        }
        [dayView addSubview:label];
    }
    self.headerStyle = CalenderViewStyleNomal;

}

- (void)setHeaderStyle:(CalenderViewStyle)headerStyle{
    _headerStyle = headerStyle;
    if (_headerStyle == CalenderViewStyleNomal) {
        _lastMonthBtn.hidden     = YES;
        _nextMonthBtn.hidden     = YES;
    }
    else if (_headerStyle == CalenderViewStyleSelectDate){
        _lastMonthBtn.hidden     = NO;
        _nextMonthBtn.hidden     = NO;
    }
}

- (void)monthBtnClick:(UIButton *)sender{

    if (sender.tag == 100) {
        if ([self.delegate respondsToSelector:@selector(calenderHeaderViewDidClickLastMonthBtn:)]) {
            [self.delegate calenderHeaderViewDidClickLastMonthBtn:self];
        }
        if (self.lastMonthBtnClickBlock) {
            self.lastMonthBtnClickBlock(self);
        }
    }
    else if (sender.tag == 101){
        if ([self.delegate respondsToSelector:@selector(calenderHeaderViewDidClickNextMonthBtn:)]) {
            [self.delegate calenderHeaderViewDidClickNextMonthBtn:self];
        }
        if (self.nextMonthBtnClickBlock) {
            self.nextMonthBtnClickBlock(self);
        }
    }

}

- (void)titleLongPress:(UILongPressGestureRecognizer *)sender{
        
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        if ([self.delegate respondsToSelector:@selector(calenderHeaderView:didLongPressTitle:)]) {
            [self.delegate calenderHeaderView:self didLongPressTitle:_titleLabel.text];
        }
        if (self.titleLongPressBlock) {
            self.titleLongPressBlock(self, _titleLabel.text);
        }
    }
    
}

- (void)titleTapAction{

    if ([self.delegate respondsToSelector:@selector(calenderHeaderView:didTapTitle:)]) {
        [self.delegate calenderHeaderView:self didTapTitle:_titleLabel.text];
    }
    if (self.titleTapBlock) {
        self.titleTapBlock(self, _titleLabel.text);
    }

}

- (void)setModel:(CalenderCellModel *)model{
    _model = model;
    _titleLabel.text = [NSString stringWithFormat:@"%lu年%lu月",model.year,model.month];
    _titleLabel.font = [UIFont systemFontOfSize:floor(self.height*1/4)];
}

@end
