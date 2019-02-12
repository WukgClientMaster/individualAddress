//
//  VideoConfigure.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/11.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TXLiteAVSDK_Professional/TXUGCRecord.h>
@interface VideoConfigure : NSObject
@property(nonatomic,assign)TXVideoAspectRatio videoRatio;
@property(nonatomic,assign)TXVideoResolution videoResolution;
@property(nonatomic,assign)int bps;
@property(nonatomic,assign)int fps;
@property(nonatomic,assign)int gop;

@end
