//
//  PredicateTool.h
//  SmartCity
//
//  Created by 吴可高 on 2018/1/19.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PredicateTool : NSObject
+(BOOL)verifyStringContainsAspectCharector:(NSString*)predicate;
// 过滤特殊字符
+(NSString*)trimmingCharecterWithStringFormat:(NSString*)format;

//字符串只包含数字字母下划线中划线
+(BOOL)specifiCharecterContainWithStringFormat:(NSString*)format;

//字符串只包含数字字中划线
+(BOOL)fetchContainWithStringFormat:(NSString*)format;
@end

