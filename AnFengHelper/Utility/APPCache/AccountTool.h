//
//  AccountTool.h
//  Learn_ObjectiveC
//
//  Created by 吴可高 on 16/3/21.
//  Copyright (c) 2016年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APPUser;

@interface AccountTool : NSObject
/**
 *  在本地序列化 accountLoginModel
 *  @param accountModel
 */
+(void)archiveAccount:(APPUser*)accountModel;
/**
 *  @return load Archive Account Model
 */
+(APPUser*)unarchiveAccount;
/**
 *  在本地删除用户账号信息
 */
+(void)removeArchiveAccount;

@end
