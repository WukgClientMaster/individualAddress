//
//  PredicateTool.m
//  SmartCity
//
//  Created by 吴可高 on 2018/1/19.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "PredicateTool.h"

@implementation PredicateTool
//验证字符串是否包含特殊字符
+(BOOL)verifyStringContainsAspectCharector:(NSString*)predicate{
    __block BOOL isEomji = NO;
    [predicate enumerateSubstringsInRange:NSMakeRange(0, predicate.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3 || ls == 0xfe0f) {
                isEomji = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
        }
    }];
    return isEomji;
}

+(NSString*)trimmingCharecterWithStringFormat:(NSString*)format{
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）￥「」＂、[]{}#%-*+=_\\|~＜＞$€^·'@#$%^&*()_+'""]"];
    NSString * string = [format stringByTrimmingCharactersInSet:set];
    return string;
}
//字符串只包含数字字中划线
+(BOOL)fetchContainWithStringFormat:(NSString*)format{
    NSUInteger len=format.length;
    for(int i=0;i<len;i++)
    {
        unichar a=[format characterAtIndex:i];
        if(!((isalpha(a))
             ||(isalnum(a))
             ||((a=='-'))
             ))
            return NO;
    }
    return YES;
}

//字符串只包含数字字母下划线中划线
+(BOOL)specifiCharecterContainWithStringFormat:(NSString*)format{
    NSUInteger len=format.length;
    for(int i=0;i<len;i++)
    {
        unichar a=[format characterAtIndex:i];
        if(!((isalpha(a))
             ||(isalnum(a))
             ||((a=='-'))
             ||((a >= 0x4e00 && a <= 0x9fa6))
             ))
            return NO;
    }
    return YES;
}
@end
