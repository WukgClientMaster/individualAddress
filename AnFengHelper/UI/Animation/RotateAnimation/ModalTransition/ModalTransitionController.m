//
//  ModalTransitionController.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/19.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "ModalTransitionController.h"
#import "ModalTransition.h"
@interface ModalTransitionController()
{
}
@property (nonatomic, strong) ModalTransition *currentTransition;

@end

@implementation ModalTransitionController

- (instancetype)initWithModalTransition:(ModalTransition *)modalTransition
{
    if (self = [super init])
    {
        self.currentTransition = modalTransition;
    }
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate methods
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.currentTransition;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.currentTransition;
}

@end
