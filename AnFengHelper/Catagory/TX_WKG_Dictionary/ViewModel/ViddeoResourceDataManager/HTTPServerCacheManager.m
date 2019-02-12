//
//  HTTPServerCacheManager.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/7/10.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "HTTPServerCacheManager.h"

@implementation HTTPServerCacheManager

- (BOOL)isFileExist:(NSString *)path{
    BOOL isDirectory;
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory;
}

+ (NSString *)getResourceCachePathByURL:(NSString *)url{
    NSString *subUrl = url.lastPathComponent;
    if (subUrl.length > 0) {
        NSString *directory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        directory = [directory stringByAppendingPathComponent:@"Resources"];
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if (![fileManager isExecutableFileAtPath:directory]) {
            [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *fileName = [subUrl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        fileName = [fileName stringByReplacingOccurrencesOfString:@"?" withString:@"_"];
        if (fileName.length > 0) {
            return [directory stringByAppendingPathComponent:fileName];
        }
    }
    return nil;
}

+ (BOOL)isResourceExistsWithURL:(NSURL *)url
{
    NSString *filePath = [self getResourceCachePathByURL:url.absoluteString];
    if (filePath != nil && [[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return YES;
    }
    return NO;
}
+(BOOL)removeExistWithURL:(NSURL*)url{
    BOOL remove = NO;
    NSString *filePath = [self getResourceCachePathByURL:url.absoluteString];
    if (filePath != nil) {
        remove = [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
    }
    return remove;
}
@end
