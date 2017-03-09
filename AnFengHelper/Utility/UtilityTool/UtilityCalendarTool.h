//
//  UtilityCalendarTool.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/5/12.
//  Copyright © 2016年 吴可高. All rights reserved.
// **NSCaledar-  weekday规则：
/*
@｛  @"1":@"星期天"
    ,@"2":@"星期一"
    ,@"3":@"星期二"
    ,@"4":@"星期三"
    ,@"5":@"星期四"
    ,@"6":@"星期五"
    ,@"7":@"星期六"
  ｝
*/

#import <Foundation/Foundation.h>

@interface UtilityCalendarTool : NSObject

+ (NSInteger)day:(NSDate *)date;
+ (NSInteger)month:(NSDate *)date;
+ (NSInteger)year:(NSDate *)date;
//NSDate 一个月有多少周
+ (NSInteger)numberOfWeeks:(NSDate*)date;
+ (NSInteger)totaldaysInMonth:(NSDate *)date;
//每一个月第一天是周几
+ (NSInteger)weeklyOrdinality:(NSDate*)date;

+ (NSDate *)lastMonth:(NSDate *)date;
+ (NSDate*)nextMonth:(NSDate *)date;
+ (NSDate*)delay:(NSCalendarUnit)unit value:(NSInteger)value date:(NSDate*)date;
//NSDate 一个月第一天时间
+ (NSDate*)firstDay:(NSDate*)date;
//NSDate 一个月最后一天时间
+ (NSDate*)lastDay:(NSDate*)date;


+ (NSDate*)dateFromString:(NSString *)dateStr formatStyle:(NSString*)format;
+ (NSString*)stringFromDate:(NSDate *)date formatStyle:(NSString*)format;

@end
