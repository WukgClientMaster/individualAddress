//
//  NSString+Encryption.h
//  Learn_ObjectiveC
//
//  Created by 吴可高 on 16/3/21.
//  Copyright (c) 2016年 吴可高. All rights reserved.
//  字符串加密

#import <Foundation/Foundation.h>

@interface NSString (Encryption)
/**
 *  对字符串进行加密处理 （MD5）
 *  @param sourceString 源目标字符串
 *  @return 加密结果字符串(返回的大写的加密方式)
 */
#pragma mark -返回的大写的加密方式
+ (NSString*)MD5Encryption:(NSString*)sourceString;
/**
 *  对文字进行base64加密处理
 *  @param text
 *  @return
 */
+ (NSString *)base64StringFromText:(NSString *)text;

/**
 * 将base 64位格式化字符串 －>NSString
 *  @param base64
 *  @return
 */
+ (NSString *)textFromBase64String:(NSString *)base64;


@end
