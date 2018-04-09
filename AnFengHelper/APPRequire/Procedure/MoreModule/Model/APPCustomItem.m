//
//  APPCustomItem.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "APPCustomItem.h"
@implementation APPCustomItem

+(instancetype)initializeWithImg:(NSString*)img title:(NSString*)title subtitle:(NSString*)subtitle block:(OperationBlock)block;
{
    APPCustomItem * item = [self initializeWithImg:img title:title subtitle:subtitle];
    item.block  = block;
    return item;
}
@end
