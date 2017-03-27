//
//  APPSqliteManager.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/13.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "OOBaseObject.h"
/*!
 * <1>,安峰助手APP数据库执行sql语句
 * <2>,以静态内联函数进行一个返回操作
 *
 */
typedef NS_ENUM(NSInteger,APPCacheTbaleNameType){
    APPCacheTbaleNameCreate,
    APPCacheTbaleNameDelete,
    APPCacheTbaleNameSelect,
    APPCacheTbaleNameInsert,
    APPCacheTbaleNameUpdate,
};

@interface APPSqliteManager : NSObject
/*!
 *  项目中关于User信息表
 */
NSString * APPUserAboutTable(APPCacheTbaleNameType type);
/*!
 *  项目中关于APPInfo信息表
 */
NSString * APPInfomationAboutTable(APPCacheTbaleNameType type);
/*!
 *  项目中关于推送(拉取)信息信息表
 */
NSString * APPPushMsgTable(APPCacheTbaleNameType type);

@end
