//
//  VideoPlayerView.m
//  AnFengHelper
//
//  Created by 吴可高 on 2018/7/14.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "VideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>
@interface VideoPlayerView()
@property(nonatomic,strong) UIView * renderView;
@property(nonatomic,strong) AVPlayerLayer * playerLayer;
@property(nonatomic,strong) AVPlayer * player;
@property(nonatomic,strong) AVPlayerItem * playItem;
@property(nonatomic,strong) id timerObserver;
@property(nonatomic,copy) NSString * currentVideo;
@property(nonatomic,assign) BOOL  isRemoveCoverImageView;
@end

@implementation VideoPlayerView
#pragma mark - public methods
-(void)stopVideo{
    if (self.player) {
        [self.player pause];
    }
}

#pragma mark - getter methods
-(UIView *)renderView{
    _renderView = ({
        if (!_renderView) {
             _renderView = [[UIView alloc]initWithFrame:CGRectZero];
             _renderView.backgroundColor = [UIColor clearColor];
        }
        _renderView;
    });
    return _renderView;
}

-(AVPlayerLayer *)playerLayer{
    _playerLayer =({
        if (!_playerLayer) {
             _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        }
        _playerLayer;
    });
    return _playerLayer;
}
-(AVPlayer *)player{
    _player = ({
        if (!_player) {
            _player = [[AVPlayer alloc]init];
        }
        _player;
    });
    return _player;
}
-(void)dealloc{
    [self.player removeObserver:self forKeyPath:@"status"];
    [self.player removeObserver:self forKeyPath:@"loadedTimeRanges"];
    if (self.timerObserver) {
        [self.player removeTimeObserver:self.timerObserver];
        _timerObserver = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self addNotification];
    }
    return self;
}
-(void)setVideo:(NSString*)videoURL{
    if (videoURL.length == 0 || videoURL == nil)return;
    if ([self.currentVideo isEqualToString:videoURL]){
        [self.player play];
        return;
    };
    self.currentVideo = videoURL;
    self.isRemoveCoverImageView = NO;
    NSURL * url = [NSURL URLWithString:videoURL];
    AVPlayerItem * item = [[AVPlayerItem alloc]initWithURL:url];
    self.playItem = item;
    if (self.player == nil) {
        self.player = [[AVPlayer alloc]initWithPlayerItem:self.playItem];
    }else{
        [self.player replaceCurrentItemWithPlayerItem:self.playItem];
    }
}

-(void)setup{
    __weak typeof(self)weakSelf = self;
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.renderView];
    [self.renderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsZero);
    }];
    [self.renderView.layer addSublayer:self.playerLayer];
     self.playerLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
     self.playerLayer.position = CGPointMake(CGRectGetWidth(self.frame)/2.f, CGRectGetHeight(self.frame)/2.f);
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)setPlayItem:(AVPlayerItem *)playItem{
    if (playItem == nil)return;
    if ([_playItem isEqual:playItem])return;
    if (_playItem) {
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playItem];
        [_playItem removeObserver:self forKeyPath:@"status"];
        [_playItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    }
    _playItem = playItem;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(itemDidPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playItem];
    [self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)itemDidPlayEnd:(NSNotification*)notification{
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}

-(void)appDidEnterBackground:(NSNotification*)notification{
    
}
-(void)appDidBecomeActive:(NSNotification*)notification{
    
}

-(void)monitorPlayerStatus:(AVPlayerItem*)playerItem{
    if (playerItem == nil)return;
    __weak typeof(self)weakSelf = self;
    self.timerObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (self.isRemoveCoverImageView == NO) {
            if (strongSelf.removeCoverImageViewCallback) {
                strongSelf.removeCoverImageViewCallback(YES);
            }
            strongSelf.isRemoveCoverImageView = YES;
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        if (self.player.currentItem.status == AVPlayerStatusReadyToPlay) {
            [self.player play];
            [self monitorPlayerStatus:self.player.currentItem];
        }else{
            [self.player pause];
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
