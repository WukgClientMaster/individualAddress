//
//  APPUserSystemVM.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/16.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTP.h"

typedef void (^SuccessBlock)(NSString* msg,id response);
typedef void (^FailureBlock)(NSError*error);
typedef void (^ProgressBlock)(int64_t progress);

@interface APPUserSystemVM : NSObject
/*!
 *  用户注册
 */
+(void)userRegister:(NSDictionary*)agrs
            success:(SuccessBlock) success
            failure:(FailureBlock) failure
            progess:(ProgressBlock) progress;
/*!
 * 快速生成用户名
 */
+(void)quickCreateAccount:(NSDictionary*)args
                  success:(SuccessBlock) success
                  failure:(FailureBlock) failure
                  progess:(ProgressBlock) progress;
/*!
 * 用户登录（手机或用户名）
 */
+(void)userlogin:(NSDictionary*)agrs
         success:(SuccessBlock) success
         failure:(FailureBlock) failure
        progess:(ProgressBlock) progress;
/*!
 * 手机号码一键登录
 */
+(void)loginphone:(NSDictionary*)agrs
          success:(SuccessBlock) success
          failure:(FailureBlock) failure
          progess:(ProgressBlock) progress;
/*!
 * 自动登录
 */
+(void)autologin:(NSDictionary*)agrs
         success:(SuccessBlock) success
         failure:(FailureBlock) failure
         progess:(ProgressBlock) progress;
/*!
 * 获取充值记录
 */
+(void)fetchRecharge:(NSDictionary*)agrs
             success:(SuccessBlock) success
             failure:(FailureBlock) failure
             progess:(ProgressBlock) progress;
/*!
 * 发送重置密码验证码
 */
+(void)smsResetPassword:(NSDictionary*)agrs
                success:(SuccessBlock) success
                failure:(FailureBlock) failure
                progess:(ProgressBlock) progress;
/*!
 * 平台账号注册
 */
+(void)platformAuthRegister:(NSDictionary*)agrs
                    success:(SuccessBlock) success
                    failure:(FailureBlock) failure
                    progess:(ProgressBlock) progress;
/*!
 * 平台账号登录发短信
 */
+(void)platformAuthRegisterSendMsg:(NSDictionary*)agrs
                           success:(SuccessBlock) success
                           failure:(FailureBlock) failure
                           progess:(ProgressBlock) progress;
/*!
 * 平台账号登录
 */
+(void)platformAuthLogin:(NSDictionary*)agrs
                 success:(SuccessBlock) success
                 failure:(FailureBlock) failure
                 progess:(ProgressBlock) progress;
/*!
 * 获取短信一键登录token
 */
+(void)fetchSMSToken:(NSDictionary *)agrs
             success:(SuccessBlock)success
             failure:(FailureBlock)failure
             progess:(ProgressBlock)progress;
/*!
 * 重置账号密码
 */
+(void)resetPassword:(NSDictionary*)agrs
             success:(SuccessBlock)success
             failure:(FailureBlock)failure
             progess:(ProgressBlock)progress;
/*!
 * 用户信息-心跳
 */
+(void)accountMsgHeart:(NSDictionary*)agrs
               success:(SuccessBlock)success
               failure:(FailureBlock)failure
               progess:(ProgressBlock)progress;
/*!
 * 获取用户钱包信息
 */
+(void)userWalletMsgHeart:(NSDictionary*)agrs
               success:(SuccessBlock)success
               failure:(FailureBlock)failure
               progess:(ProgressBlock)progress;
/*!
 * 获取短信验证码
 */
+(void)mobileAuthCode:(NSDictionary*)agrs
              success:(SuccessBlock)success
              failure:(FailureBlock)failure
              progess:(ProgressBlock)progress;
/*!
 * 退出登录
 */
+(void)loginOut:(NSDictionary*)agrs
              success:(SuccessBlock)success
              failure:(FailureBlock)failure
              progess:(ProgressBlock)progress;


@end
