//
//  TX_WKG_VideoEditViewController.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicInfo;
@class VideoDraftTool;
#import <TXLiteAVSDK_Professional/TXLiveSDKTypeDef.h>

@interface TX_WKG_VideoEditViewController : UIViewController
@property (strong, nonatomic) VideoDraftTool *draftVideo;
@property (copy, nonatomic) NSString * musicOptString;//是否关闭视频的原音 YES：关闭 NO：不需要关闭
- (instancetype)initWithCoverImage:(UIImage *)coverImage
                         videoPath:(NSString*)videoPath
                         musicpath:(MusicInfo*)musicInfo
                        renderMode:(TX_Enum_Type_RenderMode)renderMode
                      isFromRecord:(BOOL)isFromRecord;

- (instancetype)initWithCoverImage:(UIImage *)coverImage
                        videoAsset:(AVAsset*)videoAsset
                         videoPath:(NSString*)videoPath
                         musicpath:(MusicInfo*)musicInfo
                        renderMode:(TX_Enum_Type_RenderMode)renderMode
                      isFromRecord:(BOOL)isFromRecord;



@end
