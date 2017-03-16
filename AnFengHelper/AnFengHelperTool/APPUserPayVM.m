//
//  APPUserPayVM.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/16.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "APPUserPayVM.h"

@implementation APPUserPayVM
/*!
 *  创建订单 args： 订单支付相关参数信息
 */
+(void)newOrder:(NSDictionary*)args
        success:(SuccessBlock) success
        failure:(FailureBlock) failure
        progess:(ProgressBlock) progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_NEW_ORDER params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 *  创建充值平台币订单 args： 订单支付相关参数信息
 */
+(void)newPlatformOrder:(NSDictionary*)args
                success:(SuccessBlock) success
                failure:(FailureBlock) failure
                progess:(ProgressBlock) progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_NEW_PLATFORM_ORDER params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 *  用户充值列表 args： 订单支付相关参数信息
 */
+(void)userRechargelist:(NSDictionary*)args
                success:(SuccessBlock)success
                failure:(FailureBlock)failure
               progress:(ProgressBlock)progress
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_USER_CHARGE_LIST params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 *  用户消费列表 args： 订单支付相关参数信息
 */
+(void)userConsumelist:(NSDictionary*)args
               success:(SuccessBlock)success
               failure:(FailureBlock)failure
              progress:(ProgressBlock)progress
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_USER_CONSUME_LIST params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 *  微信支付 args： 订单支付相关参数信息
 */
+(void)wechatPay:(NSDictionary*)args
         success:(SuccessBlock)success
         failure:(FailureBlock)failure
        progress:(ProgressBlock)progress;
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_WECHAT_PAY params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
/*!
 *  支付宝支付 args： 订单支付相关参数信息
 */
+(void)alipayPay:(NSDictionary*)args
         success:(SuccessBlock)success
         failure:(FailureBlock)failure
        progress:(ProgressBlock)progress
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_ALIPAY params:args success:^(NSString *msg, id response) {
        success(msg,response);
        
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}

/*!
 *  银联支付 args： 订单支付相关参数信息
 */
+(void)unionPay:(NSDictionary*)args
        success:(SuccessBlock)success
        failure:(FailureBlock)failure
       progress:(ProgressBlock)progress
{
    [[HTTPHelper shareInstance]postTaskWithPath:ANFENG_UNICOMPAY params:args success:^(NSString *msg, id response) {
        success(msg,response);
    } failure:^(NSError *error) {
        failure(error);
    }progress:^(int64_t progress) {
        
    }];
}
@end
