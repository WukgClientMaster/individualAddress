//
//  NSUserDefaults+NSKeyedArchiver.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/3/29.
//  Copyright © 2016年 吴可高. All rights reserved.
#import "NSUserDefaults+NSKeyedArchiver.h"

@implementation NSUserDefaults (NSKeyedArchiver)

- (void)archiveAnyObject:(id)anyObject forKey:(NSString *)anyKey
{
    NSData *anObjectData = [NSKeyedArchiver archivedDataWithRootObject:anyObject];
    [[NSUserDefaults standardUserDefaults] setObject:anObjectData forKey:anyKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (instancetype)unarchiveAnyObjectForKey:(NSString *)anyKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *anObjectData = [defaults objectForKey:anyKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:anObjectData];
}
@end
