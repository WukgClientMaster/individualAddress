//
//  AppCacheManager.h
//  TravelApp
//
//  Created by 吴可高 on 15/12/21.
//  Copyright (c) 2015年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppCacheManager : NSObject

@property(nonatomic,strong)NSFileManager *fileManager;
@property(nonatomic,strong)id responseObject;  // 任意对象接受将要缓存数据
/**
 *  单列模式
 *
 *  @return
 */
+(instancetype)shareInstance;
/**
 *  将我们  responseObject 从网络获取数据信息缓存在本的的写入方法
 *  @param filePath   写入路径
 *  @param automicity 写入是否是 原子性
    @return 表示responseObject 接受的对象写入数据是否成功
 */
-(void)wirteToFile:(NSString*)filePath  automicity:(BOOL)automicity;
/**
 *  从本地获取流文件：  NSData对象
 *  @param filePath  读取流文件的path
 *  @return 返回的是： 目标性NSData
 */
-(id)readDataToFileName:(NSString*)filePath;
/**
 *  @param filePath
 *  @param error
 *  @return
 */
-(BOOL)deleteCacheDataPath:(NSString*)filePath error:(NSError*)error;

@end
