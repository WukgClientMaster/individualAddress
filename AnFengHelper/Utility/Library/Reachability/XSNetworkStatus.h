//
//  XSNetworkStatus.h
//  Babylon
//
//  Created by 陈冲 on 14-6-3.
//  Copyright (c) 2014年 Yixue. All rights reserved.
//

#import <Foundation/Foundation.h>
//网络状态
typedef enum
{
    NetWorkStatusNone,
    NetWorkStatusWifi,
    NetWorkStatusWwan
} NetWorkStatus;

@interface XSNetworkStatus : NSObject

AS_SINGLETON(XSNetworkStatus)

@property (nonatomic,assign) NetWorkStatus netStatus;


@end
