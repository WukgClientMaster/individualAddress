//
//  APPArrowItem.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "APPArrowItem.h"

@implementation APPArrowItem

+(instancetype)initializeWithImg:(NSString*)img title:(NSString*)title subtitle:(NSString*)subtitle class:(Class)cls;
{
    APPArrowItem * item = [self initializeWithImg:img title:title subtitle:subtitle];
    item.targetClass = cls;
    return item;
}
@end
