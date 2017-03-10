//
//  UtilityCalendarTool.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/5/12.
//  Copyright © 2016年 吴可高. All rights reserved.

#import "UtilityCalendarTool.h"
#import "UtilityTool.h"

@implementation UtilityCalendarTool

+ (NSInteger)day:(NSDate *)date;
{
    NSDateComponents  * components  = [[NSCalendar currentCalendar]components:NSCalendarUnitDay fromDate:date];
    return components.day;
}

+ (NSInteger)month:(NSDate *)date;
{
    NSDateComponents  * components = [[NSCalendar currentCalendar]components:NSCalendarUnitMonth fromDate:date];
    return components.month;
}

+ (NSInteger)year:(NSDate *)date;
{
    NSDateComponents * components = [[NSCalendar currentCalendar]components:NSCalendarUnitYear fromDate:date];
    return components.year;
}

+ (NSInteger)totaldaysInMonth:(NSDate *)date;
{
    NSRange  dayRange = [[NSCalendar  currentCalendar]rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return dayRange.length;
}

//NSDate 第一天是周几
+ (NSInteger)weeklyOrdinality:(NSDate*)date;
{
    NSDate * firstDate = [self firstDay:date];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_0
    return [[NSCalendar currentCalendar]ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekday forDate:firstDate];
#else
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:firstDate];
#endif
}

//NSDate 一个月有多少周
+ (NSInteger)numberOfWeeks:(NSDate*)date;
{
    NSDate * firstDate = [self firstDay:date];
    NSInteger weekDay  = [self weeklyOrdinality:date];
    NSInteger days   = [self totaldaysInMonth:firstDate];
    NSUInteger weeks = 0;
    if (weekDay > 1) {
        weeks += 1, days -= (7 - weekDay + 1);
    }
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    return weeks;
}

+ (NSDate *)lastMonth:(NSDate *)date;
{
    NSDateComponents * dateComponents = [[NSDateComponents alloc]init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents toDate:date options:NSCalendarWrapComponents];
    return newDate;
}

+ (NSDate*)nextMonth:(NSDate *)date;
{
    NSDateComponents * dateComponents = [[NSDateComponents alloc]init];
    dateComponents.month = 1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

+(NSDate *)delay:(NSCalendarUnit)unit value:(NSInteger)value date:(NSDate *)date
{
    NSDate * newDate = [[NSCalendar currentCalendar]dateByAddingUnit:unit value:value toDate:date options:NSCalendarMatchStrictly];
    return newDate;
}

//NSDate一个月第一天时间
+ (NSDate*)firstDay:(NSDate*)date;
{
    NSDate *startDate = nil;
    BOOL result = [[NSCalendar currentCalendar]rangeOfUnit:NSCalendarUnitMonth startDate:&startDate interval:NULL forDate:date];
    NSAssert(result,@"Failed to calculate the first day of the month based on %@",date);
    return startDate;
}
//NSDate 一个月最后一天时间
+ (NSDate*)lastDay:(NSDate*)date;
{
    NSCalendarUnit calendarUnit =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:calendarUnit fromDate:date];
    dateComponents.day = [self totaldaysInMonth:date];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

+(NSDate*)dateFromString:(NSString *)dateStr formatStyle:(NSString*)format;
{
    dateStr = [dateStr stringByAppendingString:@"00"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSString * dateStringFormat = [UtilityTool matchingIsEmpity:format] ? @"yyyy-MM-dd":format;
    [dateFormat setDateFormat:dateStringFormat];
    return [dateFormat dateFromString:dateStr];
}

+(NSString*)stringFromDate:(NSDate *)date formatStyle:(NSString*)format;
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSString * dateStringFormat = [UtilityTool matchingIsEmpity:format] ? @"yyyy-MM-dd":format;
    [dateFormat setDateFormat:dateStringFormat];
    return [dateFormat stringFromDate:date];
}

// 时间格式转换
+ (NSDate*)dateComponents:(NSDateComponents*)components toDate:(NSDate *)date;
{
    NSCalendar * calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierChinese]    ;
    NSDate * componentsDate =  [calendar dateByAddingComponents:components toDate:date options:NSCalendarWrapComponents];
    return componentsDate;
}
// 二个时间比较
+(NSDateComponents*)components:(NSCalendarUnit)unitFlag fromDate:(NSDate *) startingDate toDate:(NSDate*)resultDate;
{
    NSCalendar * calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierChinese]    ;
    NSDateComponents * components = [calendar components:unitFlag fromDate:startingDate toDate:resultDate options:NSCalendarWrapComponents];
    return components;
}
@end
