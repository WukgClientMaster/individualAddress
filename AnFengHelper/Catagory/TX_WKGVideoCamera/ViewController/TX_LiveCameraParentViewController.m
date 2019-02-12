//
//  TX_LiveCameraParentViewController.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/25.
//  Copyright © 2018年 NRH. All rights reserved.
//
#import <TXLiteAVSDK_Professional/TXLiveSDKTypeDef.h>
#import <TXLiteAVSDK_Professional/TXVideoEditer.h>
#import "TX_LiveCameraParentViewController.h"
#import "VideoConfigure.h"

#import "TX_LivePushStreamViewController.h"
#import "TX_WKGVideoCameraController.h"
#import "TX_ParentOptionalView.h"
#import "TX_ParentContentView.h"

@interface TX_LiveCameraParentViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) VideoConfigure * videoConfigure;
@property (strong, nonatomic) UIScrollView * viewContainer;
@property (strong,readwrite,nonatomic) UIView * live_renderView;
@property (strong,readwrite,nonatomic) UIView * camera_renderView;
@property (strong, nonatomic) TX_ParentOptionalView * optionalView;
@property (strong, nonatomic) UIViewController * currentSubViewController;
@property (strong, nonatomic) TX_WKGVideoCameraController * videoCameraVC;
@property (strong, nonatomic) TX_LivePushStreamViewController * livePushStreamVC;
@property (assign, nonatomic) NSInteger lastScrollIndex;
@property (strong,readwrite,nonatomic) TXLivePush * txLivePush;


@end

@implementation TX_LiveCameraParentViewController
#pragma mark - getter methods
#pragma mark - Setter/Getter
- (TXLivePush *)txLivePush {
    if (_txLivePush == nil) {
        TXLivePushConfig *config = [[TXLivePushConfig alloc] init];
        // 300 为后台播放暂停图片的最长持续时间,单位是秒
        config.pauseTime = 300;
        // 10 为后台播放暂停图片的帧率,最小值为5,最大值为20
        config.pauseFps = 10;
        // 设置推流暂停时,后台播放的暂停图片, 图片最大尺寸不能超过1920*1920.
        config.pauseImg = PPImage(@"pause_publish");
        // 自动码率
        config.enableAutoBitrate = YES;
        // 设置视频分辨率
        config.videoResolution = VIDEO_RESOLUTION_TYPE_720_1280;
        // 开启硬件加速器，iOS8以上默认打开
        config.enableHWAcceleration = YES;
        // 水印图片
        config.watermark = PPImage(@"live_watermark");
        // 水印位置
        //config.watermarkPos = CGPointMake(20, 20);
        config.watermarkNormalization = CGRectMake(0.02, 0.05, 0.2, 0);
        // 开启回音消除
        config.enableAEC = YES;
        // 推流地址为腾讯云地址
        config.enableNearestIP = YES;
        
        _txLivePush = [[TXLivePush alloc] initWithConfig:config];
        // 设置画质
        [_txLivePush setVideoQuality:VIDEO_QUALITY_SUPER_DEFINITION adjustBitrate:YES adjustResolution:NO];
        // 如果是前置摄像头设置镜像
        [_txLivePush setMirror:config.frontCamera];
        // 静音关闭
        [_txLivePush setMute:NO];
        // 录制代理
        _txLivePush.recordDelegate = self.livePushStreamVC;
        // 推流代理
        _txLivePush.delegate = self.livePushStreamVC;
        // 初始化美颜
        [_txLivePush setBeautyStyle:2
                        beautyLevel:3
                     whitenessLevel:4
                     ruddinessLevel:5];
    }
    return _txLivePush;
}

-(void)startCameraPreview{
    VideoConfigure * videoConfigure = [VideoConfigure new];
    videoConfigure.videoResolution  = VIDEO_RESOLUTION_720_1280;
    videoConfigure.videoRatio = VIDEO_ASPECT_RATIO_9_16;
    videoConfigure.bps = 2400;
    videoConfigure.fps = 20;
    videoConfigure.gop = 3;
    self.videoConfigure = videoConfigure;
    TXUGCCustomConfig * param = [[TXUGCCustomConfig alloc] init];
    param.videoResolution =  self.videoConfigure.videoResolution;
    param.videoFPS = self.videoConfigure.fps;
    param.videoBitratePIN = self.videoConfigure.bps;
    param.GOP = self.videoConfigure.gop;
    param.minDuration = 1;
    param.maxDuration = 10;
    if ([[TXUGCRecord shareInstance] startCameraCustom:param preview:self.camera_renderView] != 0) {
        [[TXUGCRecord shareInstance]setZoom:1];
        [[TXUGCRecord shareInstance] startCameraCustom:param preview:self.camera_renderView];
    }
    NSString * path = [[NSBundle mainBundle] pathForResource:@"FilterResource" ofType:@"bundle"];
    if (path != nil) {
        path = [path stringByAppendingPathComponent:@
                "qingliang.png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [[TXUGCRecord shareInstance] setFilter:image];
    }
    [[TXUGCRecord shareInstance] setAspectRatio:VIDEO_ASPECT_RATIO_9_16];
    [[TXUGCRecord shareInstance] setBeautyStyle:0 beautyLevel:6.f whitenessLevel:5.f ruddinessLevel:2.f];
}

-(TX_ParentOptionalView *)optionalView{
    _optionalView = ({
        if (!_optionalView) {
            _optionalView = [[TX_ParentOptionalView alloc]initWithFrame:CGRectZero];
            __weak typeof(self)weakSelf = self;
            _optionalView.block = ^(NSString *title) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                if ([title isEqualToString:@"拍照"]) {
                    [strongSelf.viewContainer setContentOffset:CGPointZero];
                }else if([title isEqualToString:@"直播"]){
                    [strongSelf.viewContainer setContentOffset:CGPointMake(KScreenWidth, 0)];
                }
            };
        }
        _optionalView;
    });
    return _optionalView;
}

-(UIView *)live_renderView{
    _live_renderView = ({
        if (!_live_renderView) {
            _live_renderView = [[UIView alloc]initWithFrame:CGRectZero];
        }
        _live_renderView;
    });
    return _live_renderView;
}

-(UIView *)camera_renderView{
    _camera_renderView = ({
        if (!_camera_renderView) {
            _camera_renderView = [[UIView alloc]initWithFrame:CGRectZero];
        }
        _camera_renderView;
    });
    return _camera_renderView;
}

-(UIScrollView *)viewContainer{
    _viewContainer = ({
        if (!_viewContainer) {
            _viewContainer = [[UIScrollView alloc]initWithFrame:CGRectZero];
            _viewContainer.pagingEnabled = YES;
            _viewContainer.backgroundColor = [UIColor clearColor];
            _viewContainer.showsVerticalScrollIndicator = NO;
            _viewContainer.showsHorizontalScrollIndicator = NO;
            _viewContainer.delegate = self;
            _viewContainer.contentSize = CGSizeMake(KScreenWidth * 2.f, KScreenHeight);
        }
        _viewContainer;
    });
    return _viewContainer;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.txLivePush startPreview:self.live_renderView];
    [self startCameraPreview];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)topButtonsDidClickedAtIndex:(NSInteger)index {
    UIViewController *selectedController = self.childViewControllers[index];
    selectedController.view.frame = self.viewContainer.bounds;
    if (self.currentSubViewController != self.childViewControllers[index]) {
        [self transitionFromViewController:self.currentSubViewController toViewController:self.childViewControllers[index] duration:0.8 options:UIViewAnimationOptionTransitionCurlUp animations:^{} completion:^(BOOL finished) {
            if (finished) {
                self.currentSubViewController = self.childViewControllers[index];
            }
        }];
    }
}

-(void)loadView{
    TX_ParentContentView * contentView = [[TX_ParentContentView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewContainer.frame = self.view.bounds;
    [self.view addSubview:self.viewContainer];
    self.lastScrollIndex = 0;
    self.camera_renderView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    self.live_renderView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self.view insertSubview:self.camera_renderView atIndex:0];
    [self.view insertSubview:self.live_renderView belowSubview:self.camera_renderView];
    self.optionalView.frame = CGRectMake(0, KScreenHeight - 50, KScreenWidth, 50);
    [self.view addSubview:self.optionalView];
    // 添加几个子viewController
    self.videoCameraVC = [[TX_WKGVideoCameraController alloc]init];
    self.videoCameraVC.parentViewController = self;
    
    self.livePushStreamVC = [[TX_LivePushStreamViewController alloc]init];
    self.livePushStreamVC.parentViewController = self;
    [self addChildViewController:self.videoCameraVC];
    [self addChildViewController:self.livePushStreamVC];
    // 预先设置初始显示的页面,不要忘记设置frame适应容器view的大小
    self.childViewControllers[0].view.frame = self.viewContainer.bounds;
    self.childViewControllers[1].view.frame = CGRectMake(KScreenWidth, 0, KScreenWidth, KScreenHeight);
    [self.viewContainer addSubview:self.childViewControllers[0].view];
    [self.viewContainer addSubview:self.childViewControllers[1].view];
    self.currentSubViewController = self.childViewControllers[0];
}

#pragma mark - UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //改变文字和图片UI
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat tempF = offsetX/(self.view.bounds.size.width*1.0);
    if (tempF == floorf(tempF)) {
        [self autoScrollToIndex:floorf(tempF)];
    }
}

-(void)autoScrollToIndex:(NSInteger)index{
    if (self.lastScrollIndex == index) return;
    self.lastScrollIndex = index;
    [self.optionalView scrollToIndex:index];
    if (index == 0) {
        [self.txLivePush stopPreview];
        [self.view insertSubview:self.camera_renderView aboveSubview:self.live_renderView];
        [self startCameraPreview];
    }else if (index == 1){
        [[TXUGCRecord shareInstance]stopCameraPreview];
        [self.view insertSubview:self.live_renderView aboveSubview:self.camera_renderView];
        [self.txLivePush startPreview:self.live_renderView];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
