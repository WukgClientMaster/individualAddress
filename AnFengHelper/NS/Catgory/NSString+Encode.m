//
//  NSString+Encode.m
//  Learn_ObjectiveC
//
//  Created by 吴可高 on 16/3/21.
//  Copyright (c) 2016年 吴可高. All rights reserved.
//

#import "NSString+Encode.h"

@implementation NSString (Encode)

// unicode 编码字符串 -> utf8 string
+(NSString*)stringWithFromUnicodeString:(NSString*)unicodeString;
{
    NSString *tempStr1 = [unicodeString stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}
//utf string -> unicode 编码字符串
+(NSString*)uincodeWithFromUTF8String:(NSString*)utf8String;
{
    NSString * uniCodeString = [NSString stringWithCString:[utf8String UTF8String] encoding:NSUnicodeStringEncoding];
    return uniCodeString;
}

// utf8 string -> string
+(NSString*)utf8StringFromWithNSString:(NSString*)string;
{
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)string, NULL, NULL,  kCFStringEncodingUTF8 ));
    return encodedString;
    return [NSString stringWithCString:[string UTF8String] encoding:NSUTF8StringEncoding];
}

// 针对字符串乱码 NSString 过滤
+(NSString*)messyEncodeFromWithNSString:(NSString*)string
{
    return [NSString stringWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString*)stringWithFromChineseCharacter:(NSString*)chinese;
{
    NSMutableString * mutableString =  [NSMutableString stringWithString:chinese];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin,false);
    
    mutableString  = (NSMutableString*)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return mutableString;
}
@end
