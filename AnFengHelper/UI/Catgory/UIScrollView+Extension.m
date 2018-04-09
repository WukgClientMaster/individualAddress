//
//  UIScrollView+Extension.m
//  IpaDebug
//
//  Created by anfeng on 17/4/12.
//  Copyright (c) 2017年 AnFen. All rights reserved.
//

#import "UIScrollView+Extension.h"

@implementation UIScrollView (Extension)
#pragma make - setter method
-(void)setInset_top:(CGFloat)inset_top
{
    UIEdgeInsets edgeinset = self.contentInset;
    edgeinset.top = inset_top;
    self.contentInset = edgeinset;
}

-(void)setInset_bottom:(CGFloat)inset_bottom
{
    UIEdgeInsets edgeinsets = self.contentInset;
    edgeinsets.bottom = inset_bottom;
    self.contentInset = edgeinsets;
}

-(void)setInset_left:(CGFloat)inset_left
{
    UIEdgeInsets edgeinset = self.contentInset;
    edgeinset.left = inset_left;
    self.contentInset = edgeinset;
}

-(void)setInset_right:(CGFloat)inset_right
{
    UIEdgeInsets edgeinset = self.contentInset;
    edgeinset.right = inset_right;
    self.contentInset = edgeinset;
}

-(void)setOffset_x:(CGFloat)offset_x
{
    CGPoint offset = self.contentOffset;
    offset.x = offset_x;
    self.contentOffset =  offset;
}

-(void)setOffset_y:(CGFloat)offset_y
{
    CGPoint offset = self.contentOffset;
    offset.y = offset_y;
    self.contentOffset = offset;
}

-(void)setContentsize_width:(CGFloat)contentsize_width
{
    CGSize contentsize = self.contentSize;
    contentsize.width = contentsize_width;
    self.contentSize = contentsize;
}

-(void)setContentsize_height:(CGFloat)contentsize_height
{
    CGSize contentsize = self.contentSize;
    contentsize.height = contentsize_height;
    self.contentSize = contentsize;
}
#pragma mark - getter

-(CGFloat)inset_top
{
    return self.contentInset.top;
}

-(CGFloat)inset_bottom
{
    return self.contentInset.bottom;
}

-(CGFloat)inset_left
{
    return self.contentInset.left;
}

-(CGFloat)inset_right
{
    return self.contentInset.right;
}

-(CGFloat)offset_x
{
    return self.contentOffset.x;
}

-(CGFloat)offset_y
{
    return self.contentOffset.y;
}

-(CGFloat)contentsize_width
{
    return self.contentSize.width;
}

-(CGFloat)contentsize_height
{
    return self.contentSize.height;
}

@end
