//
//  AppCacheManager.m
//  TravelApp
//
//  Created by 吴可高 on 15/12/21.
//  Copyright (c) 2015年 吴可高. All rights reserved.
//

#import "AppCacheManager.h"
#import "NSString+Path.h"
#import "XMLDictionary.h"
#import "NSDictionary+NSData.h"
#import "NSUserDefaults+NSKeyedArchiver.h"

@implementation AppCacheManager

static AppCacheManager *appCacheManager = nil;
static dispatch_once_t once;

+(instancetype)shareInstance
{
    if (appCacheManager == nil)
    {
            dispatch_once(&once, ^{
                if(appCacheManager==nil)
                {
                    appCacheManager=[[AppCacheManager alloc] init];
                    appCacheManager.fileManager = [NSFileManager defaultManager];
                }
            });
    }
    return appCacheManager;
}
/**
 *  将我们从网络获取数据信息缓存在本的的写入方法
 *  @param filePath   写入路径
 *  @param automicity 写入是否是 原子性
 */
-(void)wirteToFile:(NSString*)filePath  automicity:(BOOL)automicity;
{
     NSString * fileWritePath = [NSString getDocumentsDirectoryPathForFile:filePath];
    if ([_responseObject isKindOfClass:[NSArray class]]
        || [_responseObject isKindOfClass:[NSString class]])
    {
        [[NSUserDefaults standardUserDefaults]archiveAnyObject:_responseObject forKey:filePath];
    }
    else
    {
       [self.responseObject  writeToFile:fileWritePath atomically:NO];
    }
}
/**
 *  从本地获取流文件： NSData对象
 *  @param filePath 读取流文件的path
 *  @return 返回的是： 目标性NSData
 */

-(id)readDataToFileName:(NSString*)filePath;
{
    if ([_responseObject isKindOfClass:[NSString class]]
        ||[_responseObject isKindOfClass:[NSArray class]]) {
        return [[NSUserDefaults standardUserDefaults]unarchiveAnyObjectForKey:filePath];
    }
    NSString *fileExistPath  =[NSString getDocumentsDirectoryPathForFile:filePath];
    NSData *resultData = [self.fileManager contentsAtPath:fileExistPath];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfData:resultData];
    return dictionary;
}
/**
 *  通过方法判断用户沙盒目录是否存在该文件目录
 *  @param filePath 目标性文件地址
 *  @return 是否真的存在  YES 存在  NO 不存在
 */
-(BOOL)fileExist:(NSString*)filePath;
{
    NSString *fileExistPath  = [NSString getDocumentsDirectoryPathForFile:filePath];
    return [self.fileManager fileExistsAtPath:fileExistPath];
}
/**
    在沙盒目录下 创建一个文件夹
 *  @param dictionaryPath  沙盒目录
 *  @param direction
 *  @param attributeDict
 *  @param error
 *  @return
 */

-(BOOL)createDirectoryAtPath:(NSString *)dictionaryPath attributes:(NSDictionary*)attributeDict error:(NSError**)error;
{
    NSString * primaryPath = [NSString getLibraryDirectoryPathForFile:dictionaryPath];
    NSArray *primaryArray = [self.fileManager contentsOfDirectoryAtPath:primaryPath error:error];
    __block BOOL isExistFile = NO;
    [primaryArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]])
        {
            NSString *filePath = (NSString*)obj;
            if ([primaryPath isEqualToString:filePath])
            {
                isExistFile = YES;
                *stop = YES;
            }
        }
    }];
    if (isExistFile)
    {
        return YES;
    }
    BOOL success = [self.fileManager  createDirectoryAtPath:primaryPath  withIntermediateDirectories:YES attributes:nil error:nil];
    return success;
}
/**
 在目标性的文件夹下面创建一个缓存的数据文件
 *  @param path
 *  @param data
 *  @param attr
 *  @return
 */
-(BOOL)createFileAtPath:(NSString *)path contents:(NSData *)data;
{
    NSString * filePath = [NSString getDocumentsDirectoryPathForFile:path];
    NSArray *filePathArray = [self.fileManager contentsOfDirectoryAtPath:filePath error:nil];
    __block BOOL isExistFile = NO;
    [filePathArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]])
        {
            NSString *path = (NSString*)obj;
            if ([filePath isEqualToString:path])
            {
                isExistFile = YES;
                *stop = YES;
            }
        }
    }];
    if (isExistFile)
    {
         return YES;
    }
    BOOL success =  [self.fileManager createFileAtPath:filePath contents:nil attributes:nil];
    return success;
}
/**
 *  移除一个存在沙盒目录下的
 *  @param filePath
 *  @param error
 *  @return
 */
-(BOOL)deleteCacheDataPath:(NSString*)filePath error:(NSError*)error;
{
    if ([_responseObject isKindOfClass:[NSString class]] || [_responseObject isKindOfClass:[NSArray class]])
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:filePath];
        return [[NSUserDefaults standardUserDefaults]synchronize];
    }
    NSString *outOfDateFilePath = [NSString getDocumentsDirectoryPathForFile:filePath];
    [self.fileManager removeItemAtPath:outOfDateFilePath error:&error];
    return [self.fileManager fileExistsAtPath:outOfDateFilePath];
}

@end
