//
//  AccountTool.m
//  Learn_ObjectiveC
//
//  Created by 吴可高 on 16/3/21.
//  Copyright (c) 2016年 吴可高. All rights reserved.
#import "AccountTool.h"
#import "APPUser.h"

#define kArchiveAccountLoginModelPath [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingString:@"/accountLoginModel.dat"]

@implementation AccountTool

#pragma mark - 在本地序列化 accountLoginModel
+(void)archiveAccount:(APPUser*)accountModel;
{
    [NSKeyedArchiver archiveRootObject:accountModel toFile:kArchiveAccountLoginModelPath];
}
#pragma mark - load Archive Account Model
+(APPUser*)unarchiveAccount;
{
    APPUser *unarchiveModel  = [NSKeyedUnarchiver unarchiveObjectWithFile:kArchiveAccountLoginModelPath];
    return unarchiveModel;
}

#pragma mark - 本地删除用户账号信息
+(void)removeArchiveAccount;
{
    [NSKeyedArchiver archiveRootObject:[APPUser new] toFile:kArchiveAccountLoginModelPath];
}
@end
