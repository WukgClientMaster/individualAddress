//
//  NSDictionary+NSData.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/13.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSData)

+ (NSDictionary*)dictionaryWithContentsOfData:(NSData*)data;
@end
