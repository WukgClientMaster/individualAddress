//
//  PhotoCompositionTool.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/29.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PhotoCompressionHandle)(NSString* status);
@interface PhotoCompositionTool : NSObject

+(void)photoCompressionSessionWithOutputPath:(NSString*)videoPath renderImages:(NSArray*)images handle:(PhotoCompressionHandle)callback;

@end
