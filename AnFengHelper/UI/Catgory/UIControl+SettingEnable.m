//
//  UIControl+SettingEnable.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/5/6.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "UIControl+SettingEnable.h"

CAShapeLayer * _controlShapeLayer;

@implementation UIControl (SettingEnable)

-(void)setEligible:(BOOL)enabled;
{
    self.enabled = YES;
    self.backgroundColor = [self backgroundColor];
    [[self.layer sublayers]enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj isKindOfClass:[CAShapeLayer class]])
        {
            [obj removeFromSuperlayer];
            * stop = YES;
        }
    }];
}

-(void)setUnEnabled:(BOOL)unEnabled
{
    self.enabled  = NO;
    self.highlighted  = NO;
    _controlShapeLayer = [CAShapeLayer layer];
    _controlShapeLayer.opacity   = .7f;
    _controlShapeLayer.frame  = self.bounds;
    _controlShapeLayer.backgroundColor = UIColorFromRGB(0xE6E6E6).CGColor;
    [self.layer addSublayer:_controlShapeLayer];
}

@end
