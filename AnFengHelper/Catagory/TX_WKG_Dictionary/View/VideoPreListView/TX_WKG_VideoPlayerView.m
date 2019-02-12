//
//  TX_WKG_VideoPlayerView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/26.
//  Copyright © 2018年 NRH. All rights reserved.
//

#define TX_WKG_RecommendBottomViewH 49

#import "TX_WKG_VideoPlayerView.h"
#import "RequestTaskManager.h"
#import "HttpServerConnection.h"
#import "HTTPServerCacheManager.h"

static TX_WKG_VideoPlayerView * _tx_wkg_VideoPlayerView = nil;
@interface TX_WKG_VideoPlayerView()<HttpServerConnectionDelegate>

@property (strong, nonatomic) UIView *progressContainerView;
@property (strong, nonatomic) UIProgressView *progressView;
@property (weak, nonatomic)   UITapGestureRecognizer *tap1;
@property (strong, nonatomic) UIImageView *imageView;

@property(nonatomic,strong) AVPlayer *  player;
@property(nonatomic,strong) AVPlayerItem  * playerItem;
@property(strong, nonatomic)AVURLAsset  *videoURLAsset;;
@property(nonatomic,strong) UIButton * video_status_btn;
@property(nonatomic,strong) id timeObser;
@property (copy, nonatomic) NSString * currentVideoURL;
@property (copy, nonatomic) NSString * currentCoverURL;
@property (assign, nonatomic) BOOL  isPlaying;
@property(nonatomic,assign) NSInteger  preVideoIdx;

@end

void * AVPlayerItemStatusKey = &AVPlayerItemStatusKey;
void * AVPlayerItemPlaybackBufferEmpty = &AVPlayerItemPlaybackBufferEmpty;
void * AVPlayerItemPlaybackLikelyToKeepUp = &AVPlayerItemPlaybackLikelyToKeepUp;
void * AVPlayerItemPlaybackBufferFull = &AVPlayerItemPlaybackBufferFull;
void * TX_WKG_AVPlayerTimeControlStatus = &TX_WKG_AVPlayerTimeControlStatus;

@implementation TX_WKG_VideoPlayerView
- (void)playVideo{
    if (self.isCurrentVideo) {
        [self.video_status_btn setSelected:YES];
        [self.player play];
        self.isPlaying = YES;
    }
}

- (void)pauseVideo{
    if ([[NSThread currentThread]isMainThread]) {
        [self.video_status_btn setSelected:NO];
        [self.player pause];
        self.isPlaying = NO;
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.video_status_btn setSelected:NO];
            [self.player pause];
            self.isPlaying = NO;
        });
    }
}

- (void)removeVideo{
    [self.video_status_btn setSelected:NO];
    [self.player pause];
    self.isPlaying = NO;
}

- (void)specifiedPauseVideo{
    [self.video_status_btn setSelected:NO];
    [self.player pause];
    self.isPlaying = NO;
}

+(instancetype)shareInstance{
    if (_tx_wkg_VideoPlayerView == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (!_tx_wkg_VideoPlayerView) {
                _tx_wkg_VideoPlayerView = [[TX_WKG_VideoPlayerView alloc]init];
            }
        });
    }
    return _tx_wkg_VideoPlayerView;
}

#pragma mark - setter methods
- (void)setHideProgressView:(BOOL)hideProgressView {
    _hideProgressView = hideProgressView;
    [_progressView setHidden:_hideProgressView];
}
#pragma mark - getter methods
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
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"#ffffff" alpha:1.0];
    }
    return _progressView;
}

-(AVPlayer *)player{
    _player =({
        if (!_player) {
            _player = [[AVPlayer alloc]init];
            if([[UIDevice currentDevice] systemVersion].intValue>=10){
                self.player.automaticallyWaitsToMinimizeStalling = NO;
            }
        }
        _player;
    });
    return _player;
}
-(UIView *)renderView{
    _renderView = ({
        if (!_renderView) {
            _renderView = [[UIView alloc]initWithFrame:CGRectMakeAdaptation(0, 0, KScreenWidth, KScreenHeight)];
            _renderView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1f];
        }
        _renderView;
    });
    return _renderView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _imageView.contentMode = UIViewContentModeCenter;
        _imageView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8f];
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

-(UIButton *)video_status_btn{
    _video_status_btn = ({
        if (!_video_status_btn) {
            _video_status_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_video_status_btn setImage:[UIImage imageNamed:@"tx_wkg_recommend_video_play"] forState:UIControlStateNormal];
            [_video_status_btn setImage:[UIImage new] forState:UIControlStateSelected];
            [_video_status_btn addTarget:self action:@selector(videoPlayStatus:) forControlEvents:UIControlEventTouchUpInside];
        }
        _video_status_btn;
    });
    return _video_status_btn;
}

#pragma mark -IBOutlet Events
- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (!self.isCurrentVideo){
        return;
    }
    ////status:YES 暂停 NO:播放
    self.video_status_btn.selected = !self.video_status_btn.selected;
    if (self.video_status_btn.selected) {
        [self onVideoPlay];
    }else {
        [self onVideoPause];
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

#pragma mark - setter  methods
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

-(void)videoPlayStatus:(UIButton*)args{
    args.selected = !args.selected;
    if (args.selected) {
        [self onVideoPlay];
    }else{
        [self onVideoPause];
    }
}

-(void)onVideoPlay{
    [self conditionalWithNetEnviroment];
}

-(void)conditionalWithNetEnviroment{
    if (![AFNetworkReachabilityManager sharedManager].isReachableViaWiFi && ![SingleClass sharedInstance].isReachableViaWiFiPlayVideo) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"当前为非WiFi环境，是否使用流量观看视频？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"暂停播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self onVideoPause];
            self.isPlaying = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PausePlaybackNoti" object:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"任性播放" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [SingleClass sharedInstance].isReachableViaWiFiPlayVideo = YES;
            [self.video_status_btn setSelected:YES];
            [self.player play];
            self.isPlaying = YES;
            if (self.videoPlayerStatusChangeCallback) {
                self.videoPlayerStatusChangeCallback(@"NO");
            }
        }]];
        [[Tools getCurrentViewController:self] presentViewController:alert animated:YES completion:nil];
    }else{
        [self.video_status_btn setSelected:YES];
        [self.player play];
        self.isPlaying = YES;
        if (self.videoPlayerStatusChangeCallback) {
            self.videoPlayerStatusChangeCallback(@"NO");
        }
    }
}

-(void)onVideoPause{
    [self.video_status_btn setSelected:NO];
    [self.player pause];
    self.isPlaying = NO;
    if (self.videoPlayerStatusChangeCallback) {
        self.videoPlayerStatusChangeCallback(@"YES");
    }
}

-(void)resetPlayerViews{
    [self.player pause];
    self.playLayer = nil;
    self.isPlaying = NO;
    _player = nil;
    _renderView = nil;
    self.isCurrentVideo = NO;
    self.currentCoverURL = nil;
    self.currentVideoURL = nil;
    self.playerItem =  nil;
    [self.imageView removeFromSuperview];
    [self.renderView removeFromSuperview];
    [self.playLayer removeFromSuperlayer];
    [self.video_status_btn removeFromSuperview];
    [self.progressContainerView  removeFromSuperview];
    [self.progressView removeFromSuperview];
    [self.video_status_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
    }];
    [self unregisterAllObserver];
    self.renderView.frame = CGRectMake(0, 0, KScreenWidth,KScreenHeight);
    [self addSubview:self.renderView];
    [self addSubview:self.progressContainerView];
    [self.progressContainerView addSubview:self.progressView];
    [self loadSubViewObjects];
}

-(void)setOptionalVideoIndex:(NSInteger)optionalVideoIndex{
    _optionalVideoIndex = optionalVideoIndex;
}

-(void)replaceCurrentItemWithUrlString:(NSString*)urlString coverURL:(NSString *)coverUrl{
    if (urlString.length == 0 || urlString == nil)return;
    if ([self.currentVideoURL isEqualToString:urlString]){
        return;
    }
    [self resetPlayerViews];
    self.currentCoverURL = coverUrl;
    self.currentVideoURL = urlString;
    self.isCurrentVideo  = YES;
    NSNumber *progressNumber = [NSNumber numberWithFloat:0.0];
    NSNumber *alphaNumber = [NSNumber numberWithFloat:1.0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"progressValueChanged" object:nil userInfo:@{@"progress": progressNumber, @"alpha":alphaNumber}];
    [self.progressView setProgress:0.f];
    [self bingImageViewAdpterDataWithImageString:coverUrl];
    //判断本地是否已经有缓存数据
    NSURL * url = [NSURL URLWithString:urlString];
    if ([HTTPServerCacheManager isResourceExistsWithURL:url]){
        NSString * cacheURLString = [HTTPServerCacheManager getResourceCachePathByURL:urlString];
        NSURL * cacheURL = [NSURL fileURLWithPath:cacheURLString];
        self.videoURLAsset = [AVURLAsset assetWithURL:cacheURL];
        self.playerItem = [AVPlayerItem playerItemWithAsset:self.videoURLAsset];
        self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
        self.playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.playLayer.bounds   = self.renderView.bounds;
        self.playLayer.position = self.renderView.center;
        [self.renderView.layer addSublayer:self.playLayer];
    }else{
        HttpServerConnection * connection = [[HttpServerConnection alloc]init];
        connection.httpServerDelegate = self;
        [connection startConnectionWithURL:self.currentVideoURL];
        NSString * string = [NSString stringWithFormat:@"http:127.0.0.1:12345/%@",self.currentVideoURL.lastPathComponent];
        NSURL * httpServerURL = [NSURL URLWithString:string];
        self.videoURLAsset = [AVURLAsset URLAssetWithURL:httpServerURL options:nil];
        self.playerItem = [AVPlayerItem playerItemWithAsset:self.videoURLAsset];
        self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
        self.playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.playLayer.bounds   = self.renderView.bounds;
        self.playLayer.position = self.renderView.center;
        [self.renderView.layer addSublayer:self.playLayer];
    }
}

-(void)setPlayerItem:(AVPlayerItem *)playerItem{
    if ([_playerItem isEqual:playerItem])return;
    if (_playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        [self.playerItem removeObserver:self forKeyPath:@"playbackBufferFull"];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        if (self.timeObser) {
            @try {
                [self.player removeTimeObserver:self.timeObser];
                _timeObser = nil;
            }@catch(id anException){
            }
        }
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    [self addObserver];
    _playerItem = playerItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    [self.playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:AVPlayerItemStatusKey];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:AVPlayerItemPlaybackBufferEmpty];
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:AVPlayerItemPlaybackLikelyToKeepUp];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionNew context:AVPlayerItemPlaybackBufferFull];
}

-(void)bingImageViewAdpterDataWithImageString:(NSString*)coverUrl{
    [self.video_status_btn setSelected:YES];
    self.imageView.hidden = NO;
    if (![self.subviews containsObject:self.imageView]) {
        [self addSubview:self.imageView];
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:coverUrl]];
}

- (void)hidePreImageView{
    [UIView animateWithDuration:0.0 animations:^{
        self.imageView.hidden = YES;
        [self.imageView removeFromSuperview];
    } completion:^(BOOL finished) {
        self.renderView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:1.f];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    [self addgestures];
}

-(void)addgestures{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self addGestureRecognizer:tap1];
    self.tap1 = tap1;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail:tap2];
    [self addGestureRecognizer:tap2];
    self.tap2 = tap2;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.progressContainerView.frame = CGRectMake(0, SC_ScreenHeight-TX_WKG_RecommendBottomViewH, SC_ScreenWidth, 1);
    self.progressView.frame = CGRectMake(0, 0, SC_ScreenWidth, 1);
}

-(void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backGroundPauseMoive) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundPlayMoive) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)unregisterAllObserver{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferFull"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [self.player removeTimeObserver:self.timeObser];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferFull"];
    [self.player pause];
    [self.player cancelPendingPrerolls];
}

#pragma mark - setter 视频快进的进度
- (void)videoSeekTotolerenceWithProgress:(CGFloat)progressValue{
    CGFloat currentTime = CMTimeGetSeconds(self.player.currentTime);
    CGFloat value = round(currentTime);
    if (fabs(progressValue - value) < 0.1f)return;
    [_playerItem cancelPendingSeeks];
    CMTime seek = CMTimeMake(progressValue, 1);
    [self.player seekToTime:seek toleranceBefore:CMTimeMake(1,1) toleranceAfter:CMTimeMake(1,1) completionHandler:^(BOOL finished) {
        if (finished) {
            [self onVideoPlay];
        }
    }];
}
// 程序进入后台 >
- (void)backGroundPauseMoive {
    [self onVideoPause];
}
// 程序进入前台
- (void)enterForegroundPlayMoive {
    if (self.isCurrentVideo) {
        [self onVideoPlay];
    }
}
#pragma mark -NSNotification
-(void)playbackFinished:(NSNotification*)notification{
    if(self.isCurrentVideo) {
        [self.playerItem seekToTime:CMTimeMake(0, self.playerItem.duration.timescale)];
        [self.player play];
        self.isPlaying = YES;
        if (self.videoLoadComplete) {
            self.videoLoadComplete();
        }
    }
}

-(void)loadSubViewObjects{
    __weak typeof(self)weakSelf = self;
    [self addSubview:self.video_status_btn];
    [self.video_status_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == AVPlayerItemStatusKey) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            [self onVideoPlay];
            if (self.videoLoadComplete) {
                self.videoLoadComplete();
            }
            [self monitoringPlayback:self.player.currentItem];// 监听播放状态
        }else if((status == AVPlayerStatusUnknown)||(status == AVPlayerStatusFailed)){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self pauseVideo];
                if (self.videoLoadComplete) {
                    self.videoLoadComplete();
                }
                AVAsset * asset = self.player.currentItem.asset;
                if ([asset isKindOfClass:[AVURLAsset class]]) {
                    AVURLAsset * urlAsset = (AVURLAsset*)asset;
                    NSURL * url = urlAsset.URL;
                    if ([url.scheme hasPrefix:@"file"]) {
                        if ([HTTPServerCacheManager isResourceExistsWithURL:url]){
                            if ([HTTPServerCacheManager removeExistWithURL:url]) {}
                        }
                        [self loadNetWorkStreamWithVideoUrlString:self.currentVideoURL];
                    }else{
                        [self pauseVideo];
                    }
                }
            });
        }
    } else if (context == AVPlayerItemPlaybackBufferEmpty){
        if (self.player.currentItem.isPlaybackBufferEmpty) {
            if (self.videoLoading) {
                self.videoLoading();
            }
        }else{
            if (self.videoLoadComplete) {
                self.videoLoadComplete();
            }
        }
    }else if (context == AVPlayerItemPlaybackLikelyToKeepUp){
        if(self.player.currentItem.playbackLikelyToKeepUp)
        {
            if (self.videoLoadComplete) {
                self.videoLoadComplete();
            }
        }else{
            if (self.videoLoading) {
                self.videoLoading();
            }
        }
    }else if (context == AVPlayerItemPlaybackBufferFull){
        if (self.player.currentItem.isPlaybackBufferFull) {
            if (self.videoLoadComplete) {
                self.videoLoadComplete();
            }
        }else{
            if (self.videoLoading) {
                self.videoLoading();
            }
        }
    }else if (context == TX_WKG_AVPlayerTimeControlStatus){
        if ([self.player.reasonForWaitingToPlay isEqualToString:@"AVPlayerWaitingWhileEvaluatingBufferingRateReason"]
            ||[self.player.reasonForWaitingToPlay isEqualToString:@"AVPlayerWaitingWithNoItemToPlayReason"]
            ||[self.player.reasonForWaitingToPlay isEqualToString:@"AVPlayerWaitingToMinimizeStallsReason"]) {
            if (self.videoLoading) {
                self.videoLoading();
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)monitoringPlayback:(AVPlayerItem *)playerItem{
    __weak typeof(self)weakSelf = self;
    self.timeObser = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1,1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        CGFloat tiemValue = CMTimeGetSeconds(time);
        [strongSelf hidePreImageView];
        if (playerItem) {
            NSNumber *alphaNumber = @(1.f);
            if (strongSelf.video_status_btn.selected == YES) {
                CGFloat progress = tiemValue / (playerItem.duration.value/ playerItem.duration.timescale * 1.0f);
                if (strongSelf.observerProgressCallback) {
                    strongSelf.observerProgressCallback(progress);
                }
                [strongSelf.progressView setProgress:progress];
                NSNumber *progressNumber = @(progress);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"progressValueChanged" object:nil userInfo:@{@"progress": progressNumber, @"alpha":alphaNumber==nil? @(-1): alphaNumber}];
            }
        }
    }];
}

#pragma mark - HTTPServerConnectionDelegate
-(void)loader:(HttpServerConnection *)loader shouldPlay:(BOOL)play{
    if (self.isCurrentVideo == NO)return;
    if (self.isPlaying == YES)return;
    if (self.videoLoadComplete) {
        self.videoLoadComplete();
    }
    [self.player play];
}

-(void)loader:(HttpServerConnection *)loader complete:(BOOL)complete{
    if (self.isCurrentVideo == NO)return;
    if (self.isPlaying == YES)return;
    if (self.videoLoadComplete) {
        self.videoLoadComplete();
    }
    [self loadCacheDataWithVideoUrlString:self.currentVideoURL];
}

-(void)loader:(HttpServerConnection *)loader loading:(BOOL)loading{
    if (self.isCurrentVideo == NO)return;
    if (self.isPlaying == YES)return;
    if (self.videoLoading) {
        self.videoLoading();
    }
}

-(void)loader:(HttpServerConnection *)loader failLoadingWithError:(NSError *)error{
    [self loadNetWorkStreamWithVideoUrlString:self.currentVideoURL];
}

-(void)loadNetWorkStreamWithVideoUrlString:(NSString*)videoString{
    if (self.isCurrentVideo == NO)return;
    if (self.isPlaying == YES)return;
    if (self.videoLoadComplete) {
        self.videoLoadComplete();
    }
    [self resetPlayerViews];
    self.isCurrentVideo  = YES;
    NSNumber *progressNumber = [NSNumber numberWithFloat:0.0];
    NSNumber *alphaNumber = [NSNumber numberWithFloat:1.0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"progressValueChanged" object:nil userInfo:@{@"progress": progressNumber, @"alpha":alphaNumber}];
    [self.progressView setProgress:0.f];
    NSURL * url = [NSURL URLWithString:videoString];
    self.videoURLAsset = [[AVURLAsset alloc]initWithURL:url options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.videoURLAsset];
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    self.playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playLayer.bounds   = self.renderView.bounds;
    self.playLayer.position = self.renderView.center;
    [self.renderView.layer addSublayer:self.playLayer];
}

-(void)loadCacheDataWithVideoUrlString:(NSString*)videoString{
    if (self.isCurrentVideo == NO)return;
    if (self.isPlaying == YES)return;
    [self resetPlayerViews];
    self.isCurrentVideo  = YES;
    NSNumber *progressNumber = [NSNumber numberWithFloat:0.0];
    NSNumber *alphaNumber = [NSNumber numberWithFloat:1.0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"progressValueChanged" object:nil userInfo:@{@"progress": progressNumber, @"alpha":alphaNumber}];
    [self.progressView setProgress:0.f];
    NSString * cacheURLString = [HTTPServerCacheManager getResourceCachePathByURL:videoString];
    NSURL * cacheURL   = [NSURL fileURLWithPath:cacheURLString];
    self.videoURLAsset = [AVURLAsset assetWithURL:cacheURL];
    self.playerItem    = [AVPlayerItem playerItemWithAsset:self.videoURLAsset];
    self.player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    self.playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playLayer.bounds   = self.renderView.bounds;
    self.playLayer.position = self.renderView.center;
    [self.renderView.layer addSublayer:self.playLayer];
}

@end
