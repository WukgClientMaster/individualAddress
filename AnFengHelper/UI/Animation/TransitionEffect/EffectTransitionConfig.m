//
//  EffectTransitionConfig.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/20.
//  Copyright © 2016年 吴可高. All rights reserved.
//
static const CGFloat kAnimationDuration = 1.0f;
#import "EffectTransitionConfig.h"

static EffectTransitionConfig * effectTransitionConfig = nil;
static dispatch_once_t once;

@implementation EffectTransitionConfig

+(instancetype)shareInstance
{
    @synchronized(self) {
            dispatch_once(&once, ^{
                effectTransitionConfig = [[EffectTransitionConfig alloc]init];
            });
    }
    return effectTransitionConfig;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configDefault];
    }
    return self;
}

-(void)configDefault
{
    _animationDuration  = kAnimationDuration;
    _effectTransitionType    = kEffectTypeTransition;
    _transitionSubTypeMode   = kCATransitionModelPush;
    _transitionType     =  kTransitionSuckEffect;
}

#pragma mark CATransition Animation
-(void)setAnimationDuration:(NSTimeInterval)animationDuration
{
    _animationDuration  = animationDuration;
}

-(void)setEffectTransitionType:(EffectTransitionType)effectTransitionType
{
    _effectTransitionType = effectTransitionType;
}

-(void)setTransitionSubTypeMode:(CATransitionMode)transitionSubTypeMode
{
    _transitionSubTypeMode  = transitionSubTypeMode;
}

-(void)setTransitionType:(TransitionTypeMode)transitionType
{
    _transitionType   = transitionType;
}
#pragma mark  Otner Animayion
@end
