//
//  Exception.h
//  IpadApp
//
//  Created by 吴可高 on 15/8/25.
//  Copyright (c) 2015年 吴可高. All rights reserved.
#import <Foundation/Foundation.h>

@interface Exception : NSObject
/**
 *  根据error Code 错误码
 *  @param errorCode showToastMessage
 */
+(Exception*)showExceptionErrorCode:(NSString*)errorCode;
/**
 *  服务器异常，有我们本地Exception Class 现实ToastMsg
 */
+(void)showDefaultExceptionMsg;
/**
 *    本地网络未连接,请查看网络设置
 */
+(void)showNotNetWorkExceptionMsg;

@end
