//
//  APPGroup.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "APPGroup.h"

@implementation APPGroup

+(instancetype)initializeWithItems:(NSArray*)items header:(NSString*)header footer:(NSString*)footer;
{
    
    APPGroup * group = [[APPGroup alloc]init];
    group.items = items;
    group.header = header;
    group.footer = footer;
    return group;
}
@end
