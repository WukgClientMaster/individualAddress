//
//  UIViewController+Transitioning.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/19.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger,ModalTranstioningType)
{
   kModalTranstioningTypeNone = 1000,
   kModalTranstioningTypePopUp,
   kModalTranstioningTypeNotification,
};

@interface UIViewController (Transitioning)

// Register / Unregister a custom transition
- (void)registerClass:(Class)transitionClass forTransitionType:(NSInteger)transitionType;

- (void)unregisterClassForTransitionType:(NSInteger)transitionType;

@end
