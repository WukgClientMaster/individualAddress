//
//  NSUserDefaults+NSKeyedArchiver.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/3/29.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (NSKeyedArchiver)

- (void)archiveAnyObject:(id)anyObject forKey:(NSString *)anyKey;

- (instancetype)unarchiveAnyObjectForKey:(NSString *)anyKey;

@end
