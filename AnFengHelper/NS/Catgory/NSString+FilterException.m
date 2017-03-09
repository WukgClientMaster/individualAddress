//
//  NSString+FilterException.m
//  Learn_ObjectiveC
//
//  Created by 吴可高 on 16/3/21.
//  Copyright (c) 2016年 吴可高. All rights reserved.
//

#import "NSString+FilterException.h"

@implementation NSString (FilterException)

-(NSString*)validate
{
    if ([self isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    if ([self isEqualToString:@""]) {
         return @"";
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
    {
        return @"";
    }
    return self;
}
//判断字符串是否为空
-(BOOL)matchingIsEmpty
{
    return [self validate].length == 0 ? YES : NO;
}
@end
