//
//  YSWindow.m
//  Calender
//
//  Created by 杨森 on 16/6/24.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import "YSWindow.h"
#import "UIView+Frame.h"

@implementation YSWindow
{
    UIView *_currentView;
}
+ (UIWindow *)showView:(UIView *)view{

    YSWindow *window = [[YSWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.windowLevel = UIWindowLevelStatusBar + 1;
    [window showView:view];
    return window;
}

- (void)showView:(UIView *)view{
    _currentView = view;
    CGRect  viewFrame = view.frame;
    CGFloat screenH   = [UIScreen mainScreen].bounds.size.height;
    view.frame        = (CGRect){{view.x,screenH},{view.width,view.height}};
    self.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.6];
    [self addSubview:view];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.hidden=NO;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.frame = viewFrame;
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)hiddenWindow{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        __strong typeof(self)strongSelf = weakSelf;
        CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
        _currentView.frame = (CGRect){{_currentView.x,screenH},{_currentView.width,_currentView.height}};
        [strongSelf setNeedsLayout];
        [strongSelf layoutIfNeeded];
    }completion:^(BOOL finished) {
         __strong typeof(self)strongSelf = weakSelf;
        strongSelf.hidden = YES;
        if ([strongSelf.delegate respondsToSelector:@selector(windowDidDismissWithWindow:)]) {
            [strongSelf.delegate windowDidDismissWithWindow:self];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.delegate respondsToSelector:@selector(windowWillDismissWithWindow:)]) {
        [self.delegate windowWillDismissWithWindow:self];
    }
    [self hiddenWindow];
    
}

@end
