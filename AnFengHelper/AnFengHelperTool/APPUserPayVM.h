//
//  APPUserPayVM.h
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

@interface APPUserPayVM : NSObject
/*!
 *  创建订单 args： 订单支付相关参数信息
 */
+(void)newOrder:(NSDictionary*)agrs
        success:(SuccessBlock) success
        failure:(FailureBlock) failure
        progess:(ProgressBlock) progress;
/*!
 *  创建充值平台币订单 args： 订单支付相关参数信息
 */
+(void)newPlatformOrder:(NSDictionary*)agrs
        success:(SuccessBlock) success
        failure:(FailureBlock) failure
        progess:(ProgressBlock) progress;
/*!
 *  用户充值列表 args： 订单支付相关参数信息
 */
+(void)userRechargelist:(NSDictionary*)args
            success:(SuccessBlock)success
            failure:(FailureBlock)failure
           progress:(ProgressBlock)progress;
/*!
 *  用户消费列表 args： 订单支付相关参数信息
 */
+(void)userConsumelist:(NSDictionary*)args
                success:(SuccessBlock)success
                failure:(FailureBlock)failure
               progress:(ProgressBlock)progress;
/*!
 *  微信支付 args： 订单支付相关参数信息
 */
+(void)wechatPay:(NSDictionary*)args
        success:(SuccessBlock)success
        failure:(FailureBlock)failure
       progress:(ProgressBlock)progress;
/*!
 *  支付宝支付 args： 订单支付相关参数信息
 */
+(void)alipayPay:(NSDictionary*)args
         success:(SuccessBlock)success
         failure:(FailureBlock)failure
        progress:(ProgressBlock)progress;
/*!
 *  银联支付 args： 订单支付相关参数信息
 */
+(void)unionPay:(NSDictionary*)args
         success:(SuccessBlock)success
         failure:(FailureBlock)failure
        progress:(ProgressBlock)progress;


@end
