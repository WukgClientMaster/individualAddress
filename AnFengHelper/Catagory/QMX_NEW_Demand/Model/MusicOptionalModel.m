//
//  MusicOptionalModel.m
//  SmartCity
//
//  Created by 吴可高 on 2018/1/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "MusicOptionalModel.h"
#import "QMX_MusicTool.h"

@implementation MusicOptionalModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"musicID":@"id"};
}

-(void)setUrl:(NSString *)url{
    if (url == nil) return;
    NSURLComponents * components = [[NSURLComponents alloc]initWithString:url];
    NSString * urlScheme = components.scheme;
    if ([urlScheme isEqualToString:@"https"]) {
        [components setScheme:@"http"];
    }
    _url = components.URL.absoluteString;
    NSString * cacheDocument = [[QMX_MusicTool shareInstance] fetchCacheAppendDocument:_url];
    self.pauseOrPlayModel.cachePath = cacheDocument;
}

@end
