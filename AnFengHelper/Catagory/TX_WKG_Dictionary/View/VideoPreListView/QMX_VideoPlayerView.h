//
//  QMX_VideoPlayerView.h
//  SmartCity
//
//  Created by 洪欣 on 2017/12/8.
//  Copyright © 2017年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libksygpulive/KSYMoviePlayerController.h>
#import <libksygpulive/KSYMoviePlayerDefines.h>

typedef void(^DoubleTapBlock)(void);
typedef void(^RotatedPlayerBlock)(BOOL canRotate, BOOL rotatedPlayerToLandscape);
typedef void(^PlayBtnStateBlock)(BOOL canRotate, BOOL pause);


typedef  void(^TX_WKG_VideoPlayViewStatusChangeCallback)(NSString * status_stop); //status:YES 暂停 NO:播放
typedef  void(^TX_WKG_VideoPlayObserverProgressCallback)(CGFloat progress); //监听视频播放进度

@interface QMX_VideoPlayerView : UIView
@property (strong, nonatomic) KSYMoviePlayerController *player; // 视频播放器
@property (assign, nonatomic) BOOL canPlay;
//- (instancetype)initWithURLStr:(NSString *)urlStr coverUrl:(NSString *)coverUrl;
@property (copy, nonatomic) void (^videoLoading)();
@property (copy, nonatomic) void (^videoLoadComplete)();
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (copy, nonatomic) TX_WKG_VideoPlayViewStatusChangeCallback videoPlayerStatusChangeCallback;
@property (copy, nonatomic) TX_WKG_VideoPlayObserverProgressCallback observerProgressCallback;

- (void)changeURL:(NSString *)url coverURL:(NSString *)coverUrl;
- (void)setupURL:(NSURL *)url;
- (void)playVideo;
- (void)pauseVideo;
- (void)removeVideo;
- (void)specifiedPauseVideo;
- (void)videoSeekTotolerenceWithProgress:(CGFloat)progressValue;
@property (assign, nonatomic) BOOL isCurrentVideo;
@property (strong, nonatomic) UIProgressView *progressView;
@property (weak, nonatomic) UITapGestureRecognizer *tap2;
@property (copy, nonatomic) DoubleTapBlock doubleTapBlock;
@property (copy, nonatomic) PlayBtnStateBlock playBtnStateBlock;

@property (assign, nonatomic) BOOL hideProgressView;
@property (copy, nonatomic) NSString * businessType;
- (void)singleTap:(UITapGestureRecognizer *)tap;
- (void)doubleTap:(UITapGestureRecognizer *)tap;
- (void)rotatePlayer:(RotatedPlayerBlock)block;
- (void)addSwipeGr;
@end

