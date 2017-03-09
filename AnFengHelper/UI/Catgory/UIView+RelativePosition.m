//
//  UIView+RelativePosition.m
//  Learn_ObjectiveC
//
//  Created by 吴可高 on 16/3/21.
//  Copyright (c) 2016年 吴可高. All rights reserved.
//

#import "UIView+RelativePosition.h"

@implementation UIView (RelativePosition)

// view attribte
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

// public methods
-(void)setPosition:(CGPoint)position andAnchorPoint:(CGPoint)anchorPoint;
{
    // frame.origin.x
    CGFloat x = position.x - anchorPoint.x * self.getWidth;
    CGFloat y = position.y - anchorPoint.y * self.getHeight;
    // frame.origin.y
    [self setOrigin:CGPointMake(x, y)];
}

-(void)setAnchorPoint:(CGPoint)anchorpoint forView:(UIView *)view;
{
    CGPoint position = CGPointMake(view.frame.origin.x, view.frame.origin.y);
    [self setPosition:position andAnchorPoint:anchorpoint];
}

-(CGFloat)getOriginX
{
  return  CGRectGetMinX(self.frame);
}

-(CGFloat)getOriginY
{
    return CGRectGetMinY(self.frame);
}
-(CGFloat)getHeight
{
    return CGRectGetHeight(self.frame);
}
-(CGFloat)getWidth
{
    return CGRectGetWidth(self.frame);
}


-(CGFloat)getBottom;
{
    return CGRectGetMaxY(self.frame);
}
-(CGFloat)getRightX;
{
    return CGRectGetMaxX(self.frame);
}
- (void)addSizeWidth:(CGFloat)newWidth {
    CGRect f = self.frame;
    f.size.width += newWidth;
    self.frame = f;
}

- (void)addSizeHeight:(CGFloat)newHeight {
    CGRect f = self.frame;
    f.size.height += newHeight;
    self.frame = f;
}

- (void)addOriginX:(CGFloat)newX {
    CGRect f = self.frame;
    f.origin.x += newX;
    self.frame = f;
}

- (void)addOriginY:(CGFloat)newY {
    CGRect f = self.frame;
    f.origin.y += newY;
    self.frame = f;
}
@end
