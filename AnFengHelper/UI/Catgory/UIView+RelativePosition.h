//
//  UIView+RelativePosition.h
//  Learn_ObjectiveC
//
//  Created by 吴可高 on 16/3/21.
//  Copyright (c) 2016年 吴可高. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RelativePosition)
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize  size;
@property (assign, nonatomic) CGPoint origin;

-(CGFloat)getOriginX;
-(CGFloat)getOriginY;

-(CGFloat)getWidth;
-(CGFloat)getHeight;
-(CGFloat)getBottom;
-(CGFloat)getRightX;



- (void)addSizeWidth:(CGFloat)newWidth;
- (void)addSizeHeight:(CGFloat)newHeight;

- (void)addOriginX:(CGFloat)newX;
- (void)addOriginY:(CGFloat)newY;

-(void)setPosition:(CGPoint)position andAnchorPoint:(CGPoint)anchorPoint;

-(void)setOrigin:(CGPoint)originPoint;

-(void)setAnchorPoint:(CGPoint)anchorpoint forView:(UIView *)view;
@end
