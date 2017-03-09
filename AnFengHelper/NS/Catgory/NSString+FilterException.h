//
//  NSString+FilterException.h
//  Learn_ObjectiveC
//
//  Created by 吴可高 on 16/3/21.
//  Copyright (c) 2016年 吴可高. All rights reserved.
//  字符串异常情况做出处理
#import <Foundation/Foundation.h>
@interface NSString (FilterException)

#pragma mark NSStringn 判断是不完全的,会存在一个问题（当目标对比字符串本身就是nil时,无法执行FilterException的任何方法）
//返回一个有效字符串对象
-(NSString*)validate;
//判断字符串是否为空
-(BOOL)matchingIsEmpty;

@end
