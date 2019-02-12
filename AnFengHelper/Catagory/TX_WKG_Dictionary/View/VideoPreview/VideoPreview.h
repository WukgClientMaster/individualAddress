//
//  VideoPreview.h
//  TCLVBIMDemo
//
//  Created by xiang zhang on 2017/4/18.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXLiteAVSDK_Professional/TXVideoEditerListener.h>
@protocol TXVideoPreviewListener;

@protocol VideoPreviewDelegate <NSObject>
- (void)onVideoPlay;
- (void)onVideoPause;
- (void)onVideoResume;
- (void)onVideoPlayProgress:(CGFloat)time;
- (void)onVideoPlayFinished;

@optional
- (void)onVideoEnterBackground;
- (void)onVideoWillEnterForeground;
@end

@interface VideoPreview : UIView<TXVideoPreviewListener>

@property(nonatomic,weak) id<VideoPreviewDelegate> delegate;
@property(nonatomic,strong) UIView *renderView;
@property(nonatomic, readonly, assign) BOOL isPlaying;
@property (strong, nonatomic)UIButton * playBtn;

- (instancetype)initWithFrame:(CGRect)frame coverImage:(UIImage *)image;
- (void)setPlayBtnHidden:(BOOL)isHidden;

- (void)setPlayBtn:(BOOL)videoIsPlay;

- (void)playVideo;

- (void)removeNotification;
@end
