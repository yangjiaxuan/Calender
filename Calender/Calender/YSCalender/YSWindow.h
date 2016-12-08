//
//  YSWindow.h
//  Calender
//
//  Created by 杨森 on 16/6/24.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YSWindow;
@protocol YSWindowDelegete <NSObject>

- (void)windowWillDismissWithWindow:(YSWindow *)window;
- (void)windowDidDismissWithWindow:(YSWindow *)window;

@end
@interface YSWindow : UIWindow

@property (weak, nonatomic) id <YSWindowDelegete> delegate;

+ (YSWindow *)showView:(UIView *)view;
- (void)hiddenWindow;

@end
