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
    return @{@(APPCacheTbaleNameCreate):@"CREAT TABLE 'User'('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'name' VARCHAR(30),'password' VARCHAR(30))",
             @(APPCacheTbaleNameDelete):@"delete from User",
             @(APPCacheTbaleNameInsert):@"insert into User (name, password) values(?, ?)",
             @(APPCacheTbaleNameUpdate):@"UPDATE User SET name = 'name_user',password ='password' WHERE id = 1",
             @(APPCacheTbaleNameSelect):@"select * from User"};
}

static NSDictionary * APPSqliteInfomationOption();
static NSDictionary * APPSqliteInfomationOption()
{
    return @{@(APPCacheTbaleNameCreate):@"CREAT TABLE 'appinfo'('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'appid' VARCHAR(100),'app_content' VARCHAR((100))",
             @(APPCacheTbaleNameDelete):@"",
             @(APPCacheTbaleNameInsert):@"",
             @(APPCacheTbaleNameUpdate):@"",
             @(APPCacheTbaleNameSelect):@""};
}

static NSDictionary * APPSqlitePushMsgOption();
static NSDictionary * APPSqlitePushMsgOption()
{
    return @{@(APPCacheTbaleNameCreate):@"CREAT TABLE 'user_msg'('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'msg_title' VARCHAR(100),'msg_content' VARCHAR((100))",
             @(APPCacheTbaleNameDelete):@"",
             @(APPCacheTbaleNameInsert):@"",
             @(APPCacheTbaleNameUpdate):@"",
             @(APPCacheTbaleNameSelect):@""};
}

NSString * APPUserAboutTable(APPCacheTbaleNameType type)
{
    NSDictionary * sqlDic = APPSqliteUserOption();
    return sqlDic[@(type)];
}
/*!
 *  项目中关于APPInfo信息表
 */
NSString * APPInfomationAboutTable(APPCacheTbaleNameType type)
{
    NSDictionary * sqlDic = APPSqliteInfomationOption();
    return sqlDic[@(type)];
}
/*!
 *  项目中关于推送(拉取)信息信息表
 */
NSString * APPPushMsgTable(APPCacheTbaleNameType type)
{
    NSDictionary * sqlDic = APPSqlitePushMsgOption();
    return sqlDic[@(type)];
}
@end
