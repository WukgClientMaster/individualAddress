//
//  WKG_SmartCity_PlayerView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/7/11.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TX_WKG_Video_PreView_ProgressView;
@interface WKG_SmartCity_PlayerView : UIView
@property (strong,readonly,nonatomic) TX_WKG_Video_PreView_ProgressView * progressView;

- (void)pauseVideo;

//播放网络地址
-(void)setVideoPlayerWithURL:(NSString*)videoURL cover:(NSString*)coverString;
//播放本地视频
-(void)setVideoPlayerWithFileURL:(NSString*)fileURL cover:(UIImage*)coverImage;
//播放本地视频
-(void)setVideoPlayerWithLocalURL:(NSURL*)fileURL cover:(UIImage*)coverImage;
@end
