//
//  RequestTaskManager.h
//
//  Created by kaibin on 16/12/20.
//  Copyright © 2016年 yy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYThreadSafeDictionary.h"

@class NSURLSessionDataTask;

@interface RequestTaskManager : NSObject

@property (nonatomic, strong) YYThreadSafeDictionary *taskDic;

+ (instancetype)sharedInstance;

- (NSURLSessionTask *)taskForURL:(NSURL *)url;

- (void)setTask:(NSURLSessionTask *)task forURL:(NSURL *)url;

- (void)removeTaskForURL:(NSURL *)url;

- (void)suspendAllTasks;

-(void)cancleRequestTaskWith:(NSURL*)url;

@end
