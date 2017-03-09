//
//  AccountKeyChain.h
//  Learn_ObjectiveC
//
//  Created by 吴可高 on 16/3/21.
//  Copyright (c) 2016年 吴可高. All rights reserved.

#import <Foundation/Foundation.h>

extern  NSString * const kInfo_KeyChain;
extern  NSString * const kPwd_KeyChain;
extern  NSString * const kAccount_KeyChain;

@interface AccountKeyChain : NSObject

/**
 *  @param service
 *  @return
 */
+ (id)load:(NSString *)service ;
/**
 *
 *  @param service
 *  @param data
 */
+ (void)save:(NSString *)service data:(id)data;
/**
 *  @param service
 */
+ (void)deleteKeyChain:(NSString *)service;
@end
