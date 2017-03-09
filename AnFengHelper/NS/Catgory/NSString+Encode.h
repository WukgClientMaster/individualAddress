//
//  NSString+Encode.h
//  Learn_ObjectiveC
//
//  Created by 吴可高 on 16/3/21.
//  Copyright (c) 2016年 吴可高. All rights reserved.
//  字符串编码

#import <Foundation/Foundation.h>

@interface NSString (Encode)
/**
 *  unicode 编码字符串 -> utf8 string
 *  @param NSString uicode String
 *  @return
 */
 +(NSString*)stringWithFromUnicodeString:(NSString*)unicodeString;
/**
 *  utf string -> unicode 编码字符串
 *  @param NSString
 *  @return
 */
+(NSString*)uincodeWithFromUTF8String:(NSString*)utf8String;
/**
 *  NSString - > utf8 string
 *  @param NSString
 *  @return
 */
//
+(NSString*)utf8StringFromWithNSString:(NSString*)string;

/**
 *  针对字符串乱码 NSString 过滤
 *  @param NSString
 *  @return
 */
+(NSString*)messyEncodeFromWithNSString:(NSString*)string;

/**
 *  汉字转拼音
 *  @param chinese
 *  @return
 */
+ (NSString*)stringWithFromChineseCharacter:(NSString*)chinese;

@end
