//
//  APPGroup.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class APPItem;
@interface APPGroup : NSObject

@property(nonatomic,strong) NSArray <APPItem *> * items;
@property(nonatomic,copy) NSString * header;
@property(nonatomic,copy) NSString * footer;

+(instancetype)initializeWithItems:(NSArray*)items header:(NSString*)header footer:(NSString*)footer;

@end

