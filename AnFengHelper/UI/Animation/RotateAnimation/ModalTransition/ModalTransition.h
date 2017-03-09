//
//  ModalTransition.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/19.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModalTransition : NSObject<UIViewControllerAnimatedTransitioning>

// Compute rotation angle to apply
+ (float)rotationAngle;

// Subclasses must implement these method to control presentation/dismiss
- (void)presentViewControllerWithContext:(id <UIViewControllerContextTransitioning>)transitionContext animated:(BOOL)animated;
- (void)dismissViewControllerWithContext:(id <UIViewControllerContextTransitioning>)transitionContext animated:(BOOL)animated;

// View controllers
@property (nonatomic, weak) UIViewController *presentingViewController;
@property (nonatomic, weak) UIViewController *presentedViewController;

@end
