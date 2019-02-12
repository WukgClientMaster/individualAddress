//
//  RequestTaskManager.m
//  ada
//
//  Created by kaibin on 16/12/20.
//  Copyright © 2016年 yy. All rights reserved.
//

#import "RequestTaskManager.h"

@interface RequestTaskManager ()

@end

@implementation RequestTaskManager

+ (instancetype)sharedInstance
{
    static RequestTaskManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RequestTaskManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.taskDic = [YYThreadSafeDictionary dictionary];
    }
    return self;
}

- (NSURLSessionTask *)taskForURL:(NSURL *)url
{
    return [self.taskDic objectForKey:url];
}

- (void)setTask:(NSURLSessionTask *)task forURL:(NSURL *)url
{
    [self.taskDic setObject:task forKey:url];
}

-(void)cancleRequestTaskWith:(NSURL*)url{
    if (url == nil)return;
    NSURLSessionTask * requestTask =  [self.taskDic objectForKey:url];
    [requestTask cancel];
}

- (void)suspendAllTasks{
    if (self.taskDic ==nil)return;
    NSArray <NSURLSessionTask *>* tasks = [self.taskDic allValues];
    [tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
}

- (void)removeTaskForURL:(NSURL *)url{
    if ([self.taskDic objectForKey:url]) {
        [self.taskDic removeObjectForKey:url];
    }
}

@end
