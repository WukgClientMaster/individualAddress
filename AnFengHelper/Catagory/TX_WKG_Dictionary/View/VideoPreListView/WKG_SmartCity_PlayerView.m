//
//  WKG_SmartCity_PlayerView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/7/11.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "WKG_SmartCity_PlayerView.h"
#import "TX_WKG_Video_PreView_ProgressView.h"

@interface WKG_SmartCity_PlayerView ()
@property (strong,readwrite,nonatomic) TX_WKG_Video_PreView_ProgressView * progressView;
@property (strong, nonatomic) UIView *progressContainerView;
@property (weak, nonatomic)   UITapGestureRecognizer *tap1;
@property (strong, nonatomic) UIImageView *imageView;

@property(nonatomic,strong) AVPlayer *  player;
@property(nonatomic,strong) AVPlayerItem  * playerItem;
@property(nonatomic,strong) AVPlayerLayer * playLayer;
@property(strong,nonatomic) AVURLAsset  *videoURLAsset;
@property(nonatomic,strong) UIButton    * video_status_btn;
@property(nonatomic,strong) id timeObser;
@property(nonatomic,strong) UIView * renderView;
@property (copy, nonatomic) NSString * currentVideoURL;
@property (copy, nonatomic) NSString * currentCoverURL;
@property (copy, nonatomic) UIImage  * currentVideoImage;

@property (assign, nonatomic) BOOL  isPlaying;
@property (assign, nonatomic) BOOL isCurrentVideo;
@property (strong, nonatomic) UIImage * placeholderImage;

@end

void * __AVPlayerItemStatusKey = &__AVPlayerItemStatusKey;
void * __AVPlayerItemPlaybackBufferEmpty = &__AVPlayerItemPlaybackBufferEmpty;
void * __AVPlayerItemPlaybackLikelyToKeepUp = &__AVPlayerItemPlaybackLikelyToKeepUp;
void * __AVPlayerItemPlaybackBufferFull = &__AVPlayerItemPlaybackBufferFull;
void * __TX_WKG_AVPlayerTimeControlStatus = &__TX_WKG_AVPlayerTimeControlStatus;

@implementation WKG_SmartCity_PlayerView

- (void)playVideo{
    if (self.isCurrentVideo) {
        [self.video_status_btn setSelected:YES];
        [self.player play];
        self.isPlaying = YES;
        [self.progressView setHidden:NO];
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
#pragma mark - getter methods
-(TX_WKG_Video_PreView_ProgressView *)progressView{
    _progressView = ({
        if (!_progressView) {
             _progressView = [[TX_WKG_Video_PreView_ProgressView alloc]initWithFrame:CGRectZero];
            [_progressView setZoomScaleType:(TX_WKG_VIDEO_PREVIEW_ZOOM_SCALE_NONE)];
            __weak typeof(self)weakSelf = self;
            _progressView.autoprogressCallback = ^(NSDictionary *optjson) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                if ([optjson[@"type"] isEqualToString:@"进度"]) {
                    NSNumber * number = optjson[@"value"];
                    [strongSelf videoSeekTotolerenceWithProgress:[number floatValue]];
                }
            };
        }
        _progressView;
    });
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
    if (!self.isCurrentVideo){return;}
    self.video_status_btn.selected = !self.video_status_btn.selected;
    if (self.video_status_btn.selected) {
        [self onVideoPlay];
    }else {
        [self onVideoPause];
    }
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
    [self.video_status_btn setSelected:YES];
    [self.player play];
    self.isPlaying = YES;
    [self.progressView setHidden:YES];
}

-(void)onVideoPause{
    [self.video_status_btn setSelected:NO];
    [self.player pause];
    self.isPlaying = NO;
    [self.progressView setHidden:NO];
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
    [self.renderView removeFromSuperview];
    [self.playLayer removeFromSuperlayer];
    [self.video_status_btn removeFromSuperview];
    [self.progressContainerView  removeFromSuperview];
    [self.progressView removeFromSuperview];
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
    }];
    [self.video_status_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
    }];
    [self unregisterAllObserver];
    self.renderView.frame = CGRectMake(0, 0, KScreenWidth,KScreenHeight);
    self.renderView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:1.f];
    [self addSubview:self.renderView];
    [self loadSubViewObjects];
}

- (UIImage*)createImageWithColor:(UIColor*)color{
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.placeholderImage = theImage;
    return theImage;
}

//播放网络地址
-(void)setVideoPlayerWithURL:(NSString*)videoURL cover:(NSString*)coverString{
    if (videoURL.length == 0 || videoURL == nil)return;
    if ([self.currentVideoURL isEqualToString:videoURL]){
        return;
    }
    [self resetPlayerViews];
    if (![[self subviews]containsObject:self.progressView]) {
        __weak typeof(self)weakSelf = self;
        [self addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(-widthEx(8.f));
            make.height.mas_equalTo(@(widthEx(40.f)));
        }];
    }
    [self.progressView setHidden:YES];
    self.currentVideoImage = nil;
    self.currentCoverURL = coverString;
    self.currentVideoURL = videoURL;
    self.isCurrentVideo  = YES;
    NSURL * httpServerURL = [NSURL URLWithString:self.currentVideoURL];
    [self.progressView setVideoDurationWithUrl:httpServerURL];
    [self bingImageViewAdpterDataWithImageString:self.currentCoverURL];
    self.videoURLAsset = [AVURLAsset URLAssetWithURL:httpServerURL options:nil];
    self.playerItem    = [AVPlayerItem playerItemWithAsset:self.videoURLAsset];
    self.player        = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    self.playLayer     = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playLayer.bounds   = self.renderView.bounds;
    self.playLayer.position = self.renderView.center;
    [self.renderView.layer addSublayer:self.playLayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    [self.playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:__AVPlayerItemStatusKey];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:__AVPlayerItemPlaybackBufferEmpty];
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:__AVPlayerItemPlaybackLikelyToKeepUp];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionNew context:__AVPlayerItemPlaybackBufferFull];
}
//播放本地视频
-(void)setVideoPlayerWithFileURL:(NSString*)fileURL cover:(UIImage*)coverImage{
    if (fileURL.length == 0 || fileURL == nil)return;
    if ([self.currentVideoURL isEqualToString:fileURL]){
        return;
    }
    [self resetPlayerViews];
    if (![[self subviews]containsObject:self.progressView]) {
        __weak typeof(self)weakSelf = self;
        [self addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(-widthEx(8.f));
            make.height.mas_equalTo(@(widthEx(40.f)));
        }];
    }
    [self.progressView setHidden:YES];
    self.currentCoverURL = nil;
    self.currentVideoURL = fileURL;
    self.currentVideoImage = coverImage;
    self.isCurrentVideo  = YES;
    //
    self.imageView.hidden = NO;
    [self.video_status_btn setSelected:YES];
    self.imageView.image = self.currentVideoImage;
    //
    NSURL * httpServerURL = [NSURL fileURLWithPath:self.currentVideoURL];
    [self.progressView setVideoDurationWithUrl:httpServerURL];
    self.videoURLAsset = [AVURLAsset URLAssetWithURL:httpServerURL options:nil];
    self.playerItem    = [AVPlayerItem playerItemWithAsset:self.videoURLAsset];
    self.player        = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    self.playLayer     = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playLayer.bounds   = self.renderView.bounds;
    self.playLayer.position = self.renderView.center;
    [self.renderView.layer addSublayer:self.playLayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    [self.playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:__AVPlayerItemStatusKey];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:__AVPlayerItemPlaybackBufferEmpty];
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:__AVPlayerItemPlaybackLikelyToKeepUp];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionNew context:__AVPlayerItemPlaybackBufferFull];
}

//播放本地视频
-(void)setVideoPlayerWithLocalURL:(NSURL*)fileURL cover:(UIImage*)coverImage{
    
    if (fileURL.scheme.length == 0 || fileURL == nil)return;
    if ([self.currentVideoURL isEqual:fileURL]){
        return;
    }
    [self resetPlayerViews];
    if (![[self subviews]containsObject:self.progressView]) {
        __weak typeof(self)weakSelf = self;
        [self addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(-widthEx(8.f));
            make.height.mas_equalTo(@(widthEx(40.f)));
        }];
    }
    [self.progressView setHidden:YES];
    self.currentCoverURL = nil;
    self.currentVideoImage = coverImage;
    self.isCurrentVideo  = YES;
    //
    self.imageView.hidden = NO;
    [self.video_status_btn setSelected:YES];
    self.imageView.image = self.currentVideoImage;
    //
    NSURL * httpServerURL = fileURL;
    [self.progressView setVideoDurationWithUrl:httpServerURL];
    self.videoURLAsset = [AVURLAsset URLAssetWithURL:httpServerURL options:nil];
    self.playerItem    = [AVPlayerItem playerItemWithAsset:self.videoURLAsset];
    self.player        = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
    self.playLayer     = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playLayer.bounds   = self.renderView.bounds;
    self.playLayer.position = self.renderView.center;
    [self.renderView.layer addSublayer:self.playLayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    [self.playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:__AVPlayerItemStatusKey];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:__AVPlayerItemPlaybackBufferEmpty];
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:__AVPlayerItemPlaybackLikelyToKeepUp];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionNew context:__AVPlayerItemPlaybackBufferFull];
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
}

-(void)bingImageViewAdpterDataWithImageString:(NSString*)coverUrl{
    self.imageView.hidden = NO;
    self.placeholderImage = self.placeholderImage;
    if (![self.subviews containsObject:self.imageView]) {
        [self addSubview:self.imageView];
    }
    [self.video_status_btn setSelected:YES];
    NSURL * url = [Tools ossHandleImageWithUrl:coverUrl type:(OssImageHandleTypeMinFit) size:CGSizeMake(100, KScreenHeight* 1.f / kScreenWidth  * 100)];
    [self.imageView sd_setImageWithURL:url placeholderImage:self.placeholderImage];
}

- (void)hidePreImageView{
    self.imageView.hidden = YES;
    self.renderView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:1.f];
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
}

-(void)layoutSubviews{
    [super layoutSubviews];
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
    if (context == __AVPlayerItemStatusKey) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            [self onVideoPlay];
            [self monitoringPlayback:self.player.currentItem];// 监听播放状态
        }else if((status == AVPlayerStatusUnknown)||(status == AVPlayerStatusFailed)){
           
            [self pauseVideo];
        }
    } else if (context == __AVPlayerItemPlaybackBufferEmpty){
        
    }else if (context == __AVPlayerItemPlaybackLikelyToKeepUp){
        
    }else if (context == __AVPlayerItemPlaybackBufferFull){

    }else if (context == __TX_WKG_AVPlayerTimeControlStatus){
        if ([self.player.reasonForWaitingToPlay isEqualToString:@"AVPlayerWaitingWhileEvaluatingBufferingRateReason"]
            ||[self.player.reasonForWaitingToPlay isEqualToString:@"AVPlayerWaitingWithNoItemToPlayReason"]
            ||[self.player.reasonForWaitingToPlay isEqualToString:@"AVPlayerWaitingToMinimizeStallsReason"]) {
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)monitoringPlayback:(AVPlayerItem *)playerItem{
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hidePreImageView];
    });
    self.timeObser = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1,1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        CGFloat tiemValue = CMTimeGetSeconds(time);
        if (playerItem) {
            if (strongSelf.video_status_btn.selected == YES) {
                CGFloat progress = tiemValue / (playerItem.duration.value/ playerItem.duration.timescale * 1.0f);
                [strongSelf setProgressViewsWithProgress:progress];
            }
        }
    }];
}

-(void)setProgressViewsWithProgress:(CGFloat)progress{
    [self.progressView setVideoPlayProgress:progress];
}

@end
