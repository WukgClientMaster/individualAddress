//
//  OOThread.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/9/20.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "OOThread.h"
#import <objc/runtime.h>

@interface OOThread ()
@property (strong, nonatomic,readwrite) id target;
@property (strong, nonatomic,readwrite)  NSThread * thread;

@end
static OOThread * _ooThread = nil;
@implementation OOThread

-(void)setTarget:(id)target
{
    NSAssert(target != nil, @"__target 不能为空");
    objc_setAssociatedObject(self, @selector(setTarget:), target, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)target
{
    return objc_getAssociatedObject(self, @selector(setTarget:));
}
+ (instancetype)shareInstance;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_ooThread) {
            _ooThread  =[[OOThread alloc]init];
        }
    });
    return _ooThread;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.thread =[[NSThread alloc]init];
    }
    return self;
}
// 加入多线程
+ (void)detachNewThreadSelector:(SEL)selector toTarget:(id)target withObject:(id)argument;
{
    [NSThread detachNewThreadSelector:selector toTarget:target withObject:argument];
}

+ (void)sleepForTimeInterval:(NSTimeInterval)timeInterval;
{
    [NSThread sleepForTimeInterval:timeInterval];
}

- (instancetype)initWithTarget:(id)target selector:(SEL)selector object:(id)argument;
{
    if ([super init]) {
        self.target = target;
        self.thread = [[NSThread alloc]initWithTarget:target selector:selector object:argument];
    }
    return self;
}

-(void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait;
{
    [self.target performSelectorOnMainThread:aSelector withObject:arg waitUntilDone:YES];
}
// 线程基本操作
- (void)cancelThread;
{
    [self.thread cancel];
}

- (void)startThread;
{
    [self.thread start];
}
@end
