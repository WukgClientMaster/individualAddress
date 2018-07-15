//
//  VideoJsonModel.m
//  AnFengHelper
//
//  Created by 吴可高 on 2018/7/14.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "VideoJsonModel.h"
@interface VideoJsonModel()
@property(nonatomic,copy) NSString * cover;
@property(nonatomic,copy) NSString * video;
@end

@implementation VideoJsonModel
+(instancetype)videoJsonWithCoverUrl:(NSString*)cover video:(NSString*)video{
    VideoJsonModel * model = [[VideoJsonModel alloc]init];
    model.cover = cover;
    model.video = video;
    return model;
}

@end
