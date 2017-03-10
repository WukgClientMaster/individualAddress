//
//  APPItem.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "APPItem.h"

@implementation APPItem
+(instancetype)initializeWithImg:(NSString*)img title:(NSString*)title subtitle:(NSString*)subtitle;
{
    APPItem * item = [[self alloc]init];
    item.img = img;
    item.title = title;
    item.subtitle = subtitle;
    return item;
}
@end
