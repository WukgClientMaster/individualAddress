//
//  HTTPServerCacheManager.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/7/10.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPServerCacheManager : NSObject

+ (NSString *)getResourceCachePathByURL:(NSString *)url;
+ (BOOL)isResourceExistsWithURL:(NSURL *)url;
+ (BOOL)removeExistWithURL:(NSURL*)url;

@end
