//
//  CalenderCell.h
//  Calender
//
//  Created by 杨森 on 16/6/20.
//  Copyright © 2016年 com.sitemap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalenderCellModel.h"
#define CELL_SCALE       (11.0/8)

@interface CalenderCell : UICollectionViewCell

@property (nonatomic) CalenderCellModel *cellModel;

@property (nonatomic)UIImage *selectedImage;  // 选中时显示的image
@property (nonatomic)UIImage *nomalImage;     // 正常状态下显示的image
@property (nonatomic)UIImage *todayImage;     // 今天显示的image
@property (assign, nonatomic, readonly)CGFloat scale;           // 高：宽

@end
