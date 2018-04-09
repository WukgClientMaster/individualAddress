//
//  APPCUSTextFieldViewItem.m
//  AnFengHelper
//
//  Created by 智享城市iOS开发 on 2018/4/7.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "APPCUSTextFieldViewItem.h"

@implementation APPCUSTextFieldViewItem
+(instancetype)initializeWithImg:(NSString*)img title:(NSString*)title subtitle:(NSString*)subtitle placeholder:(NSString*)placeholder{
    APPCUSTextFieldViewItem * item = [self initializeWithImg:img title:title subtitle:subtitle];
    item.placeholder = placeholder;
    return item;
}
@end
