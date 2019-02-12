//
//  QMX_VideoPlayerView.m
//  SmartCity
//
//  Created by 洪欣 on 2017/12/8.
//  Copyright © 2017年 NRH. All rights reserved.
//

#import "QMX_VideoPlayerView.h"
//#import "VideoResourceDataManager.h"
#import "QMX_VideoloadingView.h"

#define RecommendBottomViewH 49

#define kCustomVideoScheme @"yourScheme"

@interface QMX_VideoPlayerView ()
@property (strong, nonatomic) UIView *progressContainerView;
@property (copy, nonatomic) NSString *urlStr; // 视频地址
@property (copy, nonatomic) NSString *coverUrl;
@property (strong, nonatomic) UIButton *playBtn; // 播放 / 暂停
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) BOOL isRemove;
@property (weak, nonatomic) UITapGestureRecognizer *tap1;
@property (assign, nonatomic) BOOL isRelease;
@property (assign, nonatomic) BOOL haveHandled;

@property (assign, nonatomic) BOOL canRotate;                   /**< 依据视频规格，判断当前播放器能否旋转 */
@property (assign, nonatomic) BOOL rotatedPlayerToLandscape;    /**< 已旋转播放器至横屏状态 */
@property (copy, nonatomic) NSString * signVideoPlayStatus;//标记视频是否在播放
@property (strong, nonatomic) QMX_VideoloadingView * loadingView;
@end

@implementation QMX_VideoPlayerView

- (QMX_VideoloadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[QMX_VideoloadingView alloc] init];
    }
    return _loadingView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.isCurrentVideo = YES;
    self.canPlay = YES;
    self.backgroundColor = [UIColor blackColor];
    self.autoresizesSubviews = YES;
    self.player = [[KSYMoviePlayerController alloc] initWithContentURL:nil];
    self.player.controlStyle = MPMovieControlStyleNone;
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.bufferSizeMax = 100;
    self.player.shouldLoop = YES;
    //    self.player.scalingMode = MPMovieScalingModeAspectFit;
    self.player.scalingMode = MPMovieScalingModeFill;
    self.player.shouldEnableKSYStatModule = NO;
    [self addSubview:self.player.view];
    [self addSubview:self.imageView];
    self.playBtn.hidden = YES;
    [self addSubview:self.playBtn];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self addGestureRecognizer:tap1];
    self.tap1 = tap1;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [self addGestureRecognizer:tap2];
    self.tap2 = tap2;
    [self addSubview:self.progressContainerView];
    [self.progressContainerView addSubview:self.progressView];
    
    self.canRotate = NO;
    self.rotatedPlayerToLandscape = NO;
}

// self.playBtn.selected == YES 代表播放（图片出现）
// self.playBtn.selected == NO  代表暂停（图片消失）
- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (!self.isCurrentVideo) {
        return;
    }
    self.playBtn.selected = !self.playBtn.selected;
    if (self.playBtn.selected) {
        self.canPlay = YES;
        ////status:YES 暂停 NO:播放
        if (self.videoPlayerStatusChangeCallback) {
            self.videoPlayerStatusChangeCallback(@"NO");
        }
        if (![self.player isPreparedToPlay]) {
            self.player.shouldAutoplay = YES;
            [self.player prepareToPlay];
            [self setLoadingBlock];
        }else {
            self.playBtn.alpha = 1;
            [self.player play];
        }
        
    }else {
        self.canPlay = NO;
        [self.player pause];
        [self.playBtn setSelected:NO];
        ////status:YES 暂停 NO:播放
        if (self.videoPlayerStatusChangeCallback) {
            self.videoPlayerStatusChangeCallback(@"YES");
        }
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (!self.isCurrentVideo) {
        return;
    }
    
    self.tap1.enabled = NO;
    if (self.doubleTapBlock) {
        self.doubleTapBlock();
    }
    
    CGPoint touchPoint = [tap locationInView:tap.view];
    [self addAnimationWithPoint:touchPoint];
}

- (void)rotatePlayer:(RotatedPlayerBlock)block {
    
    // rotate the player
    if (self.canRotate) {
        
        if (self.rotatedPlayerToLandscape) {
            
            self.player.rotateDegress = 0;
        }
        else {
            self.player.rotateDegress = 270;
        }
        
        self.rotatedPlayerToLandscape = !self.rotatedPlayerToLandscape;
        
        if (block) {
            
            block(self.canRotate, self.rotatedPlayerToLandscape);
        }
    }
}

-(void)addAnimationWithPoint:(CGPoint)point {
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qmx_tuijian_aixinred"]];
    [self addSubview:img];
    
    UIImageView *img2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qmx_tuijian_aixinred"]];
    [self addSubview:img2];
    
    img.size = CGSizeMake(96, 82);
    img.center = point;
    
    img2.size = CGSizeMake(96, 82);
    img2.center = CGPointMake(point.x, point.y-10);
    
    int x1 = arc4random() % 110;
    img.transform = CGAffineTransformMakeRotation((x1-50) *M_PI / 180.0);
    
    int x2 = arc4random() % 110;
    img2.transform = CGAffineTransformMakeRotation((x2-50) *M_PI / 180.0);
    [UIView animateWithDuration:0.6 animations:^{
        img.transform = CGAffineTransformScale(img.transform, 1.7, 1.7);
        img.alpha = 0.3;
        
    } completion:^(BOOL finished) {
        [img removeFromSuperview];
    }];
    
    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        img2.transform = CGAffineTransformScale(img2.transform, 1.5, 1.5);
        img2.alpha = 0.3;
    } completion:^(BOOL finished) {
        [img2 removeFromSuperview];
        self.tap1.enabled = YES;
    }];
}
- (void)setupURL:(NSURL *)url {
    self.isRelease = YES;
    [self.player reset:NO];
    self.imageView.hidden = YES;
    self.urlStr = [url lastPathComponent];
    self.playBtn.selected = NO;
    self.canPlay = NO;
    self.playBtn.hidden = YES;
    self.player.view.alpha = 1;
    [self.player setUrl:url];
    self.player.shouldAutoplay = YES;
    self.progressView.progress = 0.f;
    self.haveHandled = NO;
    
    NSNumber *progressNumber = [NSNumber numberWithFloat:0.0];
    NSNumber *alphaNumber = [NSNumber numberWithFloat:1.0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"progressValueChanged" object:nil userInfo:@{@"progress": progressNumber, @"alpha":alphaNumber}];
    
    [self playVideo];
    self.tap2.enabled = NO;
}

- (void)changeURL:(NSString *)url coverURL:(NSString *)coverUrl {
    if (url.length == 0 || url == nil)return;
    [self addObser];
    [self.player reset:NO];
    self.imageView.alpha = 1;
    self.imageView.hidden = NO;
    self.coverUrl = coverUrl;
    self.urlStr = url;
    self.canPlay = NO;
    self.playBtn.hidden = YES;
    //    self.player.view.alpha = 0;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:coverUrl]];
    //    [self.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:coverUrl] placeholderImage:[UIImage imageWithColor:[UIColor clearColor]] options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
    //
    //    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    //
    //    }];
    //在该代码区域添加一个AVURLAsset去管理视频在线缓存功能
    /*
     * 1 如果该视频数据信息已经被完全保存下来，就不应该再次去监听urlresourceData
     * 2 播放器加载url的方式应该改变，不应该使用“[NSURL URLWithString:url]”
     * 3 如果视频已经被完全缓存起来，我们应该使用“[NSURL fileURLWithPath:urlPath]”
     */
    NSURL * resourceUrl = [NSURL URLWithString:url];
    NSURLComponents *components = [[NSURLComponents alloc]initWithURL:resourceUrl resolvingAgainstBaseURL:NO];
    components.scheme = kCustomVideoScheme;
    AVURLAsset * urlAsset = [AVURLAsset URLAssetWithURL:components.URL options:nil];
    [self.player setUrl:[NSURL URLWithString:url]];
    self.player.shouldAutoplay = NO;
    self.progressView.progress = 0.f;
    self.progressView.alpha = 0;
    self.haveHandled = NO;
    [self setScaleModeForImageViewAndPlayer];
    NSNumber *progressNumber = [NSNumber numberWithFloat:0.0];
    NSNumber *alphaNumber = [NSNumber numberWithFloat:1.0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"progressValueChanged" object:nil userInfo:@{@"progress": progressNumber, @"alpha":alphaNumber}];
    // check video dimensions
    CGFloat ratio = 0;
    if (self.width > 0 && self.height > 0) {
        ratio = self.width/self.height;
        if (ratio > 1.1) {
            self.canRotate = YES;
        }
        else {
            self.canRotate = NO;
        }
    }
}

- (void)setScaleModeForImageViewAndPlayer {
    
    if (self.width > 0 && self.height > 0) {
        CGFloat height = ScreenWidth / self.width * self.height;
        CGFloat width = self.width;
        CGFloat margin = SC_iPhoneX ? 200 : SC_StatusBarAndNavigationBarHeight + SC_TabbarHeight;
        if (height > ScreenHeight) {
            width = ScreenHeight / height * width;
            if (width > ScreenWidth - 100) {
                self.imageView.contentMode = UIViewContentModeScaleAspectFill;
                self.player.scalingMode = MPMovieScalingModeAspectFill;
            }else {
                self.imageView.contentMode = UIViewContentModeScaleAspectFit;
                self.player.scalingMode = MPMovieScalingModeAspectFit;
            }
        }else if (height > ScreenHeight - margin) {
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            self.player.scalingMode = MPMovieScalingModeAspectFill;
            // no
        }else {
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            self.player.scalingMode = MPMovieScalingModeAspectFit;
            // yes
        }
    } else {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.player.scalingMode = MPMovieScalingModeAspectFit;
    }
}

- (void)playVideo {
    if (!self.isCurrentVideo) {
        return;
    }
    
    if ([self.urlStr length] > 0) {
        //        [self.player reset:NO];
        //        [self.player setUrl:[NSURL URLWithString:self.urlStr]];
    }
    
    if (![AFNetworkReachabilityManager sharedManager].isReachableViaWiFi && ![SingleClass sharedInstance].isReachableViaWiFiPlayVideo && !self.isRelease) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"当前为非WiFi环境，是否使用流量观看视频？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"暂停播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.playBtn.hidden = NO;
            ////status:YES 暂停 NO:播放
            if (self.videoPlayerStatusChangeCallback) {
                self.videoPlayerStatusChangeCallback(@"YES");
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PausePlaybackNoti" object:nil];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"任性播放" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [SingleClass sharedInstance].isReachableViaWiFiPlayVideo = YES;
            [self setPlayState];
        }]];
        
        [[Tools getCurrentViewController:self] presentViewController:alert animated:YES completion:nil];
    }else {
        
        [self setPlayState];
    }
}
- (void)setPlayState {
    self.canPlay = YES;
    self.playBtn.selected = YES;
    if (![self.player isPreparedToPlay]) {
        self.player.shouldAutoplay = YES;
        [self.player prepareToPlay];
        [self setLoadingBlock];
    }else {
        [self.player play];
        ////status:YES 暂停 NO:播放
        if (self.videoPlayerStatusChangeCallback) {
            self.videoPlayerStatusChangeCallback(@"NO");
        }
    }
    [UIView animateWithDuration:0.2 animations:^{
        
    } completion:^(BOOL finished) {
        self.playBtn.hidden = NO;
    }];
}

- (void)pauseVideo {
    if (self.player.isPreparedToPlay) {
        [self.player pause];
        
    }
    self.playBtn.selected = NO;
    self.canPlay = NO;
}
- (void)specifiedPauseVideo {
    if (self.player.isPreparedToPlay) {
        [self.player pause];
    }
    self.playBtn.hidden = YES;
    self.playBtn.selected = NO;
    self.canPlay = NO;
}
- (void)removeVideo {
    self.canPlay = NO;
    self.playBtn.selected = NO;
    [self stopVideo];
}
- (void)stopVideo {
    if (self.player.isPreparedToPlay) {
        if (self.player.isPlaying) {
            [self.player pause];
        }
        [self.player stop];
    }else {
        if (!self.isRemove) {
            [self.player stop];
        }
    }
    self.isRemove =YES;
}
- (void)hideImageView {
    if (!self.imageView.hidden) {
        [UIView animateWithDuration:1.0 animations:^{
            self.imageView.alpha = 0;
            self.player.view.alpha = 1;
        } completion:^(BOOL finished) {
            self.imageView.hidden = YES;
        }];
    }
}
- (void)didPlayVideoBtnClick:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        self.canPlay = YES;
        if (![self.player isPreparedToPlay]) {
            self.player.shouldAutoplay = YES;
            [self.player prepareToPlay];
            [self setLoadingBlock];
        }else {
            [self.player play];
        }
    }else {
        self.canPlay = NO;
        [self.player pause];
    }
}

- (void)setHideProgressView:(BOOL)hideProgressView {
    _hideProgressView = hideProgressView;
    [_progressView setHidden:_hideProgressView];
    if (_progressView.hidden == NO) {
        [self.progressContainerView addSubview:self.loadingView];
    }else{
        [self.loadingView removeFromSuperview];
    }
}
-(void)setBusinessType:(NSString *)businessType{
    _businessType = businessType;
    if (![_businessType isEqualToString:@"YB_BUSINESS"]) {
        [self.loadingView removeFromSuperview];
    }
}

#pragma mark - KSYMoviePlayerControllerNotification
// 播放器完成对视频文件的初始化时发送通知 >
-(void)handlePlaybackIsPreparedToPlayDidChange:(NSNotification *)notification{
    if (MPMediaPlaybackIsPreparedToPlayDidChangeNotification ==  notification.name) {
        //        [self setLoadCompleteBlock];
        if (!self.canPlay) {
            [self.player pause];
            self.playBtn.selected = NO;
        }
    }
    if (MPMoviePlayerLoadStateDidChangeNotification ==  notification.name) {
        if (MPMovieLoadStateStalled == self.player.loadState) {
            
        }else if (MPMovieLoadStatePlayable == self.player.loadState) {
            
        }
    }
}
- (void)setLoadingBlock {
    if (self.isCurrentVideo) {
        [self.loadingView stratAnima];
        if (self.videoLoading) {
            self.videoLoading();
        }
    }
}
- (void)setLoadCompleteBlock {
    if (self.isCurrentVideo) {
        [self.loadingView stopAnima];
        if (self.videoLoadComplete) {
            self.videoLoadComplete();
        }
    }
}
// 播放器状态发生改变 >
-(void)handlePlayerPlaybackStateDidChange:(NSNotification *)notification {
    switch (self.player.playbackState) {
        case MPMoviePlaybackStateStopped:
            DDLogDebug(@"播放停止");
            break;
        case MPMoviePlaybackStatePlaying:{
            DDLogDebug(@"正在播放");
            [self setLoadCompleteBlock];
            self.playBtn.selected = YES;
            [self hideImageView];
            break;
        }
        case MPMoviePlaybackStatePaused:
            DDLogDebug(@"播放暂停");
            self.playBtn.selected = NO;
            break;
        case MPMoviePlaybackStateInterrupted:
            DDLogDebug(@"播放被打断");
            break;
        case MPMoviePlaybackStateSeekingForward:
            DDLogDebug(@"向前seeking中");
            break;
        case MPMoviePlaybackStateSeekingBackward:
            DDLogDebug(@"向后seeking中");
            break;
        default:
            break;
    }
}
// 当播放完成时提供通知 >
-(void)handlePlayerPlaybackDidFinish:(NSNotification *)notification {
    int reason = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    //    [self stopTimer];
    if (reason == MPMovieFinishReasonPlaybackEnded) {
        DDLogDebug(@"播放完成");
        [self setLoadCompleteBlock];
    }else if (reason == MPMovieFinishReasonUserExited) {
        DDLogDebug(@"用户退出");
    }else if (reason == MPMovieFinishReasonPlaybackError) {
        DDLogDebug(@"视频出错");
        [self setLoadCompleteBlock];
    }
}
// 播放加载状态发送改变 >
-(void)handlePlayerLoadStateDidChange:(NSNotification *)notification {
    switch (self.player.loadState) {
        case MPMovieLoadStateUnknown:
            DDLogDebug(@"加载情况未知");
            break;
        case MPMovieLoadStatePlayable:
            DDLogDebug(@"加载完成，可以播放");
            if (!self.canPlay) {
                [self.player pause];
                self.playBtn.selected = NO;
            }else {
                [self.player play];
                self.playBtn.selected = YES;
            }
            break;
        case MPMovieLoadStatePlaythroughOK:
            DDLogDebug(@"加载完成，如果shouldAutoplay为YES，将自动开始播放");
            if (!self.canPlay) {
                [self.player pause];
                self.playBtn.selected = NO;
            }else {
                self.playBtn.selected = YES;
                [self.player play];
                [self hideImageView];
            }
            break;
        case MPMovieLoadStateStalled: {
            DDLogDebug(@"如果视频正在加载中");
            //            [self setLoadingBlock];
            break;
        }
        default:
            break;
    }
}
// 建议刷新播放器 >
-(void)handlePlayerSuggestReload:(NSNotification *)notification {
    [self.player reload:[NSURL URLWithString:self.urlStr] flush:NO mode:MPMovieReloadMode_Accurate];
}

//- (void)handlePlayerFrameRendered:(NSNotification *)notification {
//
//    if (!self.haveHandled) {
//        self.haveHandled = YES;
//        [self.player reload:[NSURL URLWithString:self.urlStr]];
//    }
//}

#pragma mark - < UIApplicationDidEnterBackgroundNotification >
// 程序进入后台 >
- (void)backGroundPauseMoive {
    [self pauseVideo];
}
// 程序进入前台
- (void)enterForegroundPlayMoive {
    if (self.isCurrentVideo) {
        [self playVideo];
    }
}
#pragma mark - setter 视频快进的进度
- (void)videoSeekTotolerenceWithProgress:(CGFloat)progressValue{
    CGFloat value = round(self.player.currentPlaybackTime);
    if (fabs(progressValue - value) < 0.1f)return;
    [self.player seekTo:progressValue accurate:YES];
}
#pragma mark - < 观察者 >
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqual:@"currentPlaybackTime"]) { // 视频正在播放
        
        // The player is playing the video
        //        [self hideImageView];
        //        self.playBtn.selected = YES;
        
        NSNumber *alphaNumber;
        
        if (self.player.duration != 0) {
            self.progressView.alpha = 1;
            alphaNumber = [NSNumber numberWithFloat:1.0];
        }
        else {
            alphaNumber = [NSNumber numberWithFloat:0.0];
        }
        CGFloat progress = self.player.currentPlaybackTime / self.player.duration;
        //        NSLog(@"%f",progress);
        [self.progressView setProgress:progress];
        NSNumber *progressNumber = @(progress);
        if (self.observerProgressCallback) {
            self.observerProgressCallback(progress);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"progressValueChanged" object:nil userInfo:@{@"progress": progressNumber, @"alpha":alphaNumber==nil? @(-1): alphaNumber}];
    }
}
#pragma mark - < 添加通知/观察者 >
-(void)addObser {
    [self.player addObserver:self forKeyPath:@"currentPlaybackTime" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backGroundPauseMoive) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundPlayMoive) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePlaybackIsPreparedToPlayDidChange:) name:(MPMediaPlaybackIsPreparedToPlayDidChangeNotification) object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePlayerPlaybackStateDidChange:) name:(MPMoviePlayerPlaybackStateDidChangeNotification) object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePlayerPlaybackDidFinish:) name:(MPMoviePlayerPlaybackDidFinishNotification) object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePlayerLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePlayerSuggestReload:) name:(MPMoviePlayerSuggestReloadNotification) object:self.player];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.player.view.frame = self.bounds;
    self.imageView.frame = self.bounds;
    self.playBtn.frame = self.bounds;
    CGFloat height = SC_iPhoneX ? (12.f + 8) : 8.f;
    if (![_businessType isEqualToString:@"YB_BUSINESS"]) {
        self.progressContainerView.frame = CGRectMake(0, SC_ScreenHeight -  RecommendBottomViewH, SC_ScreenWidth, 1);
    }else{
        self.progressContainerView.frame = CGRectMake(0, SC_ScreenHeight - height, SC_ScreenWidth, 1);
    }
    self.loadingView.frame = CGRectMake(0, 0,  SC_ScreenWidth, 2.f);
    self.progressView.frame = CGRectMake(0, 0, SC_ScreenWidth, 2.f);
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton button];
        [_playBtn setImage:[UIImage imageNamed:@"tx_wkg_recommend_video_play"] forState:UIControlStateNormal];
        [_playBtn setImage:[[UIImage alloc] init] forState:UIControlStateSelected];
        _playBtn.userInteractionEnabled = NO;
    }
    return _playBtn;
}
- (UIView *)progressContainerView {
    if (!_progressContainerView) {
        _progressContainerView = [[UIView alloc] init];
        _progressContainerView.backgroundColor = [UIColor clearColor];
        _progressContainerView.clipsToBounds = YES;
    }
    return _progressContainerView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.trackTintColor = [UIColor colorWithWhite:1 alpha:0.5];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"#ffffff" alpha:1.0];
    }
    return _progressView;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}
-(void)dealloc {
    [self.player removeObserver:self forKeyPath:@"currentPlaybackTime"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

