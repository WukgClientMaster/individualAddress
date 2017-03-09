//
//  NSString+Time.m
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 8/17/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import "NSString+Time.h"
#import "NSArray+Query.h"

@implementation NSString (Time)
+ (NSString *)elapsedTimeInterval:(NSTimeInterval)time
{
    return [NSString stringWithFormat:@"%02li:%02li:%02li",
            lround(floor(time / 3600.)) % 100,
            lround(floor(time / 60.)) % 60,
            lround(floor(time)) % 60];
}

@end
