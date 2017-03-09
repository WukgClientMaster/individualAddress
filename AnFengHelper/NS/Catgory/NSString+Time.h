//
//  NSString+Time.h
//  DZNCategories
//
//  Created by Ignacio Romero Zurbuchen on 8/17/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//  http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>

@interface NSString (Time)
// 过去时间
+ (NSString *)elapsedTimeInterval:(NSTimeInterval)time;

@end
