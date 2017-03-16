//
//  HTTPConfig.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/16.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#ifndef HTTPConfig_h
#define HTTPConfig_h
#import <Foundation/Foundation.h>

/*!
 * AnFengHelper
 *    1.用户系统，所有“query”地址
 */
static NSString * ANFENG_ACCOUNT_REGISTER = @"/api/account/register";
static NSString * ANFENG_QUICK_CREATE_ACCOUNT = @"/api/account/username";
static NSString * ANFENG_ACCOUNT_LOGIN = @"/api/account/register";
static NSString * ANFENG_LOGIN_PHONE = @"api/account/login_phone";

static NSString * ANFENG_AUTO_LOGIN = @"api/account/login_token";
static NSString * ANFENG_FETCH_CHARGE = @"";
static NSString * ANFENG_SMS_RESET_PASSWORD = @"api/account/sms_reset_password";
static NSString * ANFENG_PLATFORM_AUTH_REGISTER = @"api/account/oauth_register";
static NSString * ANFENG_PLATFORM_AUTH_REGISTER_SEND_MSG = @"api/account/oauth_sms_bind";

static NSString * ANFENG_PLATFORM_AUTH_LOGIN = @"/api/account/oauth_login";
static NSString * ANFENG_FETCH_SMS_TOKEN = @"api/account/sms_token";
static NSString * ANFENG_RESET_PASSWORD = @"api/account/reset_password";

static NSString * ANFENG_ACCOUNT_MSG_HEART = @"api/user/heart";
static NSString * ANFENG_USER_WALLET = @"user/wallet";

static NSString * ANFENG_MOBILEAUTHCODE = @"/api/mobile/authCode";
static NSString * ANFENG_LOGINOUT = @"/api/user/logout";

/*!
 * AnFengHelper
 *    2.支付系统，所有“query”地址
 */
static NSString * ANFENG_NEW_ORDER = @"api/pay/order/new";
static NSString * ANFENG_NEW_PLATFORM_ORDER = @"api/pay/order/anfeng/new";
static NSString * ANFENG_USER_CHARGE_LIST = @"api/user/recharge";
static NSString * ANFENG_USER_CONSUME_LIST = @"api/user/consume";

static NSString * ANFENG_WECHAT_PAY = @"api/pay/nowpay/wechat";
static NSString * ANFENG_ALIPAY = @"api/pay/nowpay/alipay";
static NSString * ANFENG_UNICOMPAY = @"api/pay/nowpay/unionpay";

#endif /* HTTPConfig_h */
