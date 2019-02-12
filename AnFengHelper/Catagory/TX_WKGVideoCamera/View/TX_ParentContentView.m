//
//  TX_ParentContentView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/27.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_ParentContentView.h"

@implementation TX_ParentContentView

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView * view = [super hitTest:point withEvent:event];
    UITouch * touch = [event.allTouches anyObject];
    UIView  * touchView = touch.view;
    NSLog(@"touchView.class = %@ \n",NSStringFromClass([touchView class]));
    return view;
}

@end
