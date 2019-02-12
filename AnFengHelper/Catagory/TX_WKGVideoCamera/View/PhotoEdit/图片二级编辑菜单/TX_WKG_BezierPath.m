//
//  TX_WKG_BezierPath.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/21.
//  Copyright © 2018年 NRH. All rights reserved.


#import "TX_WKG_BezierPath.h"
#import <objc/runtime.h>
void * K_TX_WKG_BezierPath = &K_TX_WKG_BezierPath;

@implementation TX_WKG_BezierPath

-(UIColor *)color{
    return objc_getAssociatedObject(self, &K_TX_WKG_BezierPath);
}

-(void)setColor:(UIColor *)color{
    objc_setAssociatedObject(self, &K_TX_WKG_BezierPath, color, OBJC_ASSOCIATION_RETAIN);
}

@end
