	//
	//  TX_WKG_VideoPreViewController.m
	//  SmartCity
	//
	//  Created by 智享城市iOS开发 on 2018/4/13.
	//  Copyright © 2018年 NRH. All rights reserved.
	//

#import "TX_WKG_VideoPreViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <TXLiteAVSDK_Professional/TXVodPlayer.h>
#import "MusicInfo.h"
#import <TXLiteAVSDK_Professional/TXVideoEditer.h>
#import <TXLiteAVSDK_Professional/TXLiveBase.h>
#import "VideoPreview.h"
#import "AppLogMgr.h"

@interface TX_WKG_VideoPreViewController ()<TXVideoGenerateListener,TXVideoPreviewListener,VideoPreviewDelegate>{
	UIImage *                       _coverImage;
	NSString*                       _videoPath;
	TX_Enum_Type_RenderMode         _renderMode;
	NSString *                      _videoOutputPath;
}

@property (strong, nonatomic) MusicInfo * musicInfo;
@property (strong, nonatomic) TXVideoEditer *videoEditor;
@property (strong, nonatomic) VideoPreview * videoPreview;
@property (strong, nonatomic) AVAsset * videoAsset;
@property (assign, nonatomic) CGFloat  videoDuration;
@end

@implementation TX_WKG_VideoPreViewController

- (instancetype)initWithCoverImage:(UIImage *)coverImage
						 videoPath:(NSString*)videoPath
						 musicpath:(MusicInfo*)musicInfo
						renderMode:(TX_Enum_Type_RenderMode)renderMode
					  isFromRecord:(BOOL)isFromRecord;
{
	if (self = [super init]){
		_coverImage = coverImage;
		_videoPath  =  videoPath;
		_renderMode = renderMode;
		_musicInfo  = musicInfo;
		_videoOutputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"outputCut.mp4"];
		if (_videoAsset == nil && _videoPath != nil) {
			NSURL *avUrl = [NSURL fileURLWithPath:_videoPath];
			_videoAsset = [AVAsset assetWithURL:avUrl];
		}
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[[UIApplication sharedApplication]setStatusBarHidden:NO];
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	if (!_videoPreview.isPlaying) {
		[_videoPreview playVideo];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initPreviewUI];
	[TXLiveBase sharedInstance].delegate = [AppLogMgr shareInstance];
	TXPreviewParam *param = [[TXPreviewParam alloc] init];
	param.videoView = _videoPreview;
	param.renderMode = PREVIEW_RENDER_MODE_FILL_EDGE;
	
	TXVideoInfo *videoMsg = [TXVideoInfoReader getVideoInfoWithAsset:_videoAsset];
	CGFloat duration = videoMsg.duration;
	self.videoDuration = duration;
	
	self.videoEditor = [[TXVideoEditer alloc] initWithPreview:param];
	__strong  typeof(self)strongSelf = self;
	self.videoEditor.generateDelegate = strongSelf;
	self.videoEditor.previewDelegate = self;
	[self.videoEditor setBGMLoop:YES];
	__weak  typeof(self)weakSelf = self;
	[self.videoEditor setVideoAsset:_videoAsset];
	if (self.musicInfo) {
		[self.videoEditor setBGM:self.musicInfo.musicPath result:^(int result) {
			__strong typeof(weakSelf)strongSelf = weakSelf;
			[strongSelf.videoEditor setBGMStartTime:0 endTime:strongSelf.musicInfo.duration];
			[strongSelf.videoEditor setBGMLoop:YES];
			[strongSelf.videoEditor setBGMVolume:0.8f];
			[strongSelf.videoEditor setVideoVolume:0.1f];
			[strongSelf.videoEditor startPlayFromTime:0 toTime:strongSelf.videoDuration];
			[strongSelf.videoPreview setPlayBtn:YES];
		}];
	}else{
		[self.videoEditor startPlayFromTime:0 toTime:self.videoDuration];
		[self.videoEditor setVideoVolume:1.f];
	}
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	[UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}
#pragma mark ---- Video Preview ----
-(void)initPreviewUI{
	self.title = @"视频回放";
	UIBarButtonItem *customBackButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
																		 style:UIBarButtonItemStylePlain
																		target:self
																		action:@selector(goBack)];
	self.navigationItem.leftBarButtonItem = customBackButton;
	UIBarButtonItem *customSaveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
																		 style:UIBarButtonItemStylePlain
																		target:self
																		action:@selector(goSave)];
	self.navigationItem.rightBarButtonItem = customSaveButton;
	_videoPreview = [[VideoPreview alloc] initWithFrame:CGRectMake(0, heightEx(64), CGRectGetWidth(self.view.frame),ScreenHeight -heightEx(64))];
	_videoPreview.delegate = self;
	[self.view addSubview: _videoPreview];
}

-(void)goBack{
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)goSave{
	[self checkVideoOutputPath];
	[self.videoEditor setCutFromTime:0 toTime:_videoDuration];
	[self.videoEditor generateVideo:VIDEO_COMPRESSED_720P videoOutputPath:_videoOutputPath];
	[self.videoEditor pausePlay];
}

- (void)checkVideoOutputPath{
	NSFileManager *manager = [[NSFileManager alloc] init];
	if ([manager fileExistsAtPath:_videoOutputPath]) {
		BOOL success =  [manager removeItemAtPath:_videoOutputPath error:nil];
		if (success) {
			NSLog(@"Already exist. Removed!");
		}
	}
}

#pragma mark - TXVideoGenerateListener Delegate
-(void)onGenerateProgress:(float)progress{
	
}

-(void)onGenerateComplete:(TXGenerateResult *)result{
	NSLog(@"result.retCode =%zd error.desc = %@",result.retCode,result.descMsg);
}

#pragma mark VideoPreviewDelegate
- (void)onVideoPlay{
	[self.videoEditor startPlayFromTime:0 toTime:self.videoDuration];
}

- (void)onVideoPause{
	
}

- (void)onVideoResume{
	[self onVideoPlay];
}

#pragma mark TXVideoPreviewListener
-(void) onPreviewProgress:(CGFloat)time{
	
}
-(void)onPreviewFinished{
	[self.videoEditor startPlayFromTime:0 toTime:self.videoDuration];
}

- (void)onVideoPlayFinished{
	[self.videoEditor resumePlay];
}

- (void)onVideoEnterBackground{
	[self.videoEditor pauseGenerate];
}

- (void)onVideoWillEnterForeground
{
	[self.videoEditor resumeGenerate];
}

@end
