//
//  CAEffectTransition.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/19.
//  Copyright © 2016年 吴可高. All rights reserved.
//
#import "CAEffectTransition.h"
#import "EffectTransitionConfig.h"

@implementation CAEffectTransition

+(CATransition*) effectTransitionConfig:(EffectTransitionConfig* )effectConfig;
{
    CATransition  * transition  = [CATransition animation];
    switch (effectConfig.transitionSubTypeMode) {
        case kCATransitionModelFade:
            transition.subtype  = kCATransitionFade;
            break;
        case kCATransitionModelMoveIn:
            transition.subtype  = kCATransitionMoveIn;
            break;
        case kCATransitionModelPush:
            transition.subtype  = kCATransitionPush;
            break;
        case kCATransitionModelReveal:
            transition.subtype  = kCATransitionReveal;
            break;
        case kCATransitionModelFromRight:
            transition.subtype  = kCATransitionFromRight;
            break;
        case kCATransitionModelFromLeft:
            transition.subtype  = kCATransitionFromLeft;
            break;
        case kCATransitionModelFromTop:
            transition.subtype  = kCATransitionFromTop;
            break;
        case kCATransitionModelFromBottom:
            transition.subtype  = kCATransitionFromBottom;
            break;
        default:
            break;
    }
    //
    switch (effectConfig.transitionType)
    {
        case kTransitionPageCurl:
            transition.type  = @"pageCurl";
            break;
        case kTransitionPageUnCurl:
            transition.type  = @"pageUnCurl";
            break;
        case kTransitionRippleEffect:
            transition.type  = @"rippleEffect";
            break;
        case kTransitionSuckEffect:
            transition.type  = @"suckEffect";
            break;
        case kTransitionCube:
            transition.type  = @"cube";
            break;
        case kTransitionOglFlip:
            transition.type  = @"oglFlip";
            break;
        default:
            break;
    }
    transition.duration  =  effectConfig.animationDuration;
    return transition;
}

@end
