//
//  RechargeViewController.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "RechargeViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "TEST1ViewController.h"
#import "TESTNavigationController.h"

@interface RechargeViewController ()
@property(nonatomic,strong) AVPlayer *  player;
@property(nonatomic,strong) AVPlayerItem  * playerItem;
@property(nonatomic,strong) AVPlayerLayer * playLayer;
@property(nonatomic,strong) UIButton * play_status_btn;
@property (nonatomic ,strong)  id timeObser;
@property(nonatomic,strong) UIButton * play_rotate_btn;
@property(nonatomic,strong) UIView * renderView;
@property(nonatomic,strong) UIButton * video_status_btn;
@property(nonatomic,copy) NSString * videoRotateStatusString;
@property(nonatomic,weak) TEST1ViewController * test1VC;
@property (assign, nonatomic) UIInterfaceOrientation  toInterfaceOrientation;

@end

void * AVPlayerItemStatusKey = &AVPlayerItemStatusKey;
void * AVPlayerItemLoadTimeRangesKey = &AVPlayerItemLoadTimeRangesKey;

@implementation RechargeViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    TEST1ViewController * testVC = [TEST1ViewController new];
    self.test1VC = testVC;
    [self.navigationController pushViewController:self.test1VC animated:YES];
}

#pragma mark -IBOutlet Events
-(void)videoPlayStatus:(UIButton*)args{
    args.selected = !args.selected;
    if (args.selected) {
        [self onVideoPlay];
    }else{
        [self onVideoPause];
    }
}


-(void)videoRotate:(UIButton*)args{
	self.renderView.transform = CGAffineTransformMakeRotation(M_PI);
	NSLog(@"self.renderView.frame =%@",NSStringFromCGRect(self.renderView.frame));
    if ([self.videoRotateStatusString isEqualToString:@"NO"]) {
		if ([[UIDevice currentDevice]respondsToSelector:@selector(setOrientation:)]) {
			SEL selector = NSSelectorFromString(@"setOrientation:");
		    NSMethodSignature * signature = [UIDevice instanceMethodSignatureForSelector:selector];
			NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
			[invocation setSelector:selector];
			[invocation setTarget:[UIDevice currentDevice]];
			UIInterfaceOrientation orientation =  UIInterfaceOrientationLandscapeRight;
			[invocation setArgument:&orientation atIndex:2];
			[invocation invoke];
		}
        self.videoRotateStatusString = @"YES";
        self.renderView.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.9f];
    }else{
        self.renderView.transform = CGAffineTransformIdentity;
        self.videoRotateStatusString = @"NO";
        self.renderView.frame = self.view.bounds;
        self.renderView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.9f];
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

-(void)videoPlay:(UIButton*)args{
    NSURL * url = [NSURL URLWithString:@"http://oss-cn-hangzhou.aliyuncs.com/tsnrhapp/shop/videos/outputCut.mp4"];
    AVAsset * asset = [AVAsset assetWithURL:url];
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    [self.playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:AVPlayerItemStatusKey];
    [self.playerItem addObserver:self forKeyPath:@"loadTimeRanges" options:NSKeyValueObservingOptionNew context:AVPlayerItemLoadTimeRangesKey];
}

-(void)onVideoPlay{
    [self.video_status_btn setSelected:YES];
    [self.player play];
}

-(void)onVideoPause{
    [self.video_status_btn setSelected:NO];
    [self.player pause];
}

#pragma mark -renderView
-(UIButton *)video_status_btn{
    _video_status_btn = ({
        if (!_video_status_btn) {
            _video_status_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_video_status_btn setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
            [_video_status_btn setImage:[UIImage imageNamed:@"Stop"] forState:UIControlStateSelected];
            [_video_status_btn addTarget:self action:@selector(videoPlayStatus:) forControlEvents:UIControlEventTouchUpInside];
        }
        _video_status_btn;
    });
    return _video_status_btn;
}

-(UIView *)renderView{
    _renderView = ({
        if (!_renderView) {
            _renderView = [[UIView alloc]initWithFrame:CGRectZero];
            _renderView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.9f];
        }
        _renderView;
    });
    return _renderView;
}
#pragma mark - AVPlayer
-(UIButton *)play_status_btn{
    _play_status_btn = ({
        if (!_play_status_btn) {
            _play_status_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_play_status_btn setTitle:@"播放" forState:UIControlStateNormal];
            [_play_status_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_play_status_btn setBackgroundColor:AdapterColor(200, 200, 200)];
            _play_status_btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
            _play_status_btn.layer.masksToBounds = YES;
            _play_status_btn.layer.cornerRadius = APPAdapterScaleWith(8.f);
            [_play_status_btn addTarget:self action:@selector(videoPlay:) forControlEvents:UIControlEventTouchUpInside];
        }
        _play_status_btn;
    });
    return _play_status_btn;
}
-(UIButton *)play_rotate_btn{
    _play_rotate_btn = ({
        if (!_play_rotate_btn) {
            _play_rotate_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_play_rotate_btn setTitle:@"旋转" forState:UIControlStateNormal];
            [_play_rotate_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_play_rotate_btn setBackgroundColor:AdapterColor(200, 200, 200)];
            _play_rotate_btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
            _play_rotate_btn.layer.masksToBounds = YES;
            _play_rotate_btn.layer.cornerRadius = APPAdapterScaleWith(8.f);
            [_play_rotate_btn addTarget:self action:@selector(videoRotate:) forControlEvents:UIControlEventTouchUpInside];
        }
        _play_rotate_btn;
    });
    return _play_rotate_btn;
}

-(AVPlayerItem *)playerItem{
    _playerItem = ({
        if (!_playerItem) {
            NSURL * url = [NSURL URLWithString:@"http://oss-cn-hangzhou.aliyuncs.com/tsnrhapp/a23d894a-666b-4091-b49d-1df08411cf4e.mp4"];
            _playerItem = [[AVPlayerItem alloc]initWithURL:url];
        }
        _playerItem;
    });
    return _playerItem;
}

-(AVPlayer *)player{
    _player = ({
        if (!_player) {
            _player = [[AVPlayer alloc]initWithPlayerItem:self.playerItem];
        }
        _player;
    });
    return _player;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	self.toInterfaceOrientation = toInterfaceOrientation;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	if (self.toInterfaceOrientation == UIInterfaceOrientationPortrait
		|| self.toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		[self.play_status_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.size.mas_equalTo(CGSizeMake(60, 30));
			make.top.mas_equalTo(self.view.mas_top).with.offset(30.f);
			make.right.mas_equalTo(self.view.mas_right).with.offset(-APPAdapterScaleWith(10.f));
		}];
		[self.play_rotate_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.size.mas_equalTo(CGSizeMake(60, 30));
			make.top.mas_equalTo(self.view.mas_top).with.offset(30.f);
			make.left.mas_equalTo(self.view.mas_left).with.offset(APPAdapterScaleWith(10.f));
		}];
		self.renderView.transform = CGAffineTransformIdentity;
		self.renderView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame));
		self.playLayer.bounds = self.renderView.bounds;
		self.playLayer.position = self.renderView.center;
	}else{
		[self.play_status_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.size.mas_equalTo(CGSizeMake(60, 30));
			make.top.mas_equalTo(self.view.mas_top).with.offset(30.f);
			make.left.mas_equalTo(self.view.mas_left).with.offset(APPAdapterScaleWith(10.f));
		}];
		[self.play_rotate_btn mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.size.mas_equalTo(CGSizeMake(60, 30));
			make.top.mas_equalTo(self.view.mas_top).with.offset(30.f);
			make.right.mas_equalTo(self.view.mas_right).with.offset(-APPAdapterScaleWith(10.f));
		}];
//		self.renderView.transform = CGAffineTransformRotate(self.renderView.transform, M_PI_2);
		self.renderView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
		self.playLayer.bounds = self.renderView.bounds;
		self.playLayer.position = self.renderView.center;
		
	}
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration{
	
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.renderView.frame = self.view.bounds;
    [self.view addSubview:self.renderView];
    self.playLayer.bounds = self.renderView.bounds;
    self.playLayer.position = self.renderView.center;
    [self.renderView.layer addSublayer:self.playLayer];
    [self loadSubViewObjects];
    self.videoRotateStatusString = @"NO";
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(willOritentationEvents:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didOritentationEvents:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

}

-(void)willOritentationEvents:(NSNotification*)notification{
	
}
-(void)didOritentationEvents:(NSNotification*)notification{
	
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self.playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:AVPlayerItemStatusKey];
    [self.playerItem addObserver:self forKeyPath:@"loadTimeRanges" options:NSKeyValueObservingOptionNew context:AVPlayerItemLoadTimeRangesKey];
    self.timeObser = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1,1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//        CGFloat tiemValue = CMTimeGetSeconds(time);
//		NSLog(@"time.value = %2.f timeScale = %d \n",tiemValue,time.timescale);
    }];
}

#pragma mark -NSNotification
-(void)playbackFinished:(NSNotification*)notification{
    [self.playerItem seekToTime:CMTimeMake(0, self.playerItem.duration.timescale)];
    [self.player play];
}

-(void)loadSubViewObjects{
    __weak typeof(self)weakSelf = self;
    [self.view addSubview:self.play_status_btn];
    [self.play_status_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(30.f);
        make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(-APPAdapterScaleWith(10.f));
    }];
    [self.view addSubview:self.play_rotate_btn];
    [self.play_rotate_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(30.f);
    make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(APPAdapterScaleWith(10.f));
    }];
    [self.view addSubview:self.video_status_btn];
    [self.video_status_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.view.mas_centerY);
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadTimeRanges"];
    [self.player removeTimeObserver:self.timeObser];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == AVPlayerItemStatusKey) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            [self onVideoPlay];
        }
    } else if(context == AVPlayerItemLoadTimeRangesKey){
        //获取视频的缓存时间
      CGFloat duration = CMTimeGetSeconds(self.playerItem.duration);
        //获取item的缓冲数据
        NSArray * loadTimeRanges  = self.playerItem.loadedTimeRanges;
      CMTimeRange timeRange = [loadTimeRanges.firstObject CMTimeRangeValue];
      float startSeconds = CMTimeGetSeconds(timeRange.start);
      float durationSeconds = CMTimeGetSeconds(timeRange.duration);
      NSTimeInterval result = startSeconds + durationSeconds;
      NSLog(@"result = %.2f duration = %.2f",result,duration);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
