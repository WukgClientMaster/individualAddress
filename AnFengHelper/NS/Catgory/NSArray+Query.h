//
//  NSArray+Query.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/3/29.
//  Copyright © 2016年 吴可高. All rights reserved.
//  数据信息倒序存放

#import <Foundation/Foundation.h>

@interface NSArray (Query)

- (NSUInteger)lastObjectIndex;
//将数组的对象倒序存放
- (NSArray *)reversedSourceArray;
@end
