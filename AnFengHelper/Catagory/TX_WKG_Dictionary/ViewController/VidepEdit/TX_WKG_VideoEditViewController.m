	//
	//  TX_WKG_VideoEditViewController.m
	//  SmartCity
	//
	//  Created by 智享城市iOS开发 on 2018/4/17.
	//  Copyright © 2018年 NRH. All rights reserved.
	//
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "TX_WKG_VideoEditViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "MusicInfo.h"
#import <TXLiteAVSDK_Professional/TXVideoEditer.h>
#import <TXLiteAVSDK_Professional/TXLiveBase.h>

#import "VideoPreview.h"
#import "Video_TopOPt_View.h"
#import "Video_Right_Opt_View.h"
#import "WKG_VideoElectricAutoLayoutView.h"
#import "Video_Publish_Draft_View.h"
	//jump
#import "HCY_EditVCardViewController.h"
#import "QMX_SelectTopicVC.h"
#import "WKG_VideoCoverViewController.h"
	//音乐选择相关
#import "HJAlertViewController.h"
#import "HCY_SelectMusicViewController.h"
#import "MusicOptionalModel.h"
#import "MusicPauseOrPlayOptModel.h"
#import "QMX_MusicTool.h"
#import "MusicInfo.h"
	//当前视图编辑
#import "YZInputView.h"
#import "QMX_VideoSoundEditView.h"
#import "TX_WKG_VideoPasterTextViewController.h"
#import "TX_WKG_VideoPasterViewController.h"
#import "TX_WKG_VideoEffectSuperView.h"
#import "TX_WKG_VideoCutSuperView.h"
#import "VideoCutView.h"
#import "VideoClipsTool.h"
#import "VideoDraftTool.h"
	//数据请求
#import "CityUploadQueueManager.h"
#import "TX_WKGVideoEditManager.h"
#import "VideoRecordNoficationManager.h"
#import "TX_WKGRecordFileManager.h"
	//约吧相关的业务
#import "CY_YBIssueViewController.h"

#import "CY_AllShowSearchAddressController.h"

@interface OOKeyboardConfig:NSObject
@property (assign, nonatomic) NSTimeInterval duration;
@property (assign, nonatomic) CGFloat keyboardHeight;
@property (assign, nonatomic) CGFloat itemConvertSuperViewPos;
@property (assign, nonatomic) CGFloat superViewOffsetY;
@end

@implementation OOKeyboardConfig

@end


#ifndef TX_WKG_VIDEO_EDIT_TIME_EFFECT
#define TX_WKG_VIDEO_EDIT_TIME_EFFECT
typedef  NS_ENUM(NSInteger,TimeType){
	TimeType_Clear,
	TimeType_Back,
	TimeType_Repeat,
	TimeType_Speed,
};
#endif

@interface TX_WKG_VideoEditViewController ()<TXVideoGenerateListener,TXVideoPreviewListener,VideoPreviewDelegate,VideoTextViewControllerDelegate,VideoPasterViewControllerDelegate,VideoEffectViewDelegate,TimeSelectViewDelegate,VideoCutViewDelegate,UIGestureRecognizerDelegate>{
	CGFloat         _leftTime;
	CGFloat         _rightTime;
	UIImage *                       _coverImage;
	NSString*                       _videoPath;
	TX_Enum_Type_RenderMode         _renderMode;
	NSString *                      _videoOutputPath;
	NSMutableArray<VideoTextInfo*>*   _videoTextInfos;   //保存己添加的字幕
	NSMutableArray<VideoPasterInfo*>* _videoPaterInfos;  //保存己添加的贴纸
	BOOL  _isReverse;
	CGFloat _playTime;
	int _effectType;
	TimeType _timeType;
}

@property (strong, nonatomic) Video_TopOPt_View *video_topOpt_View;
@property (strong, nonatomic) Video_Right_Opt_View *video_right_Opt_View;
@property (strong, nonatomic) Video_Publish_Draft_View * video_publish_Draft_View;
@property (strong, nonatomic) WKG_VideoElectricAutoLayoutView * video_topic_Electric_View;
@property (strong, nonatomic) CompanyVCardModel * companyArgs;
@property (strong, nonatomic) PersonVCardModel * personArgs;
@property (strong, nonatomic) Response_dazzle_findLabelsData *topicModel;
@property (strong, nonatomic) Request_dazzle_addScDazzleDazzle *dazzleArgsModel;


@property (strong, nonatomic) MusicOptionalModel * optionModel;
@property (strong, nonatomic) MusicInfo * clipsMusicInfo;
@property (assign, nonatomic) CMTimeRange  timeRange;


@property (strong, nonatomic) TXVideoEditer *videoEditor;
@property (strong, nonatomic) VideoPreview * videoPreview;
@property (strong, nonatomic) AVAsset * videoAsset;
@property (assign, nonatomic) CGFloat  videoDuration;
@property (strong, nonatomic) QMX_VideoSoundEditView   * videoSoundEditView;
@property (strong, nonatomic) TX_WKG_VideoEffectSuperView *effectSuperView;
@property (strong, nonatomic) TX_WKG_VideoCutSuperView *cutSuperView;
@property (strong, nonatomic) TX_WKG_VideoCutSuperView *effectivePreCutSuperView;
@property (strong, nonatomic) NSMutableArray * subOptViewsContainers;
@property (strong, nonatomic) VideoCutView * videoCutView;
@property (copy, nonatomic) NSString * prepareGenerateTypeString;//预生成视频类型
@property (strong, nonatomic) UIImage * selectedCoverImage;
@property (strong, nonatomic) MBProgressHUD *hud;

/** 是否为保存草稿 */
@property (assign, nonatomic,getter=isSaveDraft) BOOL saveDraft;
/** 保存草稿的对象 */
@property (strong, nonatomic) VideoDraftTool *tool;

/** 上一个草稿对象的封面地址（本地） */
@property (copy, nonatomic) NSString *lastDraftCover;
/** 上一个草稿对象的视频地址（本地） */
@property (copy, nonatomic) NSString *lastDraftVideoUrl;
@property (strong, nonatomic) TX_WKGVideoEditManager * videoEditManager;
@property (strong, nonatomic) OOKeyboardConfig * keyboardConfig;
@property (copy, nonatomic) NSString * userOptRotateResult;
@property (strong, nonatomic) WKG_VideoCoverViewController *videoCoverViewController;
@property (assign, nonatomic) NSInteger  usingRotateCounter;
@property (strong, nonatomic) HCY_EditVCardViewController * hcy_editCardViewController;
@property (strong, nonatomic) UIButton * publishInterView_item_btn;

@property (strong, nonatomic) AMapTip *cityTip;


@end

@implementation TX_WKG_VideoEditViewController
#pragma mark - 新增业务需求 约吧发布动态
-(void)publishDynamicEvents:(UIButton*)args{
	[self prepareGenerateVideo:@"下一步"];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
	return NO;
}

- (void)onVideoLeftCutChanged:(VideoRangeSlider *)sender{
	[_videoPreview setPlayBtn:NO];
	[self.videoEditor previewAtTime:sender.leftPos];
}

- (void)onVideoRightCutChanged:(VideoRangeSlider *)sender{
	[_videoPreview setPlayBtn:NO];
	[self.videoEditor previewAtTime:sender.rightPos];
}

- (void)onVideoCutChangedEnd:(VideoRangeSlider *)sender{
	_leftTime = sender.leftPos;
	_rightTime = sender.rightPos;
	if (_leftTime == 0 && _rightTime == _videoDuration) {
		self.cutSuperView.tips_label.text = @"请选择视频的剪裁区域";
	}else{
		self.cutSuperView.tips_label.text = [NSString stringWithFormat:@"左侧:%.2f 右侧:%.2f",_leftTime,_rightTime];
	}
	[self.videoEditor startPlayFromTime:sender.leftPos toTime:sender.rightPos];
	[_videoPreview setPlayBtn:YES];
}

- (void)onVideoCenterRepeatChanged:(VideoRangeSlider*)sender{
	[_videoPreview setPlayBtn:NO];
	[self.videoEditor previewAtTime:sender.centerPos];
}

- (void)onVideoCenterRepeatEnd:(VideoRangeSlider*)sender;{
	_leftTime = sender.leftPos;
	_rightTime = sender.rightPos;
	if (_leftTime == 0 && _rightTime == _videoDuration) {
		self.cutSuperView.tips_label.text = @"请选择视频的剪裁区域";
	}else{
		self.cutSuperView.tips_label.text = [NSString stringWithFormat:@"左侧:%.2f 右侧:%.2f",_leftTime,_rightTime];
	}
	if (_timeType == TimeType_Repeat) {
		TXRepeat *repeat = [[TXRepeat alloc] init];
		repeat.startTime = sender.centerPos;
		repeat.endTime = sender.centerPos + 0.5;
		repeat.repeatTimes = 3;
		[self.videoEditor setRepeatPlay:@[repeat]];
		[self.videoEditor setSpeedList:nil];
	}
	else if (_timeType == TimeType_Speed) {
		TXSpeed *speed = [[TXSpeed alloc] init];
		speed.startTime = sender.centerPos;
		speed.endTime = sender.rightPos;
		speed.speedLevel = SPEED_LEVEL_SLOW;
		[self.videoEditor setSpeedList:@[speed]];
		[self.videoEditor setRepeatPlay:nil];
	}
	if (_isReverse) {
		[self.videoEditor startPlayFromTime:sender.leftPos toTime:sender.centerPos + 1.5];
	}else{
		[self.videoEditor startPlayFromTime:sender.centerPos toTime:sender.rightPos];
	}
	[_videoPreview setPlayBtn:YES];
}

- (void)onVideoCutChange:(VideoRangeSlider *)sender seekToPos:(CGFloat)pos{
	_playTime = pos;
	[self.videoEditor previewAtTime:_playTime];
	[_videoPreview setPlayBtn:NO];
}

- (void)onEffectDelete{
	[self.videoEditor deleteLastEffect];
}

#pragma mark VideoEffectViewDelegate
- (void)onVideoEffectBeginClick:(TXEffectType)effectType
{
	_effectType = effectType;
	switch ((TXEffectType)_effectType) {
		case TXEffectType_ROCK_LIGHT:
			[self.videoCutView startColoration:UIColorFromRGB(0xEC5F9B) alpha:0.7];
			break;
		case TXEffectType_DARK_DRAEM:
			[self.videoCutView startColoration:UIColorFromRGB(0xEC8435) alpha:0.7];
			break;
		case TXEffectType_SOUL_OUT:
			[self.videoCutView startColoration:UIColorFromRGB(0x1FBCB6) alpha:0.7];
			break;
		case TXEffectType_SCREEN_SPLIT:
			[self.videoCutView startColoration:UIColorFromRGB(0x449FF3) alpha:0.7];
			break;
		default:
			break;
	}
	[self.videoEditor startEffect:(TXEffectType)_effectType startTime:_playTime];
	if (!_isReverse) {
		[self.videoEditor startPlayFromTime:self.videoCutView.videoRangeSlider.currentPos toTime:self.videoCutView.videoRangeSlider.rightPos];
	}else{
		[self.videoEditor startPlayFromTime:self.videoCutView.videoRangeSlider.leftPos toTime:self.videoCutView.videoRangeSlider.currentPos];
	}
	[_videoPreview setPlayBtn:YES];
}

- (void)onVideoEffectEndClick:(TXEffectType)effectType
{
	if (_effectType != -1) {
		[_videoPreview setPlayBtn:NO];
		[self.videoCutView stopColoration];
		[self.videoEditor stopEffect:effectType endTime:_playTime];
		[self.videoEditor pausePlay];
		_effectType = -1;
	}
}

#pragma mark TimeSelectViewDelegate
- (void)onVideoTimeEffectsClear{
	_timeType = TimeType_Clear;
	_isReverse = NO;
	[self.videoEditor setReverse:_isReverse];
	[self.videoEditor setRepeatPlay:nil];
	[self.videoEditor setSpeedList:nil];
	[self.videoEditor startPlayFromTime:self.videoCutView.videoRangeSlider.leftPos toTime:self.videoCutView.videoRangeSlider.rightPos];
	[_videoPreview setPlayBtn:YES];
	[self.videoCutView setCenterPanHidden:YES];
}

- (void)onVideoTimeEffectsBackPlay{
	_timeType = TimeType_Back;
	_isReverse = YES;
	[self.videoEditor setReverse:_isReverse];
	[self.videoEditor setRepeatPlay:nil];
	[self.videoEditor setSpeedList:nil];
	[self.videoEditor startPlayFromTime:self.videoCutView.videoRangeSlider.leftPos toTime:self.videoCutView.videoRangeSlider.rightPos];
	[_videoPreview setPlayBtn:YES];
	[self.videoCutView setCenterPanHidden:YES];
	self.videoCutView.videoRangeSlider.hidden = NO;
}

- (void)onVideoTimeEffectsRepeat
{
	_timeType = TimeType_Repeat;
	_isReverse = NO;
	[self.videoEditor setReverse:_isReverse];
	[self.videoEditor setSpeedList:nil];
	TXRepeat *repeat = [[TXRepeat alloc] init];
	repeat.startTime = _leftTime + (_rightTime - _leftTime) / 5;
	repeat.endTime = repeat.startTime + 0.5;
	repeat.repeatTimes = 3;
	[self.videoEditor setRepeatPlay:@[repeat]];
	[self.videoEditor startPlayFromTime:self.videoCutView.videoRangeSlider.leftPos toTime:self.videoCutView.videoRangeSlider.rightPos];
	[_videoPreview setPlayBtn:YES];
	[self.videoCutView setCenterPanHidden:NO];
	[self.videoCutView setCenterPanFrame:repeat.startTime];
}

- (void)onVideoTimeEffectsSpeed{
	_timeType = TimeType_Speed;
	_isReverse = NO;
	[self.videoEditor setReverse:_isReverse];
	[self.videoEditor setRepeatPlay:nil];
	TXSpeed *speed =[[TXSpeed alloc] init];
	speed.startTime = _leftTime + (_rightTime - _leftTime) * 1.5 / 5;
	speed.endTime = self.videoCutView.videoRangeSlider.rightPos;
	speed.speedLevel = SPEED_LEVEL_SLOW;
	[self.videoEditor setSpeedList:@[speed]];
	[self.videoEditor startPlayFromTime:self.videoCutView.videoRangeSlider.leftPos toTime:self.videoCutView.videoRangeSlider.rightPos];
	[_videoPreview setPlayBtn:YES];
	[self.videoCutView setCenterPanHidden:NO];
	[self.videoCutView setCenterPanFrame:speed.startTime];
}

#pragma mark -VideoPreviewDelegate
- (void)onVideoPlay{
	CGFloat currentPos = _videoCutView.videoRangeSlider.currentPos;
	if (currentPos < _leftTime || currentPos > _rightTime)
		currentPos = _leftTime;
	if(_isReverse && currentPos != 0){
		[self.videoEditor startPlayFromTime:0 toTime:currentPos];
	}
	else if(_videoCutView.videoRangeSlider.rightPos != 0){
		[self.videoEditor startPlayFromTime:currentPos toTime:_videoCutView.videoRangeSlider.rightPos];
	}
	else{
		[self.videoEditor startPlayFromTime:currentPos toTime:_rightTime];
	}
}

- (void)onVideoPause{
	[self.videoEditor pausePlay];
}

- (void)onVideoResume{
	[self onVideoPlay];
}

- (void)onVideoPlayProgress:(CGFloat)time{
	_playTime = time;
	[_videoCutView setPlayTime:_playTime];
}

- (void)onVideoPlayFinished{
	[self.videoEditor startPlayFromTime:_leftTime toTime:_rightTime];
}
#pragma mark - VideoPasterViewControllerDelegate
- (void)onSetVideoPasterInfosFinish:(NSArray<VideoPasterInfo*>*)videoPasterInfos{
		//更新贴纸信息
	[_videoPaterInfos removeAllObjects];
	[_videoPaterInfos addObjectsFromArray:videoPasterInfos];
	_videoPreview.frame = CGRectMake(0, 0,CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame));
	_videoPreview.delegate = self;
	[_videoPreview setPlayBtnHidden:NO];
	UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTouchBGView:)];
	tapGesture.numberOfTapsRequired = 1;
	tapGesture.numberOfTouchesRequired = 1;
	[_videoPreview setUserInteractionEnabled:YES];
	[_videoPreview addGestureRecognizer:tapGesture];
	[self.view addSubview:_videoPreview];
	if ([NSStringFromClass(self.navigationController.class) isEqualToString:@"NewFaceBaseNavigationController"]) {
			//video_topOpt_View
		[self.view insertSubview:_videoPreview belowSubview:self.video_topOpt_View];
		[self onVideoResume];
		[self.videoPreview setPlayBtn:YES];
		return;
	}
	[self.view insertSubview:_videoPreview belowSubview:self.video_topic_Electric_View];
	[self onVideoResume];
	[self.videoPreview setPlayBtn:YES];
}

#pragma mark - VideoTextViewControllerDelegate
- (void)onSetVideoTextInfosFinish:(NSArray<VideoTextInfo *> *)videoTextInfos{
	for (VideoTextInfo* info in videoTextInfos) {
		if (![_videoTextInfos containsObject:info]) {
			[_videoTextInfos addObject:info];
		}
	}
	NSMutableArray* removedTexts = [NSMutableArray new];
	for (VideoTextInfo* info in _videoTextInfos) {
		NSUInteger index = [videoTextInfos indexOfObject:info];
		if ( index != NSNotFound) {
			continue;
		}
		if (info.startTime < _rightTime && info.endTime > _leftTime)
			[removedTexts addObject:info];
	}
	if (removedTexts.count > 0)
		[_videoTextInfos removeObjectsInArray:removedTexts];
	
	_videoPreview.frame = CGRectMake(0, 0,CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame));
	_videoPreview.delegate = self;
	[_videoPreview setPlayBtnHidden:NO];
	UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTouchBGView:)];
	tapGesture.numberOfTapsRequired = 1;
	tapGesture.numberOfTouchesRequired = 1;
	[_videoPreview setUserInteractionEnabled:YES];
	[_videoPreview addGestureRecognizer:tapGesture];
	[self.view addSubview:_videoPreview];
	if ([NSStringFromClass(self.navigationController.class) isEqualToString:@"NewFaceBaseNavigationController"]) {
		[self.view insertSubview:_videoPreview belowSubview:self.video_topOpt_View];
		[self onVideoResume];
		[self.videoPreview setPlayBtn:YES];
		return;
	}
	[self.view insertSubview:_videoPreview belowSubview:self.video_topic_Electric_View];
	[self onVideoResume];
	[self.videoPreview setPlayBtn:YES];
}

#pragma mark -IBOutlet Events
	// bgview 响应事件
- (void)onTouchBGView:(UITapGestureRecognizer *)touches{
		//判断当前点击区域是不是视频预览视图的播放按钮
	CGPoint point = [touches locationInView:self.view];
	if (CGRectContainsPoint(self.video_topic_Electric_View.electricalItem.frame,point)) {
		return;
	}
	if (CGRectContainsPoint(self.publishInterView_item_btn.frame, point)) {
		return;
	}
	if (CGRectContainsPoint(self.videoPreview.playBtn.frame, point)) {
		if (_videoPreview.isPlaying) {
			[self.videoPreview  setPlayBtn:NO];
			[self onVideoPause];
		}else{
			[self.videoPreview  setPlayBtn:YES];
			[self.videoEditor resumePlay];
		}
		return;
	}
	[self viewsSerializeRemoveFromSuperView];
	[self.video_publish_Draft_View setHidden:NO];
	[self.publishInterView_item_btn setHidden:NO];
	
	[self.video_topic_Electric_View.textView resignFirstResponder];
	if (_videoPreview.isPlaying) {
		[self.videoPreview  setPlayBtn:NO];
		[self onVideoPause];
	}else{
		[self.videoPreview  setPlayBtn:YES];
		[self.videoEditor resumePlay];
	}
}

#pragma mark - Video_Opt_Right_View Events
-(void)dimssViewControllerEvents:(UIButton*)args{
	if (self.draftVideo) {
		[self dismissViewControllerAnimated:YES completion:nil];
	}else{
		[self.navigationController popViewControllerAnimated:YES];
	}
}
	//添加音乐
-(void)insertMusicWithVideoEvents:(UIButton*)args{
	__weak typeof(self) weakSelf = self;
	__block UIButton* opt = args;
	if (self.optionModel) {
		HJAlertViewController *alert = [HJAlertViewController actionWithCancelTitle:@"取消" cancelStyle:UIAlertActionStyleCancel otherTitles:@[@"更换音乐", @"关闭音乐"] extraData:nil andCompleteBlock:^(UIAlertController *alertVC, NSInteger buttonIndex) {
			__strong typeof(weakSelf)strongSelf = weakSelf;
			if (buttonIndex) { // 关闭音乐
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
					[opt setSelected:NO];
					strongSelf.optionModel = nil;
					strongSelf.timeRange = kCMTimeRangeZero;
					strongSelf.clipsMusicInfo = nil;
					[strongSelf.video_topOpt_View setSelectedEnable:NO opt:@"原音"];
					[strongSelf.videoEditor setBGM:nil result:^(int result) {
						if ([weakSelf.musicOptString isEqualToString:@"YES"]) {
							[weakSelf.videoEditor setBGMVolume:0.f];
						}
					}];
				});
			} else{
				[strongSelf pushElectMusicToVC:args];
			}
		}];
		[alert showInContronl:self];
		return;
	}else{
		[self pushElectMusicToVC:args];
	}
}

-(void)pushElectMusicToVC:(UIButton*)args{
	__weak typeof(self)weakSelf = self;
	__block UIButton * opt = args;
	HCY_SelectMusicViewController *vc = [[HCY_SelectMusicViewController alloc] init];
	vc.selMusicSuccess = ^(MusicOptionalModel *model, CMTimeRange selMusicRange) {
		__strong typeof(weakSelf) strongSelf = weakSelf;
		if (model.pauseOrPlayModel.cachePath.length !=0) {
			[opt setSelected:YES];
			[strongSelf.video_topOpt_View setSelectedEnable:YES opt:@"原音"];
			strongSelf.optionModel = model;
			strongSelf.timeRange = selMusicRange;
			if (strongSelf.clipsMusicInfo == nil) {
				strongSelf.clipsMusicInfo = [[MusicInfo alloc]init];
			}
			strongSelf.clipsMusicInfo.musicPath = model.pauseOrPlayModel.cachePath;
			CMTime start = strongSelf.timeRange.start;
			CMTime end = strongSelf.timeRange.duration;
			NSTimeInterval startTimeInterval = start.value / start.timescale;
			NSTimeInterval endTimeInterval = end.value / end.timescale + startTimeInterval;
			strongSelf.clipsMusicInfo.start = startTimeInterval;
			strongSelf.clipsMusicInfo.duration = endTimeInterval;
				//
			if ([strongSelf.musicOptString isEqualToString:@"YES"]) {
				[strongSelf.videoEditor setBGM:nil result:^(int result) {
					
				}];
			}
			[self.videoEditor setBGM:self.clipsMusicInfo.musicPath result:^(int result) {
				__strong typeof(weakSelf)strongSelf = weakSelf;
				[strongSelf.videoEditor setBGMStartTime:0 endTime:strongSelf.clipsMusicInfo.duration];
					///是否关闭视频的原音 YES：关闭 NO：不需要关闭
				if ([strongSelf.musicOptString isEqualToString:@"YES"]) {
					strongSelf.videoSoundEditView.originSlider.value = 0.f;
					[strongSelf.videoEditor setVideoVolume:0.0f];
					[strongSelf.videoEditor setBGMVolume:0.5f];
					[strongSelf.videoSoundEditView.originSlider setEnabled:NO];
				}
				[strongSelf.videoEditor setBGMLoop:YES];
				[strongSelf.videoEditor setBGMVolume:0.5f];
				[strongSelf.videoEditor setVideoVolume:0.5f];
				[strongSelf.videoSoundEditView.bgmSlider setValue:0.5f];
				[strongSelf.videoEditor startPlayFromTime:0 toTime:strongSelf.videoDuration];
				dispatch_barrier_sync(dispatch_get_main_queue(), ^{
					[strongSelf.videoPreview setPlayBtn:YES];
				});
			}];
		} else {
			[opt setSelected:NO];
			[strongSelf.video_topOpt_View setSelectedEnable:NO opt:@"原音"];
		}
	};
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
	[self presentViewController:nav animated:YES completion:nil];
}

	//选择音乐设置背景音量
-(void)editVideoMusicAndVoiceEvents:(UIButton*)args{
	__weak typeof(self)weakSelf = self;
	[self viewsSerializeRemoveFromSuperView];
	[self.view addSubview:self.videoSoundEditView];
	[self.videoSoundEditView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.and.right.mas_equalTo(weakSelf.view);
		make.bottom.mas_equalTo(weakSelf.view.mas_bottom).with.offset(0.f);
		make.height.mas_equalTo(@(heightEx(120.f)));
	}];
	[self.subOptViewsContainers addObject:self.videoSoundEditView];
}

-(void)videoRotateEvents{
	self.usingRotateCounter ++;
	[UIView animateWithDuration:0.3f delay:0.f options:(UIViewAnimationOptionCurveLinear) animations:^{
		self.videoPreview.renderView.transform = CGAffineTransformRotate(self.videoPreview.renderView.transform, M_PI_2);
		if (self.usingRotateCounter %2 == 1) {
			self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8f];
		}else{
			self.view.backgroundColor = [UIColor whiteColor];
		}
	} completion:^(BOOL finished) {
		if (self.usingRotateCounter % 4 ==0) {
			self.userOptRotateResult = @"NO";
		}else{
			self.userOptRotateResult = @"YES";
		}
	}];
}
	//视频贴纸 || jump
-(void)videoPasterEvents{
	__weak typeof(self)weakSelf = self;
	UIAlertController * alertViewController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"贴纸" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[_videoPreview removeFromSuperview];
		__strong typeof(weakSelf)strongSelf = weakSelf;
		TX_WKG_VideoPasterViewController * pasterViewVC = [[TX_WKG_VideoPasterViewController alloc]initWithVideoEditer:strongSelf.videoEditor previewView:_videoPreview startTime:0 endTime:_videoDuration pasterInfos:_videoPaterInfos];
		pasterViewVC.delegate = strongSelf;
		UINavigationController * navigationController = [[UINavigationController alloc]initWithRootViewController:pasterViewVC];
		[strongSelf presentViewController:navigationController animated:YES completion:nil];
	}];
	UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"字幕" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[_videoPreview removeFromSuperview];
		__strong typeof(weakSelf)strongSelf = weakSelf;
		TX_WKG_VideoPasterTextViewController * pasterTextViewVC = [[TX_WKG_VideoPasterTextViewController alloc]initWithVideoEditer:strongSelf.videoEditor previewView:_videoPreview startTime:0 endTime:_videoDuration videoTextInfos:_videoTextInfos];
		pasterTextViewVC.delegate = strongSelf;
		UINavigationController * navigationController = [[UINavigationController alloc]initWithRootViewController:pasterTextViewVC];
		[strongSelf presentViewController:navigationController animated:YES completion:nil];
	}];
	UIAlertAction * alertAction3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
	}];
	[alertViewController addAction:alertAction1];
	[alertViewController addAction:alertAction2];
	[alertViewController addAction:alertAction3];
	[self presentViewController:alertViewController animated:YES completion:nil];
}

	//视频裁剪
-(void)videoCutEvents{
	[self viewsSerializeRemoveFromSuperView];
	if (![[self.view subviews]containsObject:_cutSuperView]) {
		[self.view addSubview:self.cutSuperView];
		if (self.videoCutView == nil) {
			self.videoCutView = [[VideoCutView alloc]initWithFrame:CGRectMake(0, heightEx(8.f), CGRectGetWidth(self.view.frame), heightEx(90.f)) videoPath:_videoPath videoAssert:_videoAsset];
			_videoCutView.delegate = self;
		}
		self.videoCutView.frame = CGRectMake(0, heightEx(8.f), CGRectGetWidth(self.view.frame), heightEx(90.f));
		self.cutSuperView.videoCutView = self.videoCutView;
		[self.cutSuperView addSubview:self.videoCutView];
		[self.subOptViewsContainers addObject:self.cutSuperView];
		[self.video_publish_Draft_View setHidden:YES];
		[self.publishInterView_item_btn setHidden:YES];
	}
}
	//视频特效
-(void)videoEffectivevents:(UIButton*)args{
	[self viewsSerializeRemoveFromSuperView];
	if (![[self.view subviews]containsObject:self.effectSuperView]) {
		[self.view  addSubview:self.effectSuperView];
		[self.subOptViewsContainers addObject:self.effectSuperView];
		[self.video_publish_Draft_View setHidden:YES];
		[self.publishInterView_item_btn setHidden:YES];
		if (self.videoCutView == nil) {
			_videoCutView = [[VideoCutView alloc]initWithFrame:CGRectMake(widthEx(20), KScreenHeight - heightEx(190.f+90 + 20), KScreenWidth - widthEx(40.f), heightEx(90)) videoPath:_videoPath videoAssert:_videoAsset];
			_videoCutView.delegate = self;
		}
		_videoCutView.frame = CGRectMake(widthEx(20), KScreenHeight - heightEx(190.f + 90.f + 20), KScreenWidth - widthEx(40.f), heightEx(90));
		[self.view  addSubview:self.videoCutView];
		[self.subOptViewsContainers addObject:self.videoCutView];
	}
}

	//视频选封面
-(void)createVideoCoverImageEvents{
	self.videoCoverViewController = [WKG_VideoCoverViewController new];
	self.videoCoverViewController.selectImage = self.selectedCoverImage;
	self.videoCoverViewController.videoUrl = _videoPath;
	__weak  typeof(self)weakSelf = self;
	self.videoCoverViewController.callback = ^(UIImage * coverImg){
		__strong  typeof(weakSelf)strongSelf = weakSelf;
		strongSelf.selectedCoverImage = coverImg;
	};
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.videoCoverViewController];
	[self presentViewController:nav animated:YES completion:nil];
}

-(void)viewsSerializeRemoveFromSuperView{
	[self.subOptViewsContainers enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[obj removeFromSuperview];
	}];
}

#pragma mark -getter methods
-(UIButton *)publishInterView_item_btn{
	_publishInterView_item_btn = ({
		if (!_publishInterView_item_btn) {
			_publishInterView_item_btn = [UIButton buttonWithType:UIButtonTypeCustom];
			[_publishInterView_item_btn setBackgroundColor:UIColorFromRGB(0x09E9CD)];
			[_publishInterView_item_btn setTitle:@"下一步" forState:UIControlStateNormal];
			[_publishInterView_item_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			_publishInterView_item_btn.titleLabel.font = [UIFont fontWithName:@"SourceHanSansCN-Regular" size:14.f];
			[_publishInterView_item_btn addTarget:self action:@selector(publishDynamicEvents:) forControlEvents:UIControlEventTouchUpInside];
		}
		_publishInterView_item_btn;
	});
	return _publishInterView_item_btn;
}

-(NSMutableArray *)subOptViewsContainers{
	_subOptViewsContainers = ({
		if (!_subOptViewsContainers) {
			_subOptViewsContainers = [NSMutableArray array];
		}
		_subOptViewsContainers;
	});
	return _subOptViewsContainers;
}

- (void)showAlertViewControllerEvents{
	__weak typeof(self)weakSelf = self;
	UIAlertController * alertViewController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		__strong typeof(weakSelf)strongSelf = weakSelf;
		if (strongSelf.hcy_editCardViewController == nil) {
			strongSelf.hcy_editCardViewController = [[HCY_EditVCardViewController alloc] init];
		}
		[[IQKeyboardManager sharedManager] setEnable:YES];
		strongSelf.hcy_editCardViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
		[strongSelf presentViewController:strongSelf.hcy_editCardViewController animated:YES completion:nil];
		[strongSelf.hcy_editCardViewController clearDataWithObjectPerson:strongSelf.personArgs company:strongSelf.companyArgs optionType:@"编辑"];
		strongSelf.hcy_editCardViewController.vCardBlock = ^(NSInteger type, PersonVCardModel *personModel, CompanyVCardModel *companyModel) {
			__strong typeof(weakSelf)strongSelf = weakSelf;
			[strongSelf electricVCard:personModel companyModel:companyModel type:type];
		};
	}];
	UIAlertAction * alertAction2  = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		__strong typeof(weakSelf)strongSelf = weakSelf;
		[strongSelf.video_topic_Electric_View isVaild:NO params:@{} loadType:ReleaseLoadType];
		[strongSelf.hcy_editCardViewController clearDataWithObjectPerson:strongSelf.personArgs company:strongSelf.companyArgs optionType:@"删除"];
		strongSelf.personArgs  = nil;
		strongSelf.companyArgs = nil;
	}];
	UIAlertAction * alertAction3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
	}];
	[alertViewController addAction:alertAction1];
	[alertViewController addAction:alertAction2];
	[alertViewController addAction:alertAction3];
	[self presentViewController:alertViewController animated:YES completion:nil];
}

-(void)electricVCard:(PersonVCardModel*)personModel companyModel:(CompanyVCardModel*)companyModel type:(NSInteger)type{
	self.personArgs  = nil;
	self.companyArgs = nil;
	[[IQKeyboardManager sharedManager]setEnable:NO];
	if (personModel == nil && companyModel == nil) {
		[self.video_topic_Electric_View isVaild:NO params:@{} loadType:ReleaseLoadType];
		return;
	}
		// 0 : 个人 1:公司
	NSDictionary * params;
	NSMutableDictionary * results = [NSMutableDictionary dictionary];
	if (type == 0 && personModel) {
		personModel.type = [@(type)stringValue];
		self.personArgs = personModel;
		NSString * sex = (personModel.sex.length == 0 || personModel.sex == nil) ? @"":personModel.sex;
		NSString * education = (personModel.education.length == 0 || personModel.education == nil) ? @"":personModel.education;
		NSString * careerWebsite = (personModel.careerWebsite.length == 0 || personModel.careerWebsite == nil) ? @"":personModel.careerWebsite;
		NSString * phone = (personModel.phone.length == 0 || personModel.phone == nil) ? @"":personModel.phone;
		NSString * name;
		if ([careerWebsite isEqualToString:@""]) {
			name  = (companyModel.employeeName.length == 0 || companyModel.employeeName == nil) ? @"": [NSString stringWithFormat:@"%@",companyModel.employeeName];
		}else{
			name = (personModel.name.length == 0 || personModel.name == nil) ? @"":[NSString stringWithFormat:@"%@ / %@",personModel.name,careerWebsite];
		}
		params = @{@"name":name,@"sex":sex,@"education":education,@"phone":phone};
		NSMutableArray * mutableItmes = [NSMutableArray array];
		NSString * sexImgString = @"";
		if ([personModel.sex isEqualToString:@"男"]) {
			sexImgString = @"qmx_wkg_recommend_boy";
		}else if([personModel.sex isEqualToString:@"女"]){
			sexImgString = @"qmx_wkg_recommend_girl";
		}
		NSArray * personImgs    =  @[@"",sexImgString,@"qmx_wkg_recommend_edu",@"qmx_wkg_recommend_phone"];
		NSArray * namePrefixs = @[@{@"name":@"姓名"},@{@"sex":@"性别"},@{@"education":@"学历"},@{@"phone":@"电话"}];
		if (params) {
			[namePrefixs enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				NSString * key = [[obj allKeys]firstObject];
				if ([params[key]length] > 0) {
					NSString * text = params[key];
					NSString * img  = personImgs[idx];
					NSDictionary * json = @{@"text":text ,@"img":img,@"type":@"none"};
					[mutableItmes addObject:json];
				}
			}];
		}
		[results setObject:@"0" forKey:@"type"];
		[results setObject:mutableItmes forKey:@"items"];
		[results setObject:personModel.name forKey:@"name"];
		[results setObject:personModel.phone forKey:@"phone"];
		
	}else if(companyModel){
		companyModel.type = [@(type)stringValue];
		self.companyArgs = companyModel;
		NSString * careerWebsite = (companyModel.careerWebsite.length == 0 || companyModel.careerWebsite == nil) ? @"":companyModel.careerWebsite;
		NSString * phone = (companyModel.phone.length == 0 || companyModel.phone == nil) ? @"":companyModel.phone;
		NSString * companyPosition = (companyModel.companyPosition.length == 0 || companyModel.companyPosition == nil) ? @"":companyModel.companyPosition;
		NSString * employeeName;
		if ([companyPosition isEqualToString:@""]) {
			employeeName  = (companyModel.employeeName.length == 0 || companyModel.employeeName == nil) ? @"": [NSString stringWithFormat:@"%@",companyModel.employeeName];
		}else{
			employeeName  = (companyModel.employeeName.length == 0 || companyModel.employeeName == nil) ? @"": [NSString stringWithFormat:@"%@ / %@",companyModel.employeeName,companyPosition];
		}
		params = @{@"employeeName":employeeName,@"name":companyModel.name,@"phone":phone,@"careerWebsite":careerWebsite};
		NSMutableArray * mutableItmes = [NSMutableArray array];
		NSArray * namePrefixs = @[@{@"employeeName":@"姓名"},@{@"name":@"公司名称"},@{@"phone":@"联系方式"},@{@"careerWebsite":@"公司网站"}];
		NSArray * commpanyImgs =  @[@"",@"qmx_wkg_recommend_company",@"qmx_wkg_recommend_phone",@"qmx_wkg_recommend_web_logo"];
		if (params) {
			[namePrefixs enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				NSString * key = [[obj allKeys]firstObject];
				if ([params[key]length] > 0) {
					NSString * type = @"none";
					if ([[[obj allValues]firstObject] isEqualToString:@"公司网站"]) {
						type = @"jump";
					}
					NSString * text = params[key];
					NSString * img  = commpanyImgs[idx];
					NSDictionary * json = @{@"text":text ,@"img":img,@"type":type};
					[mutableItmes addObject:json];
				}
			}];
		}
		[results setObject:@"1" forKey:@"type"];
		[results setObject:mutableItmes forKey:@"items"];
		[results setObject:companyModel.name forKey:@"name"];
		[results setObject:companyModel.phone forKey:@"phone"];
	}
	[self.video_topic_Electric_View isVaild:YES params:results loadType:ReleaseLoadType];
}

#pragma mark - setter methods

-(void)setMusicOptString:(NSString *)musicOptString{
	_musicOptString = musicOptString;
	/*
	 if ([_musicOptString isEqualToString:@"NO"]) {
	 [self.video_topOpt_View setSelectedEnable:NO opt:@"原音"];
	 }else{
	 [self.video_topOpt_View setSelectedEnable:YES opt:@"原音"];
	 }
	 ///是否关闭视频的原音 YES：关闭 NO：不需要关闭
	 if ([_musicOptString isEqualToString:@"YES"]) {
	 self.videoSoundEditView.originSlider.value = 0.f;
	 [self.videoEditor setVideoVolume:0.0f];
	 [self.videoSoundEditView.originSlider setEnabled:NO];
	 self.videoSoundEditView.bgmSlider.value = 0.5f;
	 [self.videoEditor setBGMVolume:0.5f];
	 }else{
	 [self.videoEditor setVideoVolume:0.5f];
	 [self.videoEditor setBGMVolume:0.5f];
	 [self.videoSoundEditView.originSlider setEnabled:YES];
	 self.videoSoundEditView.originSlider.value = 0.5f;
	 self.videoSoundEditView.bgmSlider.value    = 0.5f;
	 }
	 */
}

-(void)setDraftVideo:(VideoDraftTool *)draftVideo{
	_draftVideo = draftVideo;
	NSString * dazzleType = _draftVideo.dazzleType;
	self.topicModel = _draftVideo.topicModel;
	NSString * containMusic = _draftVideo.containMusic;
	if ([containMusic isEqualToString:@"YES"]) {
		[self.video_topOpt_View setSelectedStatus:YES opt:@"音乐"];
		[self.video_topOpt_View setSelectedEnable:YES opt:@"原音"];
	}else{
		[self.video_topOpt_View setSelectedStatus:NO opt:@"音乐"];
		[self.video_topOpt_View setSelectedEnable:NO opt:@"原音"];
	}
	self.clipsMusicInfo = nil;
	
	if ([dazzleType isEqualToString:@"0"]) {
		NSString * topicFormat = self.topicModel.labelName.length == 0||[self.topicModel.labelName isEqualToString:@""] ? @"选择话题": self.topicModel.labelName;
		[self.video_topic_Electric_View.selectTopicView.topicLabel setText:topicFormat];
		[self.video_topic_Electric_View.selectTopicView updateLayout];
		self.video_topic_Electric_View.textView.text = _draftVideo.introduce;
		if (_draftVideo.introduce.length !=0) {
			self.video_topic_Electric_View.textView.placeholder = @"";
		}else{
			self.video_topic_Electric_View.textView.placeholder = @"说两句吧";
		}
		[self.video_topic_Electric_View isVaild:NO params:@{} loadType:ReleaseLoadType];
	}else{
		NSInteger cardType = [_draftVideo.cardType integerValue];
		PersonVCardModel * personModel = _draftVideo.personModel;
		CompanyVCardModel * companyModel = _draftVideo.companyModel;
		if (cardType == 0) {
			companyModel = nil;
		}else if (cardType ==1){
			personModel = nil;
		}
		[self electricVCard:personModel companyModel:companyModel type:cardType];
	}
}

#pragma mark - getter methods
-(TX_WKG_VideoCutSuperView *)cutSuperView{
	_cutSuperView = ({
		if (!_cutSuperView) {
			_cutSuperView = [[TX_WKG_VideoCutSuperView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - heightEx(180.f), CGRectGetWidth(self.view.frame), heightEx(180.f)) videoPath:_videoPath videoAssert:_videoAsset opt_Type:TX_WKG_VIDEO_CUTOPT_CUT_TYPE];
			_cutSuperView.bgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.80f];
		}
		_cutSuperView;
	});
	return _cutSuperView;
}

-(TX_WKG_VideoEffectSuperView *)effectSuperView{
	_effectSuperView = ({
		if (!_effectSuperView) {
			_effectSuperView = [[TX_WKG_VideoEffectSuperView alloc]initWithFrame:CGRectMake(0, KScreenHeight - heightEx(190.f), KScreenWidth, heightEx(190))];
			_effectSuperView.backgroundColor =[[UIColor blackColor]colorWithAlphaComponent:0.8f];
			_effectSuperView.effectDelegate = self;
			_effectSuperView.timeDelegate = self;
			__weak  typeof(self)weakSelf = self;
			_effectSuperView.callback = ^(NSString *title) {
				if ([title isEqualToString:@"撤销"]) {
					__strong typeof(weakSelf)strongSelf = weakSelf;
					[strongSelf.videoCutView.videoRangeSlider removeLastColoration];
					[strongSelf.videoEditor deleteLastEffect];
				}
			};
		}
		_effectSuperView;
	});
	return _effectSuperView;
}

-(QMX_VideoSoundEditView *)videoSoundEditView{
	_videoSoundEditView = ({
		if (!_videoSoundEditView) {
			_videoSoundEditView = [QMX_VideoSoundEditView creatSoundEditView];
			_videoSoundEditView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.80f];
			__weak typeof(self)weakSelf = self;
			_videoSoundEditView.originChageBlock = ^(CGFloat value) {
				__strong typeof(weakSelf)strongSelf = weakSelf;
				[strongSelf.videoEditor setVideoVolume:value];
			};
			_videoSoundEditView.bgmChangeBlock = ^(CGFloat value) {
				__strong typeof(weakSelf)strongSelf = weakSelf;
				[strongSelf.videoEditor setBGMVolume:value];
			};
		}
		_videoSoundEditView;
	});
	return _videoSoundEditView;
}

-(Video_Publish_Draft_View *)video_publish_Draft_View{
	_video_publish_Draft_View = ({
		if (!_video_publish_Draft_View) {
			_video_publish_Draft_View = [[Video_Publish_Draft_View alloc]initWithFrame:CGRectZero];
			__weak  typeof(self)weakSelf = self;
			_video_publish_Draft_View.publish_callback = ^(NSString *title) {
				__strong typeof(weakSelf)strongSelf = weakSelf;
				[strongSelf prepareGenerateVideo:title];
			};
		}
		_video_publish_Draft_View;
	});
	return _video_publish_Draft_View;
}

-(Video_TopOPt_View *)video_topOpt_View{
	_video_topOpt_View = ({
		if (!_video_topOpt_View) {
			__weak  typeof(self)weakSelf = self;
			_video_topOpt_View = [[Video_TopOPt_View alloc]initWithFrame:CGRectZero];
			_video_topOpt_View.opt_callback = ^(UIButton *item, NSString *title) {
				__strong typeof(weakSelf)strongSelf = weakSelf;
				NSDictionary * json = @{@"返回":@"dimssViewControllerEvents:",
										@"音乐":@"insertMusicWithVideoEvents:",
										@"原音":@"editVideoMusicAndVoiceEvents:",
										@"特效":@"videoEffectivevents:",
										};
				NSString * selector = json[title];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
				SEL sel = NSSelectorFromString(selector);
				[strongSelf performSelector:sel withObject:item];
#pragma clang diagnostic pop
			};
		}
		_video_topOpt_View;
	});
	return _video_topOpt_View;
}

-(Video_Right_Opt_View *)video_right_Opt_View{
	_video_right_Opt_View = ({
		if (!_video_right_Opt_View) {
			_video_right_Opt_View = [[Video_Right_Opt_View alloc]initWithFrame:CGRectZero];
			_video_right_Opt_View.backgroundColor = [UIColor clearColor];
			__weak typeof(self)weakSelf = self;
			_video_right_Opt_View.opt_callback = ^(NSString *title) {
				__strong typeof(weakSelf)strongSelf = weakSelf;
				NSDictionary * json = @{@"旋转":@"videoRotateEvents",
										@"贴纸":@"videoPasterEvents",
										@"裁剪":@"videoCutEvents",
										@"选封面":@"createVideoCoverImageEvents"
										};
				NSString * selector = json[title];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
				SEL sel = NSSelectorFromString(selector);
				[strongSelf performSelector:sel];
#pragma clang diagnostic pop
			};
		}
		_video_right_Opt_View;
	});
	return _video_right_Opt_View;
}
-(HCY_EditVCardViewController *)hcy_editCardViewController{
	_hcy_editCardViewController = ({
		if (!_hcy_editCardViewController) {
			_hcy_editCardViewController = [[HCY_EditVCardViewController alloc]init];
		}
		_hcy_editCardViewController;
	});
	return _hcy_editCardViewController;
}

-(WKG_VideoElectricAutoLayoutView *)video_topic_Electric_View{
	_video_topic_Electric_View = ({
		if (!_video_topic_Electric_View) {
			_video_topic_Electric_View =  [[WKG_VideoElectricAutoLayoutView alloc]initWithFrame:CGRectZero];
			__weak typeof(self)weakSelf = self;
			_video_topic_Electric_View.eventshander = ^(NSString *params,UITapGestureRecognizer* tapgesture) {
				__strong typeof(weakSelf)strongSelf = weakSelf;
				if ([params isEqualToString:@"electTopic"]) {
					QMX_SelectTopicVC *vc = [[QMX_SelectTopicVC alloc] init];
					
					[vc setSelectedTopicComplete:^(Response_dazzle_findLabelsData *model) {
						strongSelf.topicModel = model;
						[strongSelf.video_topic_Electric_View.selectTopicView.topicLabel setText:model.labelName];
						[weakSelf.video_topic_Electric_View.selectTopicView updateLayoutForOrigin];
					}];
					[strongSelf.navigationController pushViewController:vc animated:YES];
				}else if ([params isEqualToString:@"electTopicAdd"]) {
					CY_AllShowSearchAddressController *vc = [[CY_AllShowSearchAddressController alloc] init];
					vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
					vc.cityDataBlock = ^(AMapTip *cityTip) {
						weakSelf.cityTip = cityTip;
						[weakSelf.video_topic_Electric_View.selectAddView.topicLabel setText:cityTip.name];
						[weakSelf.video_topic_Electric_View.selectAddView updateLayoutForOrigin];
						
					};
					[strongSelf presentViewController:vc animated:YES completion:nil];
				} else if ([params isEqualToString:@"electricalCard"]){
					if (strongSelf.personArgs || strongSelf.companyArgs) {
						[strongSelf showAlertViewControllerEvents];
						return;
					}
					[[IQKeyboardManager sharedManager] setEnable:YES];
					strongSelf.hcy_editCardViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
					[strongSelf presentViewController:strongSelf.hcy_editCardViewController animated:YES completion:nil];
					strongSelf.hcy_editCardViewController.vCardBlock = ^(NSInteger type, PersonVCardModel *personModel, CompanyVCardModel *companyModel) {
						__strong typeof(weakSelf)strongSelf = weakSelf;
						[strongSelf electricVCard:personModel companyModel:companyModel type:type];
					};
				}else if([params isEqualToString:@"touchesEvent"]){
					[strongSelf onTouchBGView:tapgesture];
				}
			};
		}
		_video_topic_Electric_View;
	});
	return _video_topic_Electric_View;
}
#pragma mark - NSNotifications Observers
#pragma mark - NSNotification Observer
-(void)dazzleTruncatSearchMusicOberver:(NSNotification*)notification{
	id obj = notification.object;
	if ([obj isKindOfClass:[MusicOptionalModel class]]) {
		MusicOptionalModel * model = (MusicOptionalModel*)obj;
		if (model.pauseOrPlayModel.cachePath.length !=0) {
			[self.video_topOpt_View setSelectedStatus:YES opt:@"音乐"];
			[self.video_topOpt_View setSelectedEnable:YES opt:@"原音"];
			self.optionModel = model;
			self.timeRange   = model.pauseOrPlayModel.selMusicRange;
			if (self.clipsMusicInfo == nil) {
				self.clipsMusicInfo = [[MusicInfo alloc]init];
			}
			self.clipsMusicInfo.musicPath = model.pauseOrPlayModel.clipsAudioPath;
			CMTime start = self.timeRange.start;
			CMTime end = self.timeRange.duration;
			NSTimeInterval startTimeInterval = start.value / start.timescale;
			NSTimeInterval endTimeInterval = end.value / end.timescale + startTimeInterval;
			self.clipsMusicInfo.start = startTimeInterval;
			self.clipsMusicInfo.duration = endTimeInterval;
				//
			__weak typeof(self)weakSelf = self;
			if ([self.musicOptString isEqualToString:@"YES"]) {
				[self.videoEditor setVideoVolume:0.f];
				[self.videoEditor setBGM:self.clipsMusicInfo.musicPath result:^(int result) {
					__strong typeof(weakSelf)strongSelf = weakSelf;
					[strongSelf.videoEditor setBGMStartTime:0 endTime:strongSelf.clipsMusicInfo.duration];
					[strongSelf.videoEditor setBGMLoop:YES];
						///是否关闭视频的原音 YES：关闭 NO：不需要关闭
					if ([strongSelf.musicOptString isEqualToString:@"YES"]) {
						strongSelf.videoSoundEditView.originSlider.value = 0.f;
						[strongSelf.videoEditor setVideoVolume:0.0f];
						[strongSelf.videoEditor setBGMVolume:0.5f];
						[strongSelf.videoSoundEditView.originSlider setEnabled:NO];
						[strongSelf.videoSoundEditView.bgmSlider setValue:0.5f];
					}else{
						[strongSelf.videoEditor setBGMVolume:0.5f];
						[strongSelf.videoEditor setVideoVolume:0.5f];
						strongSelf.videoSoundEditView.originSlider.value = 0.5f;
						[strongSelf.videoSoundEditView.bgmSlider setValue:0.5f];
						[strongSelf.videoSoundEditView.originSlider setEnabled:YES];
					}
					[strongSelf.videoEditor startPlayFromTime:0 toTime:strongSelf.videoDuration];
					dispatch_barrier_sync(dispatch_get_main_queue(), ^{
						[strongSelf.videoPreview setPlayBtn:YES];
					});
				}];
				return;
			}
			[weakSelf.videoEditor setBGM:weakSelf.clipsMusicInfo.musicPath result:^(int result) {
				__strong typeof(weakSelf)strongSelf = weakSelf;
				[strongSelf.videoEditor setBGMStartTime:0 endTime:strongSelf.clipsMusicInfo.duration];
				[strongSelf.videoEditor setBGMLoop:YES];
					///是否关闭视频的原音 YES：关闭 NO：不需要关闭
				if ([strongSelf.musicOptString isEqualToString:@"YES"]) {
					strongSelf.videoSoundEditView.originSlider.value = 0.f;
					[strongSelf.videoEditor setVideoVolume:0.0f];
					[strongSelf.videoEditor setBGMVolume:0.5f];
					[strongSelf.videoSoundEditView.originSlider setEnabled:NO];
					[strongSelf.videoSoundEditView.bgmSlider setValue:0.5f];
				}else{
					[strongSelf.videoEditor setBGMVolume:0.5f];
					[strongSelf.videoEditor setVideoVolume:0.5f];
					strongSelf.videoSoundEditView.originSlider.value = 0.5f;
					[strongSelf.videoSoundEditView.bgmSlider setValue:0.5f];
					[strongSelf.videoSoundEditView.originSlider setEnabled:YES];
				}
				[strongSelf.videoEditor startPlayFromTime:0 toTime:strongSelf.videoDuration];
				dispatch_barrier_sync(dispatch_get_main_queue(), ^{
					[strongSelf.videoPreview setPlayBtn:YES];
				});
			}];
		} else {
			[self.video_topOpt_View setSelectedStatus:NO opt:@"音乐"];
			[self.video_topOpt_View setSelectedEnable:NO opt:@"原音"];
			self.optionModel = nil;
			self.timeRange   = kCMTimeRangeZero;
			self.clipsMusicInfo = nil;
		}
	}
}


- (instancetype)initWithCoverImage:(UIImage *)coverImage
						 videoPath:(NSString*)videoPath
						 musicpath:(MusicInfo*)musicInfo
						renderMode:(TX_Enum_Type_RenderMode)renderMode
					  isFromRecord:(BOOL)isFromRecord
{
	if (self = [super init]){
		_coverImage = coverImage;
		_videoPath  =  videoPath;
		_renderMode = renderMode;
		_clipsMusicInfo  = musicInfo;
		_videoTextInfos = [NSMutableArray new];
		_videoPaterInfos = [NSMutableArray new];
		NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
		NSString *videoFileName = [NSString stringWithFormat:@"%@%d.mp4", [NSString stringWithFormat:@"video%f", interval].md5String, arc4random()%10000];
		_videoOutputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:videoFileName];
		_userOptRotateResult = @"NO";
		if (_videoAsset == nil && _videoPath != nil) {
			NSURL *avUrl = [NSURL fileURLWithPath:_videoPath];
			_videoAsset = [AVAsset assetWithURL:avUrl];
		}
	}
	return self;
}
- (instancetype)initWithCoverImage:(UIImage *)coverImage
						videoAsset:(AVAsset*)videoAsset
						 videoPath:(NSString*)videoPath
						 musicpath:(MusicInfo*)musicInfo
						renderMode:(TX_Enum_Type_RenderMode)renderMode
					  isFromRecord:(BOOL)isFromRecord{
	if (self = [super init]) {
		_coverImage = coverImage;
		_renderMode = renderMode;
		_clipsMusicInfo  = musicInfo;
		_videoPath = videoPath;
		_videoTextInfos = [NSMutableArray new];
		_videoPaterInfos = [NSMutableArray new];
		NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
		NSString *videoFileName = [NSString stringWithFormat:@"%@%d.mp4", [NSString stringWithFormat:@"video%f", interval].md5String, arc4random()%10000];
		_videoOutputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:videoFileName];
		_userOptRotateResult = @"NO";
		if (videoAsset != nil) {
			_videoAsset = videoAsset;
		}
	}
	return self;
}
#pragma mark - load subViews
-(void)loadSubViews{
	__weak typeof(self)weakSelf = self;
	__block CGFloat bottom_padding = heightEx(8.f);
	self.video_topic_Electric_View.frame = CGRectMake(0, heightEx(35+8*1.5), KScreenWidth, KScreenHeight -heightEx(35+8*1.5 + 56.f));
	[self.view  addSubview:self.video_topic_Electric_View];
	if (self.draftVideo == nil) {
		[self.video_topic_Electric_View isVaild:NO params:@{} loadType:ReleaseLoadType];
	}
	[self.view addSubview:self.video_publish_Draft_View];
	[self.video_publish_Draft_View mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.and.right.mas_equalTo(weakSelf.view);
		make.height.mas_equalTo(@(heightEx(40)));
		make.bottom.mas_equalTo(weakSelf.view.mas_bottom).with.offset(-bottom_padding);
	}];
	__block CGFloat padding = widthEx(16.f);
	[self.view addSubview:self.video_topOpt_View];
	[self.video_topOpt_View mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.and.right.mas_equalTo(weakSelf.view);
		make.height.mas_equalTo(@(heightEx(35.f)));
		if (SC_iPhoneX) {
			make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(SC_StatusBarHeight+padding/2.f);
		}else{
			make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(padding/2.f);
		}
	}];
	[self.view  addSubview:self.video_right_Opt_View];
	__block CGFloat optViewWidth = widthEx(50.f);
	[self.video_right_Opt_View mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(weakSelf.video_topOpt_View.mas_bottom).with.offset(0.f);
		make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(-widthEx(12.f));
		make.width.mas_equalTo(@(optViewWidth));
	}];
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
	[self.navigationController setDelegate:self];
	self.navigationController.interactivePopGestureRecognizer.delegate = self;
	self.navigationController.interactivePopGestureRecognizer.enabled = NO;
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	[IQKeyboardManager sharedManager].enable = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	[[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
	[[IQKeyboardManager sharedManager]setEnable:NO];
	
	if (_videoPreview.isPlaying) {
		[self onVideoPause];
	}
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	if (!_videoPreview.isPlaying) {
		[_videoPreview playVideo];
	}
	__weak typeof(self)weakSelf = self;
	[[VideoRecordNoficationManager shareInstance]addObserverNotifications];
	[[VideoRecordNoficationManager shareInstance]runingProcessMonopolizeCallback:^(BOOL foreground) {
		__strong typeof(weakSelf)strongSelf = weakSelf;
		if (foreground == NO) {
			[strongSelf.videoPreview  setPlayBtn:NO];
			[strongSelf onVideoPause];
		}
		if (foreground) {
			[strongSelf.videoPreview  setPlayBtn:YES];
			[strongSelf onVideoResume];
		}
	}];
}
-(void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	[[VideoRecordNoficationManager shareInstance]removeAllObserverNotifications];
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	NSLog(@"%@",NSStringFromClass(self.navigationController.class));
	self.usingRotateCounter = 0.f;
	self.fd_interactivePopDisabled = YES;
	self.view.backgroundColor = [UIColor whiteColor];
	[self videoPreViewSubViews];
	[self configVideoArgs];
	_videoEditManager = [TX_WKGVideoEditManager shareInstance];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dazzleTruncatSearchMusicOberver:) name:DazzleTruncatSearchMusicNotification object:nil];
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoRotationSucceedCallback:) name:DazzleVideoRotateSucceedNotification object:nil];
	if ([NSStringFromClass(self.navigationController.class) isEqualToString:@"NewFaceBaseNavigationController"]){
		[self loadInterViewObjectViews];
	}else{
		[self loadSubViews];
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShowwing:) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
		
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
	}
	
}

-(void)loadInterViewObjectViews{
	__weak typeof(self)weakSelf = self;
	__block CGFloat padding = widthEx(16.f);
	[self.view addSubview:self.video_topOpt_View];
	[self.video_topOpt_View mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.and.right.mas_equalTo(weakSelf.view);
		make.height.mas_equalTo(@(heightEx(35.f)));
		if (SC_iPhoneX) {
			make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(SC_StatusBarHeight+padding/2.f);
		}else{
			make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(padding/2.f);
		}
	}];
	[self.view addSubview:self.video_right_Opt_View];
	[self.video_right_Opt_View setHidden:YES opt:@"选封面"];
	__block CGFloat optViewWidth = widthEx(50.f);
	[self.video_right_Opt_View mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(weakSelf.video_topOpt_View.mas_bottom).with.offset(0.f);
		make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(-widthEx(12.f));
		make.width.mas_equalTo(@(optViewWidth));
	}];
	[self.view addSubview:self.publishInterView_item_btn];
	self.publishInterView_item_btn.layer.masksToBounds = YES;
	self.publishInterView_item_btn.layer.cornerRadius = heightEx(20.f);
	[self.publishInterView_item_btn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.mas_equalTo(weakSelf.view.mas_bottom).with.offset(-padding);
		make.left.mas_equalTo(weakSelf.view.mas_left).mas_offset(widthEx(87.f));
		make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(-widthEx(87.f));
		make.height.mas_equalTo(@(heightEx(40.f)));
	}];
}

-(void)keyboardWillShowwing:(NSNotification*)notification{
	UIViewController * controller = [Tools currentViewController];
	if ([controller isKindOfClass:[HCY_EditVCardViewController class]])return;
	if (self.keyboardConfig == nil) {
		self.keyboardConfig = [[OOKeyboardConfig alloc]init];
	}
	CGFloat duration = [[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] floatValue];
	CGRect  keyboardFrame = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
	self.keyboardConfig.duration = duration;
	self.keyboardConfig.keyboardHeight = CGRectGetHeight(keyboardFrame);
		//当前那个输入框在父视图的位置是多少
	CGPoint point = [self.video_topic_Electric_View.textView convertPoint:CGPointZero toView:self.view];
	self.keyboardConfig.itemConvertSuperViewPos = fabs(point.y);
	self.keyboardConfig.superViewOffsetY = self.keyboardConfig.keyboardHeight;// (KScreenHeight - point.y);
																			  //当前视图偏移量
	[UIView animateWithDuration:self.keyboardConfig.duration  delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
		[self.video_topic_Electric_View.textView becomeFirstResponder];
		self.video_topic_Electric_View.frame = CGRectMake(0, heightEx(35+8*1.5) - self.keyboardConfig.superViewOffsetY , KScreenWidth, KScreenHeight -heightEx(35+8*1.5+ 56.f));
	} completion:^(BOOL finished) {
	}];
}

-(void)keyboardDidShow:(NSNotification*)notification{
	if (self.keyboardConfig == nil)return;
}

-(void)keyboardWillHide:(NSNotification*)notification{
	[self.video_topic_Electric_View.textView resignFirstResponder];
	[UIView animateWithDuration:self.keyboardConfig.duration delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
		self.video_topic_Electric_View.frame = CGRectMake(0, heightEx(35+8*1.5), KScreenWidth, KScreenHeight -heightEx(35+8*1.5 + 56.f));
		
	} completion:^(BOOL finished) {
		[self.view endEditing:YES];
	}];
}

-(void)keyboardDidHide:(NSNotification*)notification{
	[self.view endEditing:YES];
}

-(void)dealloc{
	[[NSNotificationCenter defaultCenter]removeObserver:self name:DazzleTruncatSearchMusicNotification object:nil];
	if (![NSStringFromClass(self.navigationController.class) isEqualToString:@"NewFaceBaseNavigationController"]){
		[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
		[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
		[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
	}
	[[VideoRecordNoficationManager shareInstance]removeAllObserverNotifications];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:DazzleVideoRotateSucceedNotification object:nil];
}

-(void)videoPreViewSubViews{
	_videoPreview = [[VideoPreview alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.view.frame),ScreenHeight) coverImage:nil];
	[_videoPreview setUserInteractionEnabled:YES];
	_videoPreview.delegate = self;
	UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTouchBGView:)];
	tapGesture.numberOfTapsRequired = 1;
	tapGesture.numberOfTouchesRequired = 1;
	[_videoPreview setUserInteractionEnabled:YES];
	[_videoPreview addGestureRecognizer:tapGesture];
	[self.view addSubview: _videoPreview];
}

-(void)configVideoArgs{
	TXPreviewParam *param = [[TXPreviewParam alloc] init];
	param.videoView = _videoPreview.renderView;
	param.renderMode = PREVIEW_RENDER_MODE_FILL_EDGE;
	TXVideoInfo *videoMsg = [TXVideoInfoReader getVideoInfoWithAsset:_videoAsset];
	CGFloat duration = videoMsg.duration;
	self.videoDuration = duration;
	_rightTime = duration;
	_leftTime  = 0.f;
	if (self.videoDuration == 0.f) {
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
		hud.mode = MBProgressHUDModeText;
		hud.detailsLabelFont = [UIFont systemFontOfSize:15];
		hud.detailsLabelText = @"改视频格式不支持～(o^^o)～";
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:YES afterDelay:1.0f];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self dimssViewControllerEvents:nil];
		});
		return;
	}
	self.videoEditor = [[TXVideoEditer alloc] initWithPreview:param];
	__strong  typeof(self)strongSelf = self;
	self.videoEditor.generateDelegate = strongSelf;
	self.videoEditor.previewDelegate = _videoPreview;
	[self.videoEditor setBGMLoop:YES];
	[self.videoEditor setVideoAsset:_videoAsset];
	if (self.clipsMusicInfo) {
		self.optionModel  = [MusicOptionalModel new];
		[self.videoEditor setVideoVolume:0.f];
		[self.video_topOpt_View setSelectedStatus:YES opt:@"音乐"];
		[self.video_topOpt_View setSelectedEnable:YES opt:@"原音"];
			///是否关闭视频的原音 YES：关闭 NO：不需要关闭
		if ([_musicOptString isEqualToString:@"YES"]) {
			__weak typeof(self)weakSelf = self;
			[self.videoEditor setBGM:self.clipsMusicInfo.musicPath result:^(int result) {
				__strong typeof(weakSelf)strongSelf = weakSelf;
				[strongSelf.videoEditor setBGMStartTime:0 endTime:strongSelf.clipsMusicInfo.duration];
				[strongSelf.videoEditor setBGMLoop:YES];
					///是否关闭视频的原音 YES：关闭 NO：不需要关闭
				strongSelf.videoSoundEditView.originSlider.value = 0.f;
				[strongSelf.videoEditor setVideoVolume:0.0f];
				[strongSelf.videoEditor setBGMVolume:0.5f];
				[strongSelf.videoSoundEditView.originSlider setEnabled:NO];
				[strongSelf.videoSoundEditView.bgmSlider setValue:0.5f];
				[strongSelf.videoEditor startPlayFromTime:0 toTime:strongSelf.videoDuration];
				[strongSelf.videoPreview setPlayBtn:YES];
			}];
		}else{
			[self.videoEditor setVideoVolume:0.5f];
			[self.videoEditor setBGMVolume:0.5f];
			self.videoSoundEditView.originSlider.value = 0.5f;
			self.videoSoundEditView.bgmSlider.value    = 0.5f;
			[self.videoSoundEditView.originSlider setEnabled:YES];
			[self.videoEditor startPlayFromTime:0 toTime:self.videoDuration];
			[self.videoPreview setPlayBtn:YES];
		}
	}else{
		[self.videoEditor setVideoVolume:0.5f];
		[self.videoEditor setBGMVolume:0.5f];
		self.videoSoundEditView.originSlider.value = 0.5f;
		self.videoSoundEditView.bgmSlider.value    = 0.5f;
		[self.videoSoundEditView.originSlider setEnabled:YES];
		[self.videoEditor startPlayFromTime:0 toTime:self.videoDuration];
		[self.videoPreview setPlayBtn:YES];
	}
}


-(void)viewDidLayoutSubviews{
	[super viewDidLayoutSubviews];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		UIView * lastObjectView = (UIView*)[[self.video_right_Opt_View subviews]lastObject];
		__block CGFloat maxY = CGRectGetMaxY(lastObjectView.frame) + widthEx(12.f);
		__weak  typeof(self)weakSelf = self;
		[self.video_right_Opt_View mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(-widthEx(12.f));
			make.top.mas_equalTo(weakSelf.video_topOpt_View.mas_bottom).with.offset(widthEx(8.f));
			make.width.mas_equalTo(@(widthEx(50.f)));
			make.height.mas_equalTo(@(maxY));
		}];
	});
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
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

-(void)videoRotationSucceedCallback:(NSNotification*)notification{
	[self.hud hide:YES afterDelay:0.f];
	self.hud = nil;
	id object = notification.object;
	if ([object isKindOfClass:[NSDictionary class]]) {
		NSDictionary * param = (NSDictionary*)object;
		NSString * type = param[@"type"];
		NSURL * videoUrl =param[@"url"];
		if ([type isEqualToString:@"videoRotate"] && videoUrl){
			AVAsset * videoAsset = [AVAsset assetWithURL:videoUrl];
			[self.videoEditor setVideoAsset:videoAsset];
			[self.videoEditor setCutFromTime:_leftTime toTime:_rightTime];
			[self.videoEditor generateVideo:VIDEO_COMPRESSED_720P videoOutputPath:_videoOutputPath];
		}
	}
}

#pragma mark - 储存草稿箱| 发布作品
-(void)prepareGenerateVideo:(NSString*)optString{
	[[UIApplication sharedApplication]beginIgnoringInteractionEvents];
	self.prepareGenerateTypeString = optString;
	[self onVideoPause];
	if ([self.userOptRotateResult isEqualToString:@"YES"]) {
		NSURL * fileURL = [NSURL fileURLWithPath:_videoPath];
		NSString * audioPath =  self.clipsMusicInfo.musicPath;
		if (_hud == nil) {
			self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
			self.hud.mode = MBProgressHUDModeDeterminate;
		}
		self.hud.labelText  = [NSString stringWithFormat:@"拼命处理中..."];
		CGFloat degress  = (self.usingRotateCounter % 4) * 90;
		[[VideoClipsTool shareInstance]transformVedioScreenWithUrl:fileURL audioPath:audioPath oritation:KDeviceOritationPortrait degress:degress successHandle:^(AVMutableVideoComposition *mutableVideoComposition, NSURL *url) {
		}];
	}else{
		if (_hud == nil) {
			self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
			self.hud.mode = MBProgressHUDModeDeterminate; //正在努力合成中
			self.hud.labelText  = [NSString stringWithFormat:@"正在努力合成中0.0%%"];
		}
		[self.videoEditor setCutFromTime:_leftTime toTime:_rightTime];
		[self.videoEditor generateVideo:VIDEO_COMPRESSED_720P videoOutputPath:_videoOutputPath];
	}
	self.usingRotateCounter = 0;
}

#pragma mark - TXVideoGenerateListener Delegate
-(void) onGenerateProgress:(float)progress{
	if (_hud != nil) {
		self.hud.mode = MBProgressHUDModeDeterminate;
		self.hud.labelText  = [NSString stringWithFormat:@"正在努力合成中%.2f%%",progress*100];
	}
}

-(void) onGenerateComplete:(TXGenerateResult *)result{
	[self.hud hide:YES afterDelay:1.f];
	[[UIApplication sharedApplication]endIgnoringInteractionEvents];
	if (result.retCode == 0){
			//获取视频的第一帧图片
		if (_coverImage == nil && _selectedCoverImage == nil) {
			__weak  typeof(self)weakSelf = self;
			dispatch_async(dispatch_queue_create("com.wkg.cn", DISPATCH_QUEUE_CONCURRENT), ^{
				[[VideoClipsTool shareInstance]videoClipsTimeBySecond:0.1 url:_videoPath handler:^(UIImage * image) {
					__strong typeof(weakSelf)strongSelf = weakSelf;
					strongSelf.selectedCoverImage = image;
					dispatch_barrier_async(dispatch_get_main_queue(), ^{
						[strongSelf publishOrSaveDraftOpetEvents];
					});
				}];
			});
		}else{
			if (_coverImage != nil) {
				self.selectedCoverImage = _coverImage;
			}
			if (_selectedCoverImage !=nil) {
				self.selectedCoverImage = _selectedCoverImage;
			}
			[self publishOrSaveDraftOpetEvents];
		}
	}else{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"视频生成失败"message:[NSString stringWithFormat:@"错误码：%ld 错误信息：%@",(long)result.retCode,result.descMsg]delegate:nil
												  cancelButtonTitle:@"知道了"
												  otherButtonTitles:nil, nil];
		[alertView show];
	}
}

-(void)publishOrSaveDraftOpetEvents{
	if ([self.prepareGenerateTypeString isEqualToString:@"存草稿"]) {
		dispatch_async(dispatch_get_main_queue(), ^{
				//关闭之前视频录制
			[[TX_WKGRecordFileManager shareInstanace]stopCameraVideoRecordPreview];
			NSURL * url = [NSURL fileURLWithPath:_videoOutputPath];
			[self videoSaveDraftWith:url thumbnail:self.selectedCoverImage];
		});
	}else if ([self.prepareGenerateTypeString isEqualToString:@"发布作品"]){
		dispatch_async(dispatch_get_main_queue(), ^{
			[[TX_WKGRecordFileManager shareInstanace]stopCameraVideoRecordPreview];
			NSURL * url = [NSURL fileURLWithPath:_videoOutputPath];
			[self publishVideo:url thumbnail:self.selectedCoverImage];
			[self savePhotoAlbum:url];
		});
		
	}else if ([self.prepareGenerateTypeString isEqualToString:@"下一步"]){
		dispatch_async(dispatch_get_main_queue(), ^{
			CY_YBIssueViewController * viewController = [[CY_YBIssueViewController alloc]initWithVideoPth:_videoOutputPath coverImage:self.selectedCoverImage];
			[self.navigationController pushViewController:viewController animated:YES];
		});
	}
}

	//将编辑好视频存放本地
-(void)savePhotoAlbum:(NSURL*)fileURL{
	__block PHObjectPlaceholder *placeholder;
	if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(fileURL.path)) {
		NSError *error;
		[[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
			PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:fileURL];
			placeholder = [createAssetRequest placeholderForCreatedAsset];
		} error:&error];
	}
}
	//将存放本地视频删除
-(void)deletealbum:(NSURL*)fileUrl{
	if ( [[NSFileManager defaultManager]fileExistsAtPath:_videoOutputPath]) {
		[[NSFileManager defaultManager]removeItemAtPath:_videoOutputPath error:nil];
	}
}
	//视频储存草稿功能
-(void)videoSaveDraftWith:(NSURL*)path thumbnail:(UIImage *)thumbnail{
	[self creatSandBoxFilePathIfNoExist:@"Image"];
	NSString *pathDocuments = SC_CachesDirectoryPath;
	NSString *coverPath = [NSString stringWithFormat:@"%@/Image", pathDocuments];
	NSData *data = UIImagePNGRepresentation(thumbnail);  // 封面图片数据
	NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
		// 视频文件名
	NSString *videoFileName = [NSString stringWithFormat:@"%@%d.MOV", [NSString stringWithFormat:@"video%f", interval].md5String, arc4random()%10000];
		// 图片文件名
	NSString *imageFileName = [NSString stringWithFormat:@"image%f%d", interval, arc4random()%10000];
	VideoDraftTool *tool;
	if (self.draftVideo) {
		tool = self.draftVideo;
	} else {
		tool = [VideoDraftTool shareInstance];
	}
	self.tool = tool;
	tool.topicModel = self.topicModel;
	tool.companyModel = self.companyArgs;
	tool.personModel = self.personArgs;
	tool.introduce = self.video_topic_Electric_View.textView.text.length == 0 ? @"": self.video_topic_Electric_View.textView.text;
	tool.videoUrl = videoFileName;
	if (self.personArgs == nil && self.companyArgs == nil) {
		tool.dazzleType = @"0";
		tool.cardType  =  @"0";
	}else{
		tool.dazzleType = @"1";
			// 电子名片类型:0个人，1公司
		if (self.personArgs) {
			tool.cardType = @"0";
		}else if (self.companyArgs){
			tool.cardType = @"1";
		}
	}
		//是否包含音乐
	tool.containMusic = (self.clipsMusicInfo != nil) ? @"YES" : @"NO";
	if ([tool.containMusic isEqualToString:@"YES"]) {
		tool.musicUrl = self.clipsMusicInfo.musicPath;
	}
	[SVProgressHUD showWithStatus:@"保存草稿中" maskType:SVProgressHUDMaskTypeBlack];
		// 图片写入本地
	NSString *coverSandPath = [coverPath stringByAppendingPathComponent:imageFileName.md5String];
	BOOL sussce = [data writeToFile:coverSandPath atomically:YES];
	if (sussce) {
		tool.coverUrl = imageFileName.md5String;
		if (self.lastDraftCover.length) {
				// 删除之前的图片
			NSFileManager *fileManager = [NSFileManager defaultManager];
			NSString *coverSandPath = [coverPath stringByAppendingPathComponent:self.lastDraftCover];
			[fileManager removeItemAtPath:coverSandPath error:nil];
		}
	}
		// 视频写入本地
	[self convertVideoWithUrl:path fileName:videoFileName];
}

#pragma mark - 保存草稿
- (void)convertVideoWithUrl:(NSURL *)url fileName:(NSString *)fileName{
	[self creatSandBoxFilePathIfNoExist:@"Video"];
		//保存至沙盒路径
	NSString *pathDocuments = SC_CachesDirectoryPath;
	NSString *videoPath = [NSString stringWithFormat:@"%@/Video", pathDocuments];
	NSString *sandboxPath = [videoPath stringByAppendingPathComponent:fileName];
	NSFileManager *flieManager = [NSFileManager defaultManager];
	if ([flieManager fileExistsAtPath:sandboxPath]) {
		[flieManager removeItemAtPath:sandboxPath error:nil];
	}
	if ([flieManager fileExistsAtPath:url.resourceSpecifier]) { // 存在文件，移动目录
		BOOL success = [flieManager copyItemAtPath:url.resourceSpecifier toPath:sandboxPath error:nil];
		if (success) {
			[self saveVideoSuccess];
		} else {
			[self saveVideoFailure];
		}
		return;
	}
		//转码配置
	AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
	NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
	NSString *presetName;
	if ([compatiblePresets containsObject:AVAssetExportPreset3840x2160]) {
		presetName = AVAssetExportPreset3840x2160;
	}else if ([compatiblePresets containsObject:AVAssetExportPreset1920x1080]) {
		presetName = AVAssetExportPreset1920x1080;
	}else if ([compatiblePresets containsObject:AVAssetExportPreset1280x720]) {
		presetName = AVAssetExportPreset1280x720;
	}else if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
		presetName = AVAssetExportPresetHighestQuality;
	}else {
		presetName = AVAssetExportPresetMediumQuality;
	}
	AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:presetName];
	exportSession.shouldOptimizeForNetworkUse = YES;
	exportSession.outputURL = [NSURL fileURLWithPath:sandboxPath];
	
	NSArray *supportedTypeArray = exportSession.supportedFileTypes;
	if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
		exportSession.outputFileType = AVFileTypeMPEG4;
	} else if (supportedTypeArray.count == 0) {
		NSLog(@"No supported file types 视频类型暂不支持导出");
		return;
	} else {
		exportSession.outputFileType = [supportedTypeArray objectAtIndex:0];
	}
		//    //AVFileTypeMPEG4 文件输出类型，可以更改，是枚举类型，官方有提供，更改该值也可以改变视频的压缩比例
		//    exportSession.outputFileType = AVFileTypeMPEG4;
	SC_WeakSelf
	[exportSession exportAsynchronouslyWithCompletionHandler:^{
		int exportStatus = exportSession.status;
		SC_StrongSelf
		switch (exportStatus)
		{
			case AVAssetExportSessionStatusFailed:
			{
			NSLog(@"Failed:%@",exportSession.error);
			[strongSelf saveVideoFailure];
			break;
			}
			case AVAssetExportSessionStatusCompleted:
			{
			NSLog(@"视频转码成功");
			[strongSelf saveVideoSuccess];
			}
			case AVAssetExportSessionStatusCancelled:
			NSLog(@"Canceled:%@",exportSession.error);
			break;
			default:
			break;
		}
	}];
}

- (void)saveVideoSuccess{
	dispatch_async(dispatch_get_main_queue(), ^{
		[SVProgressHUD dismiss];
		[MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
		if (self.draftVideo) { // 二次编辑
			[self.tool updateVideoDraft];
		} else {
			[self.tool saveVideoDraft];
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:DazzleAllDidChagneDraftVideoNotification object:nil];
		[SVProgressHUD showSuccessWithStatus:@"保存成功"];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self dismissViewControllerAnimated:YES completion:nil];
		});
	});
}

- (void)saveVideoFailure{
	dispatch_async(dispatch_get_main_queue(), ^{
		[SVProgressHUD dismiss];
		[[UIApplication sharedApplication].keyWindow makeToast:@"保存草稿失败" duration:1.0 position:CSToastPositionCenter];
	});
}

- (void)creatSandBoxFilePathIfNoExist:(NSString *)path{
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSString *pathDocuments = SC_CachesDirectoryPath;
		//创建目录
	NSString *createPath = [NSString stringWithFormat:@"%@/%@", pathDocuments, path];
		// 判断文件夹是否存在，如果不存在，则创建
	if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
		[fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
	} else {
		NSLog(@"FileImage is exists.");
	}
}
	//视频发布
-(void)publishVideo:(NSURL*)path thumbnail:(UIImage *)thumbnail{
	UIImage  *image = thumbnail;
	NSDictionary *cityDic = [Tools queryCityInformationWithCityId:[NSString stringWithFormat:@"%ld",(long)[SingleClass sharedInstance].locatedCityId]];
	self.dazzleArgsModel = [Request_dazzle_addScDazzleDazzle new];
	self.dazzleArgsModel.userId = [UserDataManager userData].id.integerValue;
	if (self.companyArgs == nil && self.personArgs == nil) {
		NSString * introduce =  [self.video_topic_Electric_View.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		self.dazzleArgsModel.introduce = introduce.length == 0 ? @"":introduce;
		NSString * ids = self.topicModel.labelId ? self.topicModel.labelId : @"-1";
		self.dazzleArgsModel.labelId = ids;
		self.dazzleArgsModel.dazzleType = 0; // 炫类型:0视频，1电子名片
	}else{
		self.dazzleArgsModel.introduce = @"";
		self.dazzleArgsModel.labelId = @"-1";
		self.dazzleArgsModel.dazzleType = 1; // 炫类型:0视频，1电子名片
		if (self.personArgs) {
			self.dazzleArgsModel.cardType = 0;//,// 电子名片类型:0个人，1公司
			self.dazzleArgsModel.name = self.personArgs.name;//个人姓名或者公司名称
			self.dazzleArgsModel.sex = self.personArgs.sex;//男
			self.dazzleArgsModel.education = self.personArgs.education;//学历
			self.dazzleArgsModel.careerWebsite = self.personArgs.careerWebsite;//职业或者网站
			self.dazzleArgsModel.phone = self.personArgs.phone;//
		}if (self.companyArgs) {
			self.dazzleArgsModel.cardType = 1;//,// 电子名片类型:0个人，1公司
			self.dazzleArgsModel.name = self.companyArgs.name;//个人姓名或者公司名称
			self.dazzleArgsModel.careerWebsite = self.companyArgs.careerWebsite;//职业或者网站
			self.dazzleArgsModel.phone = self.companyArgs.phone;//
			self.dazzleArgsModel.employeeName = self.companyArgs.employeeName;
			self.dazzleArgsModel.companyPosition = self.companyArgs.companyPosition;
		}
	}
	
	if (self.cityTip && ![self.cityTip.address isEqualToString:@"不显示位置"]) {
		
		
			//反向地理编码
		
		CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
		
		CLLocation *cl = [[CLLocation alloc] initWithLatitude:self.cityTip.location.latitude longitude:self.cityTip.location.longitude];
		
		[clGeoCoder reverseGeocodeLocation:cl completionHandler: ^(NSArray *placemarks,NSError *error) {
			
			for (CLPlacemark *placeMark in placemarks) {
				NSDictionary *addressDic = placeMark.addressDictionary;
				
				NSString *state=[addressDic objectForKey:@"State"];
				NSString *city=[addressDic objectForKey:@"City"];
				NSDictionary * dic = [Tools queryCityInformation:city];
				if (dic) {
					self.dazzleArgsModel.releaseProvince = dic[@"parentcode"];
					self.dazzleArgsModel.releaseCity  = dic[@"code"];
				}
				self.dazzleArgsModel.address  = self.cityTip.name;
				self.dazzleArgsModel.longitude = self.cityTip.location.latitude;
				self.dazzleArgsModel.latitude =  self.cityTip.location.latitude;
			}
			
		}];
		
	}else{
		self.dazzleArgsModel.longitude = [SingleClass sharedInstance].placemarkModel.longitude;
		self.dazzleArgsModel.latitude = [SingleClass sharedInstance].placemarkModel.latitude;
		self.dazzleArgsModel.address  = [SingleClass sharedInstance].placemarkModel.address;
		self.dazzleArgsModel.releaseProvince = cityDic[@"parentcode"] ? cityDic[@"parentcode"] : @"";
		self.dazzleArgsModel.releaseCity = [NSString stringWithFormat:@"%zd",[SingleClass sharedInstance].placemarkModel.cityId];
	}
	
	
	self.dazzleArgsModel.coverUrl  = @"";
	self.dazzleArgsModel.videoUrl  = @"";
	
	self.dazzleArgsModel.dazzleState = 1;//,// 状态:0草稿，1发布,-1删除
	self.dazzleArgsModel.width =   image.size.width;
	self.dazzleArgsModel.height =  image.size.height;
	self.dazzleArgsModel.isShowShop = (self.video_topic_Electric_View.cloudSelected == YES) ? @"1" : @"0";
	_videoEditManager.dazzleArgsModel = self.dazzleArgsModel;
	__weak typeof(self)weakSelf = self;
	[[CityUploadQueueManager sharedManager] uploadVideoWithURL:path videoTime:0 cover:thumbnail sourceType:CityUploadModelSourceTypeAllDazzele dict:[self.dazzleArgsModel mj_keyValues] uploadHandler:^(NSDictionary *dict, NSArray *imageOSSURLs, NSString *videoOSSURL, CityUploadModel *uploadModel, void (^success)(void), void (^failure)(void)) {
		__strong typeof(weakSelf)strongSelf = weakSelf;
		_videoEditManager.dazzleArgsModel.coverUrl = imageOSSURLs.firstObject;
		_videoEditManager.dazzleArgsModel.videoUrl = videoOSSURL;
		[AllShowRequestManager connectWithModel:_videoEditManager.dazzleArgsModel WithUrlSring:HOST isShowLoading:NO success:^(id dic) {
				// 删除存放在系统相册视频
			[strongSelf deletealbum:path];
			[[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshDataWithSendVideo" object:nil];
			[[NSNotificationCenter defaultCenter] postNotificationName:DazzleAllDidPublishVideoSuccessNotification object:nil];
			if (strongSelf.draftVideo) {
				[strongSelf.draftVideo deleteVideoDraftById:strongSelf.draftVideo.ID];
				[[NSNotificationCenter defaultCenter] postNotificationName:DazzleAllDidChagneDraftVideoNotification object:nil];
			}
			if (success) {
				success();
			}
		} failure:^(NSError *error) {
			if (failure) {
				failure();
			}
		} error:^(NSString *message) {
			if (failure) {
				failure();
			}
		}];
	}];
	[self.videoEditor stopPlay];
	dispatch_async(dispatch_get_main_queue(), ^{
		[MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
					   dispatch_get_main_queue(), ^{
						   [self dismissViewControllerAnimated:YES completion:nil];
					   });
	});
}


@end

