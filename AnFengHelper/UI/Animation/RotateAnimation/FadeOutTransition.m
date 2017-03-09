//
//  FadeOutTransition.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/19.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "FadeOutTransition.h"
#import "FadeOutAnimationTransition.h"

@implementation FadeOutTransition
DEF_SINGLETON(FadeOutTransition)
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
{
    FadeOutAnimationTransition * fadeOutAnimation  = [[FadeOutAnimationTransition alloc]init];
    fadeOutAnimation.presenting = YES;
    return fadeOutAnimation;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;
{
    FadeOutAnimationTransition * fadeOutAnimation  = [[FadeOutAnimationTransition alloc]init];
    fadeOutAnimation.presenting = NO;
    return fadeOutAnimation;
}

@end
