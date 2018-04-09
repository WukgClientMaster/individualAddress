//
//  APPArrowItem.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "APPItem.h"

@interface APPArrowItem : APPItem

@property(nonatomic,assign) Class targetClass;

+(instancetype)initializeWithImg:(NSString*)img title:(NSString*)title subtitle:(NSString*)subtitle class:(Class)cls;

@end
