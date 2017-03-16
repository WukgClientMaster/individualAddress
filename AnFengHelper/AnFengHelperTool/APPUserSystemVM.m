//
//  APPUserSystemVM.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/16.
//  Copyright © 2017年 AnFen. All rights reserved.
//
#import "APPUserSystemVM.h"

@implementation APPUserSystemVM
/*!
 *  用户注册
 */
+(void)userRegister:(NSDictionary*)agrs
            success:(SuccessBlock) success
            failure:(FailureBlock) failure
            progess:(ProgressBlock) progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_ACCOUNT_REGISTER params:agrs success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 * 快速生成用户名
 */
+(void)quickCreateAccount:(NSDictionary*)args
                  success:(SuccessBlock) success
                  failure:(FailureBlock) failure
                  progess:(ProgressBlock) progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_QUICK_CREATE_ACCOUNT params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 * 用户登录（手机或用户名）
 */
+(void)userlogin:(NSDictionary*)args
         success:(SuccessBlock) success
         failure:(FailureBlock) failure
         progess:(ProgressBlock) progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_ACCOUNT_LOGIN params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 * 手机号码一键登录
 */
+(void)loginphone:(NSDictionary*)args
          success:(SuccessBlock) success
          failure:(FailureBlock) failure
          progess:(ProgressBlock) progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_LOGIN_PHONE params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 * 自动登录
 */
+(void)autologin:(NSDictionary*)args
         success:(SuccessBlock) success
         failure:(FailureBlock) failure
         progess:(ProgressBlock) progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_AUTO_LOGIN params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}

/*!
 * 获取充值记录
 */
+(void)fetchRecharge:(NSDictionary*)args
             success:(SuccessBlock) success
             failure:(FailureBlock) failure
             progess:(ProgressBlock) progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_FETCH_CHARGE params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];

}
/*!
 * 发送重置密码验证码
 */
+(void)smsResetPassword:(NSDictionary*)args
                success:(SuccessBlock) success
                failure:(FailureBlock) failure
                progess:(ProgressBlock) progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_SMS_RESET_PASSWORD params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 * 平台账号注册
 */
+(void)platformAuthRegister:(NSDictionary*)args
                    success:(SuccessBlock) success
                    failure:(FailureBlock) failure
                    progess:(ProgressBlock) progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_PLATFORM_AUTH_REGISTER params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 * 平台账号登录发短信
 */
+(void)platformAuthRegisterSendMsg:(NSDictionary*)args
                           success:(SuccessBlock) success
                           failure:(FailureBlock) failure
                           progess:(ProgressBlock) progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_PLATFORM_AUTH_REGISTER_SEND_MSG params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 * 平台账号登录
 */
+(void)platformAuthLogin:(NSDictionary*)args
                 success:(SuccessBlock) success
                 failure:(FailureBlock) failure
                 progess:(ProgressBlock) progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_PLATFORM_AUTH_LOGIN params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 * 获取短信一键登录token
 */
+(void)fetchSMSToken:(NSDictionary *)args
             success:(SuccessBlock)success
             failure:(FailureBlock)failure
             progess:(ProgressBlock)progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_FETCH_SMS_TOKEN params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 * 重置账号密码
 */
+(void)resetPassword:(NSDictionary*)args
             success:(SuccessBlock)success
             failure:(FailureBlock)failure
             progess:(ProgressBlock)progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_RESET_PASSWORD  params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 * 用户信息-心跳
 */
+(void)accountMsgHeart:(NSDictionary*)args
               success:(SuccessBlock)success
               failure:(FailureBlock)failure
               progess:(ProgressBlock)progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_ACCOUNT_MSG_HEART  params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 * 获取用户钱包信息
 */
+(void)userWalletMsgHeart:(NSDictionary*)args
                  success:(SuccessBlock)success
                  failure:(FailureBlock)failure
                  progess:(ProgressBlock)progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_USER_WALLET params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 * 获取短信验证码
 */
+(void)mobileAuthCode:(NSDictionary*)args
              success:(SuccessBlock)success
              failure:(FailureBlock)failure
              progess:(ProgressBlock)progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_MOBILEAUTHCODE  params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 * 退出登录
 */
+(void)loginOut:(NSDictionary*)args
        success:(SuccessBlock)success
        failure:(FailureBlock)failure
        progess:(ProgressBlock)progress
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_LOGINOUT params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
@end
