//
//  CycleAnimation.m
//  smarket
//
//  Created by client on 2017/7/20.
//  Copyright © 2017年 原研三品. All rights reserved.
//

#import "CycleAnimation.h"

@interface CycleAnimation()
@property(nonatomic,strong)CALayer *spotLayer;
#define kJQBounceSpot2AnimationDuration 1.f

@end

@implementation CycleAnimation
- (void)configAnimationAtLayer:(CALayer *)layer withTintColor:(UIColor *)color size:(CGSize)size{
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake(0, 0, size.width, size.height);
    replicatorLayer.position = CGPointMake(0,0);
    replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
    [layer addSublayer:replicatorLayer];
    [self addCyclingSpotAnimationLayerAtLayer:replicatorLayer withTintColor:color size:size];
    NSInteger numOfDot = 3;
    replicatorLayer.instanceCount = numOfDot;
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(size.width/5.f, 0, 0);
    replicatorLayer.instanceDelay = kJQBounceSpot2AnimationDuration/numOfDot;
}

- (void)addCyclingSpotAnimationLayerAtLayer:(CALayer *)layer withTintColor:(UIColor *)color size:(CGSize)size{
    CGFloat radius = size.width/5;
    self.spotLayer = [CALayer layer];
    self.spotLayer.bounds   = CGRectMake(0, 0, radius, radius);
    self.spotLayer.position = CGPointMake(radius*3.f, radius*2.7);
    self.spotLayer.cornerRadius = radius/2;
    self.spotLayer.backgroundColor = color.CGColor;
    self.spotLayer.transform = CATransform3DMakeScale(0.2, 0.2, 0.2);
    [layer addSublayer:self.spotLayer];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @0.2;
    animation.toValue =  @0.8;
    animation.duration = kJQBounceSpot2AnimationDuration;
    animation.autoreverses = YES;
    animation.repeatCount = CGFLOAT_MAX;
    [self.spotLayer addAnimation:animation forKey:@"animation"];
}

- (void)removeAnimation{
    [self.spotLayer removeAnimationForKey:@"animation"];
}

@end
