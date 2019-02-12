//
//  TX_WKG_VideoPlayerView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/26.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DoubleTapBlock)(void);
typedef  void(^TX_WKG_VideoPlayViewStatusChangeCallback)(NSString * status_stop); //status:YES 暂停 NO:播放
typedef  void(^TX_WKG_VideoPlayObserverProgressCallback)(CGFloat progress); //监听视频播放进度

typedef  void(^TX_WKG_VideoPlayObserveriSPlayingCallback)(void);
@interface TX_WKG_VideoPlayerView : UIView

@property (copy, nonatomic) TX_WKG_VideoPlayViewStatusChangeCallback videoPlayerStatusChangeCallback;
@property (copy, nonatomic) TX_WKG_VideoPlayObserverProgressCallback observerProgressCallback;
@property (copy, nonatomic) TX_WKG_VideoPlayObserveriSPlayingCallback observeriSPlayingCallback;
@property (copy, nonatomic) void (^videoLoading)();
@property (copy, nonatomic) void (^videoLoadComplete)();
@property (copy, nonatomic) DoubleTapBlock doubleTapBlock;
@property(nonatomic,strong) UIView * renderView;
@property(nonatomic,strong) AVPlayerLayer * playLayer;
@property (assign, nonatomic) BOOL hideProgressView;
@property (assign, nonatomic) BOOL isCurrentVideo;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property(nonatomic,assign) NSInteger optionalVideoIndex;
@property (weak, nonatomic)   UITapGestureRecognizer *tap2;
+(instancetype)shareInstance;

-(void)replaceCurrentItemWithUrlString:(NSString*)urlString coverURL:(NSString *)coverUrl;

- (void)playVideo;
- (void)pauseVideo;
- (void)removeVideo;
- (void)specifiedPauseVideo;

- (void)videoSeekTotolerenceWithProgress:(CGFloat)progressValue;

-(void)resetPlayerViews;

- (void)singleTap:(UITapGestureRecognizer *)tap;
- (void)doubleTap:(UITapGestureRecognizer *)tap;
@end
