//
//  APPSqliteManager.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/13.
//  Copyright © 2017年 AnFen. All rights reserved.

#import "APPSqliteManager.h"

@implementation APPSqliteManager
/*!
 *  项目中关于User信息表
 */
static NSDictionary * APPSqliteUserOption();
static NSDictionary * APPSqliteUserOption()
{
    return @{@(APPCacheTbaleNameCreate):@"",
             @(APPCacheTbaleNameDelete):@"",
             @(APPCacheTbaleNameInsert):@"",
             @(APPCacheTbaleNameUpdate):@"",
             @(APPCacheTbaleNameSelect):@""};
}

static NSDictionary * APPSqliteInfomationOption();
static NSDictionary * APPSqliteInfomationOption()
{
    return @{@(APPCacheTbaleNameCreate):@"",
             @(APPCacheTbaleNameDelete):@"",
             @(APPCacheTbaleNameInsert):@"",
             @(APPCacheTbaleNameUpdate):@"",
             @(APPCacheTbaleNameSelect):@""};
}

static NSDictionary * APPSqlitePushMsgOption();
static NSDictionary * APPSqlitePushMsgOption()
{
    return @{@(APPCacheTbaleNameCreate):@"",
             @(APPCacheTbaleNameDelete):@"",
             @(APPCacheTbaleNameInsert):@"",
             @(APPCacheTbaleNameUpdate):@"",
             @(APPCacheTbaleNameSelect):@""};
}

static NSString * APPUserAboutTable(APPCacheTbaleNameType type)
{
    NSDictionary * sqlDic = APPSqliteUserOption();
    return sqlDic[@(type)];
}
/*!
 *  项目中关于APPInfo信息表
 */
static NSString * APPInfomationAboutTable(APPCacheTbaleNameType type)
{
    NSDictionary * sqlDic = APPSqliteInfomationOption();
    return sqlDic[@(type)];}
/*!
 *  项目中关于推送(拉取)信息信息表
 */
static NSString * APPPushMsgTable(APPCacheTbaleNameType type)
{
    NSDictionary * sqlDic = APPSqlitePushMsgOption();
    return sqlDic[@(type)];
}
@end
