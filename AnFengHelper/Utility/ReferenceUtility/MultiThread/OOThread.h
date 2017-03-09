//
//  OOThread.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/9/20.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OOThread : NSObject

@property (strong, nonatomic,readonly) id target;
@property (strong, nonatomic,readonly)  NSThread * thread;

+ (instancetype)shareInstance;
// 加入多线程
+ (void)detachNewThreadSelector:(SEL)selector toTarget:(id)target withObject:(id)argument;
- (instancetype)initWithTarget:(id)target selector:(SEL)selector object:(id)argument;
// 线程基本操作
+ (void)sleepForTimeInterval:(NSTimeInterval)timeInterval;
- (void)cancelThread;
- (void)startThread;

-(void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait;
@end
