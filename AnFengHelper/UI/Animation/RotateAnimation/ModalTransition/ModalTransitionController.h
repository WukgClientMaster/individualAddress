//
//  ModalTransitionController.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/19.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ModalTransition;

@interface ModalTransitionController : NSObject <UIViewControllerTransitioningDelegate>

// Constructor
- (instancetype)initWithModalTransition:(ModalTransition *)modalTransition;

// Real-only properties
@property (nonatomic, strong, readonly) ModalTransition *currentTransition;
@end
