//
//  VideoJsonModel.h
//  AnFengHelper
//
//  Created by 吴可高 on 2018/7/14.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoJsonModel : NSObject
@property(nonatomic,readonly,copy) NSString * cover;
@property(nonatomic,readonly,copy) NSString * video;

+(instancetype)videoJsonWithCoverUrl:(NSString*)cover video:(NSString*)video;

@end
