//
//  TX_WKGVideoEditManager.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/29.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKGVideoEditManager.h"

static TX_WKGVideoEditManager * _tx_wkgVideoEditManager = nil;
@implementation TX_WKGVideoEditManager
+(instancetype)shareInstance{
    if (_tx_wkgVideoEditManager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _tx_wkgVideoEditManager = [[TX_WKGVideoEditManager alloc]init];
        });
    }
    return _tx_wkgVideoEditManager;
}

@end
