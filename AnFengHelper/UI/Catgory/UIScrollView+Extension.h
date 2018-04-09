//
//  UIScrollView+Extension.h
//  IpaDebug
//
//  Created by anfeng on 17/4/12.
//  Copyright (c) 2017年 AnFen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Extension)
@property(nonatomic,assign) CGFloat inset_top;
@property(nonatomic,assign) CGFloat inset_bottom;
@property(nonatomic,assign) CGFloat inset_left;
@property(nonatomic,assign) CGFloat inset_right;

@property(nonatomic,assign) CGFloat offset_x;
@property(nonatomic,assign) CGFloat offset_y;

@property(nonatomic,assign) CGFloat contentsize_width;
@property(nonatomic,assign) CGFloat contentsize_height;

@end
