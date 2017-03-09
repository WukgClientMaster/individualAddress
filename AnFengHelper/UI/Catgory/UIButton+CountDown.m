//
//  UIButton+CountDown.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/7.
//  Copyright © 2016年 吴可高. All rights reserved.

#import "UIButton+CountDown.h"
CountDownCompleteBlock _completeBlock;
NSInteger globalTimerInterval;
@implementation UIButton (CountDown)

-(void)obtainVeCodeOperationWithTimerInterval:(NSInteger)timeInterval complete:(CountDownCompleteBlock)block
{
    NSString *weakSelfTitle = self.currentTitle;
    __block  NSInteger  globalTimeInterval = timeInterval;
    _completeBlock = block;
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.f * NSEC_PER_SEC, 0.f * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (globalTimeInterval<=1) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:weakSelfTitle forState:UIControlStateNormal];
                self.enabled = YES;
                _completeBlock(self);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"%zds",globalTimeInterval];
                [self setTitle:str forState:UIControlStateNormal];
                 self.enabled = NO;
            });
        globalTimeInterval--;
        }
    });
    dispatch_resume(timer);
}

@end
