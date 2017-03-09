//
//  UnderLineLabel.m
//  TravelApp
//
//  Created by 吴可高 on 15/12/9.
//  Copyright (c) 2015年 吴可高. All rights reserved.
//

#import "UnderLineLabel.h"

@implementation UnderLineLabel
-(void)drawRect:(CGRect)rect
{
    // 调用super的目的，保留之前绘制的文字
    [super drawRect:rect];
    // 画线
    /*
     CGFloat x = 0;
     CGFloat y = rect.size.height * 0.5;
     CGFloat w = rect.size.width;
     CGFloat h = 1;
     UIRectFill(CGRectMake(x, y, w, h));
     */
    [self drawLine:rect];
}

- (void)drawLine:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 1.起点
    CGFloat startX = 0;
    CGFloat startY = rect.size.height * 0.8;
    CGContextMoveToPoint(ctx, startX, startY);
    // 2.终点
    CGFloat endX = rect.size.width -startX*2.0f;
    CGFloat endY = startY;
    CGContextAddLineToPoint(ctx, endX, endY);
    // 3.绘图渲染
    [self.textColor set];
    CGContextStrokePath(ctx);
}

@end
