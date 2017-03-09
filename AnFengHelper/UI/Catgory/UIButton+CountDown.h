//
//  UIButton+CountDown.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/7.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CountDownCompleteBlock)(UIButton*parameter);

@interface UIButton (CountDown)

/**
 *  根据timerInterval时间做倒计时处理
 *  @param timeInterval：倒计时时间数
 *  @param block：倒计时完成之后 代理返回的数据
 */
-(void)obtainVeCodeOperationWithTimerInterval:(NSInteger)timeInterval complete:(CountDownCompleteBlock)block;

@end
