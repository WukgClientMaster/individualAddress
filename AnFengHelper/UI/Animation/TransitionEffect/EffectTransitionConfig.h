//
//  EffectTransitionConfig.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/20.
//  Copyright © 2016年 吴可高. All rights reserved.

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger,EffectTransitionType)
{
    kEffectTypeTransition,// CATransition转场动画
    kEffectTypeCoreAnimation,// CoreAnimation动画
    kEffectTypeCoreGraphics,//  CoreGraphics动画
};

#pragma mark  CATransitionModel SubType
typedef NS_OPTIONS(NSInteger,CATransitionMode)
{
    kCATransitionModelFade = 0,
    kCATransitionModelMoveIn,
    kCATransitionModelPush,
    kCATransitionModelReveal,
    kCATransitionModelFromRight,
    kCATransitionModelFromLeft,
    kCATransitionModelFromTop,
    kCATransitionModelFromBottom,
};
#pragma mark CATransition Type
typedef NS_OPTIONS(NSInteger, TransitionTypeMode)
{
    kTransitionPageCurl,
    kTransitionPageUnCurl,
    kTransitionRippleEffect,
    kTransitionSuckEffect,
    kTransitionCube,
    kTransitionOglFlip,
};

@interface EffectTransitionConfig : NSObject
//动画执行时间
@property (assign, nonatomic) NSTimeInterval animationDuration;
//动画类型 @[CATransition转场动画,CoreAnimation动画,CoreGraphics动画]
@property (assign, nonatomic) EffectTransitionType effectTransitionType;
#pragma mark - CATransition  Animation
//动画旋转subType（只针对 CATransition Animation）
@property (assign, nonatomic) CATransitionMode transitionSubTypeMode;
//动画旋转Type（只针对 CATransition Animation）
@property (assign, nonatomic) TransitionTypeMode transitionType;
#pragma mark - ----------

+(instancetype)shareInstance;

@end
