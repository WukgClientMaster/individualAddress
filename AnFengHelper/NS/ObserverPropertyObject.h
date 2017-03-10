//
//  ObserverPropertyObject.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/3/31.
//  Copyright © 2016年 吴可高. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface ObserverPropertyObject : NSObject

@end

@interface NSObject(ObserverPropertyObject)

typedef void(^KVOObjectPropertyNewOldBlock)(id newValue ,id oldValue);

@property (strong,readonly, nonatomic) NSMutableDictionary * kvoDictionary;

- (void)observeWithObject:(id)sourceObject property:(NSString *)property;
- (void)observeWithObject:(id)sourceObject property:(NSString *)property block:(KVOObjectPropertyNewOldBlock)block;

- (void)removeObserverWithObject:(id)sourceObject property:(NSString *)property;
- (void)removeObserverWithObject:(id)sourceObject;
- (void)removeAllObserver;

@end
