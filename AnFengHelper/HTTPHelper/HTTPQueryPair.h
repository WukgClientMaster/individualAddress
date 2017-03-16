//
//  HTTPQueryPair.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/16.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPQueryPair : NSObject

+(NSString*)HTTPQueryStringFromParameters:(NSDictionary*)parameters;

@end
