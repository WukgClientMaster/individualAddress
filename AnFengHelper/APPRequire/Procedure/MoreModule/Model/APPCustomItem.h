//
//  APPCustomItem.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "APPItem.h"

typedef void (^OperationBlock)(NSString* msg,id response);

@interface APPCustomItem : APPItem
@property(nonatomic,copy) OperationBlock block;

+(instancetype)initializeWithImg:(NSString*)img title:(NSString*)title subtitle:(NSString*)subtitle block:(OperationBlock)block;
@end
