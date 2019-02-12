//
//  TX_WKG_VideoRecordController.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/3/29.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_VideoRecordController.h"
#import "TX_Record_TopOptView.h"
#import "TX_WKG_Record_BottomView.h"
#import "VideoRecordStepView.h"
#import "TX_WKG_RecordItemView.h"
#import "TX_WKG_ProgressView.h"
#import "TX_Record_SpeedOptView.h"
#import "TX_Record_InterrputView.h"

#import <TXLiteAVSDK_Professional/TXLiveSDKTypeDef.h>
#import <TXLiteAVSDK_Professional/TXVideoEditer.h>
#import "HJAlertViewController.h"
#import "HCY_SelectMusicViewController.h"
#import "MusicOptionalModel.h"
#import "MusicPauseOrPlayOptModel.h"
#import "QMX_MusicTool.h"
#import "MusicInfo.h"
//音乐
#import "BeautySettingPanel.h"
#import "VideoAudioPlayer.h"
//滤镜
#import "HXPhotoManager.h"
#import "VideoRecordNoficationManager.h"
#import "TX_WKG_VideoEditViewController.h"
#import "TX_WKGRecordFileManager.h"
#import "TX_WKG_VideoRecord_AuthorizateManager.h"
#import "Dazzle_Video_PreViewingController.h"

#define MAX_RECORD_TIME             180
#define MIN_RECORD_TIME             3

@interface TX_WKG_VideoRecordController ()<TXUGCRecordListener,TXVideoCustomProcessDelegate,HXAlbumListViewControllerDelegate,BeautySettingPanelDelegate,BeautyLoadPituDelegate,TXVideoJoinerListener,TXVideoPreviewListener>

@property (strong, nonatomic) TX_WKG_ProgressView * progressView;
@property (strong, nonatomic) TX_Record_TopOptView * topOptView;
@property (strong, nonatomic) TX_WKG_Record_BottomView *bottomView;
@property (strong, nonatomic) TX_WKG_RecordItemView *recordItemView;
@property (strong, nonatomic) VideoRecordStepView *videoRecordStepView;
@property (strong, nonatomic) TX_Record_SpeedOptView *speedOptView;
@property (strong, nonatomic) TX_Record_InterrputView *interruptView;
@property (strong, nonatomic) NSMutableArray * subViewsContainer;
@property (strong, nonatomic) UIImageView * videoRecordBackgroundImgView;

@property (strong, nonatomic) MusicOptionalModel * optionModel;
@property (strong, nonatomic) MusicInfo * clipsMusicInfo;
@property (assign, nonatomic) CMTimeRange  timeRange;
@property (strong, nonatomic) VideoConfigure * videoConfigure;
@property (strong, nonatomic) UIView * videoRecordView;
@property (assign, nonatomic) NSInteger countdownTime;
@property (strong, nonatomic) UIView * countdownView;
@property (strong, nonatomic) UILabel * title_label;
@property (strong, nonatomic) dispatch_source_t timer;
@property (strong, nonatomic) BeautySettingPanel *beautySettingPanel;
@property (strong, nonatomic) VideoAudioPlayer *videoAudioPlayer;
@property (strong, nonatomic) UIView * coverView;
@property (strong, nonatomic) HXPhotoManager * photoManager;
@property (strong, nonatomic) AVAssetExportSession * exportSession;
@property (strong, nonatomic) NSTimer * exportProgressTiemer;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) TXVideoJoiner  * videoJoiner;
@property (copy, nonatomic) NSString * outFilePath;
@property (copy, nonatomic) NSString * tx_wkgRecordVideoPath;
@property (copy, nonatomic) NSString * hasEditVideo;
@property (strong, nonatomic) TX_WKGRecordFileManager * recordFileManager;
@property (copy, nonatomic) NSString * deleteVideoOptString; // YES:回删
@property (assign, nonatomic) CGFloat  recordDuration;
@property (strong, nonatomic) HXAlbumListViewController * albumListViewController;
@property (copy, nonatomic) NSString * settingMusicPath;
@property (assign, nonatomic) NSInteger resumeCount;//记录被暂停次数
@property (copy, nonatomic) NSString * shouldStartCameraPerView; //yes:开启 no：不开启


@end

void * ObserverVideoRecordProgressKey = &ObserverVideoRecordProgressKey;
void * ObserverVodeoProgressTimeDurationKey = &ObserverVodeoProgressTimeDurationKey;
@implementation TX_WKG_VideoRecordController
#pragma mark - 当视频的录制时长大于或者等于最大时长时候
-(void)autoCompleteJoinVideo{
    if (self.videoAudioPlayer && self.optionModel) {
        [self.videoAudioPlayer stopPlay];
    }
    [self.recordItemView setCompleted:YES];
    [self.interruptView setSubViewHidddenWithTitle:@"返回" hidden:NO];
    [self.subViewsContainer enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setHidden:NO];
    }];
    [self finishedVideoRecord:YES];
}
#pragma mark - TXVideoJoinerListener Delegate
-(void)onJoinProgress:(float)progress{
    
    
}
-(void)onJoinComplete:(TXJoinerResult *)result{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (result.retCode == 0) {
        self.hasEditVideo = @"YES";
        _hud = nil;
        _videoJoiner  = nil;
        TX_WKG_VideoEditViewController * vc = [[TX_WKG_VideoEditViewController alloc]initWithCoverImage:nil videoPath:self.outFilePath musicpath:self.clipsMusicInfo renderMode:RENDER_MODE_FILL_SCREEN isFromRecord:YES];
        vc.musicOptString =  self.clipsMusicInfo != nil ? @"YES" : @"NO";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - TXVideoCustomProcessDelegate
- (GLuint)onPreProcessTexture:(GLuint)texture width:(CGFloat)width height:(CGFloat)height{
    return texture;
}

- (void)onTextureDestoryed{
}

- (void)onDetectFacePoints:(NSArray *)points{
    
}

#pragma mark - IBOutlet  optView Events
-(void)backdeleteVideoAlertView:(NSString*)msg callback:(void(^)())block {
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction * sure =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         if (block) {
             block();
        }
    }];
    [controller addAction:cancel];
    [controller addAction:sure];
    [self presentViewController:controller animated:YES completion:nil];
}

//整个视图添加一个单击手势
-(void)removeFilterViewFromSuperViewEvents:(UITapGestureRecognizer*)gesture{
    [self.interruptView setSubViewHidddenWithTitle:@"返回" hidden:NO];
    [self.subViewsContainer enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setHidden:NO];
    }];
    [self.beautySettingPanel removeFromSuperview];
    [self.coverView removeFromSuperview];
    [self.coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
    }];
    __weak  typeof(self)weakSelf = self;
    [[self.view gestureRecognizers]enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
            [weakSelf.view removeGestureRecognizer:obj];
        }
    }];
    [self.recordItemView setHidden:NO];
}

-(void)switchCameraRecordOritentation:(UIButton*)args{
    args.selected = !args.selected;
    //isFront 是否前后摄像头
    [[TXUGCRecord shareInstance]switchCamera:!args.selected];
}

-(void)switchCameraRecordFlicker:(UIButton*)args{
    if ([[TXUGCRecord shareInstance]toggleTorch:YES]) {
        args.selected = !args.selected;
        [[TXUGCRecord shareInstance]toggleTorch:args.selected];
    }else{
        [args setImage:[UIImage imageNamed:@"qmx_paishe_shanguang"] forState:UIControlStateNormal];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelFont = [UIFont systemFontOfSize:15];
        hud.detailsLabelText = @"前置摄像头不支持闪光灯";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5f];
    }
}

-(void)restartDelayRecordVideo:(UIButton*)args{
    args.selected = !args.selected;
    self.countdownTime = args.selected ? 3.f : 0.f;
    if (args.selected) {
        __weak typeof(self)weakSelf = self;
        [self.view addSubview:self.countdownView];
        [self.countdownView addSubview:self.title_label];
        [self.countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsZero);
        }];
        [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.countdownView.mas_centerY);
            make.centerX.mas_equalTo(weakSelf.countdownView.mas_centerX);
        }];
            dispatch_queue_t queue = dispatch_get_main_queue();
            self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW,1.f * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
            dispatch_source_set_event_handler(self.timer, ^{
                if (self.countdownTime < 1) {
                    dispatch_cancel(self.timer);
                    [args setSelected:NO];
                    [self.recordItemView delayRecordVideoWithManner:TX_WKG_VideoManner_SingleTip];
                    [self.subViewsContainer enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [obj setHidden:YES];
                    }];
                    if (self.progressView.videofragmentViews.count == 0) {
                        //如果是手动删除的话
                        if ([self.deleteVideoOptString isEqualToString:@"YES"]) {
                            [self resumeVideoRecord:NO];
                        }else{
                            [self startVideoRecord:NO];
                        }
                    }else{
                        [self resumeVideoRecord:NO];
                    }
                    self.countdownTime = 3.f;
                    [self.title_label removeFromSuperview];
                    [self.title_label mas_remakeConstraints:^(MASConstraintMaker *make) {
                    }];
                    [self.countdownView removeFromSuperview];
                    [self.countdownView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    }];
                }else{
                    self.title_label.text = [NSString stringWithFormat:@"%zd",self.countdownTime];
                    [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.title_label.font = [UIFont boldSystemFontOfSize:80];
                        self.title_label.transform = CGAffineTransformScale(self.title_label.transform, 3.f, 3.f);
                    } completion:^(BOOL finished) {
                        self.title_label.font = [UIFont boldSystemFontOfSize:0.f];
                        self.title_label.transform = CGAffineTransformIdentity;
                        self.countdownTime --;
                    }];
                }
            });
            dispatch_resume(self.timer);
    }else{
        self.title_label.text = @"3";
        [self.title_label removeFromSuperview];
        [self.title_label mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        [self.countdownView removeFromSuperview];
        [self.countdownView mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
    }
}

-(void)selectMusicEvents:(UIButton*)args{
    __weak typeof(self) weakSelf = self;
    if (self.optionModel) {
        HJAlertViewController *alert = [HJAlertViewController actionWithCancelTitle:@"取消" cancelStyle:UIAlertActionStyleCancel otherTitles:@[@"更换音乐", @"关闭音乐"] extraData:nil andCompleteBlock:^(UIAlertController *alertVC, NSInteger buttonIndex) {
            SC_StrongSelf
            if (buttonIndex) { // 关闭音乐
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [strongSelf.topOptView setSelectedStatus:NO opt:
                     @"音乐"];
                    strongSelf.optionModel = nil;
                    strongSelf.timeRange = kCMTimeRangeZero;
                    strongSelf.clipsMusicInfo = nil;
                    [[TXUGCRecord shareInstance]setBGM:nil];
                    if (![[TXUGCRecord shareInstance]stopBGM]) {
                        [[TXUGCRecord shareInstance]stopBGM];
                    }
                });
            } else{
                [self pushElectMusicToVC:args];
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
            strongSelf.clipsMusicInfo.start    = startTimeInterval;
            strongSelf.clipsMusicInfo.duration = endTimeInterval;
            [[TXUGCRecord shareInstance]setBGM:strongSelf.clipsMusicInfo.musicPath];
            [[TXUGCRecord shareInstance]setBGMVolume:1.f];
        } else {
            [opt setSelected:NO];
        }
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - getter methods
-(HXAlbumListViewController *)albumListViewController{
    _albumListViewController = ({
        if (!_albumListViewController) {
            _albumListViewController = [[HXAlbumListViewController alloc]init];
        }
        _albumListViewController;
    });
    return _albumListViewController;
}

-(UIView *)coverView{
    _coverView = ({
        if (!_coverView) {
            _coverView = [[UIView alloc]initWithFrame:CGRectZero];
            _coverView.backgroundColor = [UIColor clearColor];
            [_coverView setUserInteractionEnabled:YES];
            UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeFilterViewFromSuperViewEvents:)];
            gesture.numberOfTapsRequired = 1.f;
            [_coverView addGestureRecognizer:gesture];
        }
        _coverView;
    });
    return _coverView;
}
-(BeautySettingPanel *)beautySettingPanel{
    _beautySettingPanel = ({
        if (_beautySettingPanel == nil) {
            _beautySettingPanel = [[BeautySettingPanel alloc]initWithFrame:CGRectMake(0, KScreenHeight - heightEx(172+50.f), CGRectGetWidth(self.view.frame), heightEx(172+50.f))];
            _beautySettingPanel.delegate = self;
            _beautySettingPanel.pituDelegate = self;
        }
        _beautySettingPanel;
    });
    return _beautySettingPanel;
}

-(UIImageView *)videoRecordBackgroundImgView{
    _videoRecordBackgroundImgView = ({
        if (!_videoRecordBackgroundImgView) {
            _videoRecordBackgroundImgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            _videoRecordBackgroundImgView.contentMode = UIViewContentModeScaleAspectFill;
            _videoRecordBackgroundImgView.image = [UIImage imageNamed:@"qmx_paishe_bg"];
        }
        _videoRecordBackgroundImgView;
    });
    return _videoRecordBackgroundImgView;
}

-(NSMutableArray *)subViewsContainer{
    _subViewsContainer = ({
        if (!_subViewsContainer) {
            _subViewsContainer = [NSMutableArray array];
        }
        _subViewsContainer;
    });
    return _subViewsContainer;
}

-(TX_Record_InterrputView *)interruptView{
    _interruptView = ({
        if (!_interruptView) {
            _interruptView = [[TX_Record_InterrputView alloc]initWithFrame:CGRectZero];
            _interruptView.backgroundColor = [UIColor clearColor];
            __strong typeof(self)weakSelf = self;
            _interruptView.callback = ^(NSString *title) {
                __strong  typeof(weakSelf)strongSelf = weakSelf;
                if ([title isEqualToString:@"返回"]) {
                    [strongSelf backdeleteVideoAlertView:@"是否放弃当前录制视频?" callback:^{
                        [[[TXUGCRecord shareInstance]partsManager]deleteAllParts];
                        [strongSelf dismissViewControllerAnimated:YES completion:nil];
                        [[TXUGCRecord shareInstance]stopCameraPreview];
                        [[TXUGCRecord shareInstance]stopRecord];
                        if (strongSelf.videoAudioPlayer && strongSelf.optionModel) {
                            [strongSelf.videoAudioPlayer stopPlay];
                        }
                    }];
                }else if ([title isEqualToString:@"下一步"]){
                    CGFloat duration = strongSelf.recordDuration;
                    if (duration < 3.0f) {
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.detailsLabelFont = [UIFont systemFontOfSize:15];
                        hud.detailsLabelText = @"视频不能小于3秒";
                        hud.removeFromSuperViewOnHide = YES;
                        [hud hide:YES afterDelay:1.5f];
                        return;
                    }
                    if (strongSelf.progressView.videofragmentViews.count >0) {
                        if (strongSelf.videoAudioPlayer && strongSelf.optionModel) {
                            [strongSelf.videoAudioPlayer stopPlay];
                        }
                        [strongSelf.recordItemView setCompleted:YES];
                        [strongSelf.interruptView setSubViewHidddenWithTitle:@"返回" hidden:NO];
                        [strongSelf.subViewsContainer enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [obj setHidden:NO];
                        }];
                        [strongSelf finishedVideoRecord:YES];
                    }
                }
            };
        }
        _interruptView;
    });
    return _interruptView;
}

-(TX_Record_SpeedOptView *)speedOptView{
    _speedOptView = ({
        if (!_speedOptView) {
            _speedOptView = [[TX_Record_SpeedOptView alloc]initWithFrame:CGRectZero];
            _speedOptView.callback = ^(NSString *title) {
                if ([title isEqualToString:@"极慢"]) {
                    [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_SLOWEST];
                }else if ([title isEqualToString:@"慢"]){
                    [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_SLOW];
                }else if ([title isEqualToString:@"标准"]){
                    [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_NOMAL];
                }else if ([title isEqualToString:@"快"]){
                    [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_FAST];
                }else if ([title isEqualToString:@"极快"]){
                    [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_FASTEST];
                }
            };
        }
        _speedOptView;
    });
    return _speedOptView;
}

-(TX_WKG_ProgressView *)progressView{
    _progressView = ({
        if (!_progressView) {
            _progressView = [[TX_WKG_ProgressView alloc]initWithFrame:CGRectZero];
            _progressView.minimumValue = MIN_RECORD_TIME;
            _progressView.maximumValue = MAX_RECORD_TIME;
            _progressView.trackTintColor = [[UIColor blackColor]colorWithAlphaComponent:0.13];
            _progressView.thumbColor = rgba(248, 197, 68, 1.f);
            _progressView.indicatorColor = [UIColor whiteColor];
        }
        _progressView;
    });
    return _progressView;
}

-(TX_Record_TopOptView *)topOptView{
    _topOptView = ({
        if (!_topOptView) {
            _topOptView = [[TX_Record_TopOptView alloc]initWithFrame:CGRectZero];
            __weak  typeof(self)weakSelf = self;
            _topOptView.callback = ^(UIButton * args,NSString*title) {
                if (title == nil) return;
                __strong typeof(weakSelf)strongSelf = weakSelf;
                NSDictionary * json = @{@"前后":@"switchCameraRecordOritentation:",
                                        @"闪光":@"switchCameraRecordFlicker:",
                                        @"延迟":@"restartDelayRecordVideo:",
                                        @"音乐":@"selectMusicEvents:"
                                        };
                NSString * selector = json[title];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                SEL sel = NSSelectorFromString(selector);
                [strongSelf performSelector:sel withObject:args];
#pragma clang diagnostic pop
            };
        }
        _topOptView;
    });
    return _topOptView;
}
- (HXPhotoManager *)photoManager {
    if (!_photoManager) {
        _photoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypeVideo];
        _photoManager.configuration.photoMaxNum = 9;
        _photoManager.configuration.videoMaxNum = 1;
        _photoManager.configuration.maxNum = 10;
        _photoManager.configuration.selectTogether = NO;
        _photoManager.configuration.cameraCellShowPreview = NO;
        _photoManager.configuration.saveSystemAblum = YES;
        _photoManager.configuration.videoMaxDuration = 180;
        _photoManager.configuration.openCamera = NO;
    }
    return _photoManager;
}

-(TX_WKG_Record_BottomView *)bottomView{
    _bottomView = ({
        if (!_bottomView) {
            _bottomView = [[TX_WKG_Record_BottomView alloc]initWithFrame:CGRectZero];
            __weak typeof(self)weakSelf = self;
            _bottomView.eventCallback = ^(NSString *title) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                if ([title isEqualToString:@"特效滤镜"]) {
                    [strongSelf.view addSubview:strongSelf.beautySettingPanel];
                    [strongSelf.view addSubview:strongSelf.coverView];
                    [strongSelf.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.and.right.mas_equalTo(weakSelf.view);
                    make.bottom.mas_equalTo(weakSelf.view.mas_bottom).with.offset(-heightEx(175+50));
                    }];
                    [strongSelf.interruptView setSubViewHidddenWithTitle:@"返回" hidden:YES];
                    [strongSelf.subViewsContainer enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [obj setHidden:YES];
                    }];
                    [strongSelf.recordItemView setHidden:YES];
                }else if ([title isEqualToString:@"导入视频"]){
                    [strongSelf inportAlbumVideo];
                }else if([title isEqualToString:@"回删"]){
                    [strongSelf backdeleteVideoAlertView:@"是否删除最后一段录制视频?" callback:^{
                        if (strongSelf.progressView.videofragmentViews.count < 2) return;
                        strongSelf.deleteVideoOptString = @"YES";
                        [[[TXUGCRecord shareInstance]partsManager]deleteLastPart];
                        [strongSelf.progressView removelastProgressView];
                    }];
                }
            };
        }
        _bottomView;
    });
    return _bottomView;
}

-(VideoRecordStepView *)videoRecordStepView{
    _videoRecordStepView = ({
        if (!_videoRecordStepView) {
            _videoRecordStepView = [[VideoRecordStepView alloc]initWithFrame:CGRectZero];
            __weak typeof(self)weakSelf = self;
            _videoRecordStepView.block = ^(NSString *title) {
                if ([title isEqualToString:@"长按拍摄"]) {
                    weakSelf.recordItemView.videoRecordType = TX_WKG_VideoManner_LongPress;
                }else  if ([title isEqualToString:@"单击拍摄"]){
                    weakSelf.recordItemView.videoRecordType = TX_WKG_VideoManner_SingleTip;
                }
            };
        }
        _videoRecordStepView;
    });
    return _videoRecordStepView;
}

-(UILabel *)title_label{
    _title_label= ({
        if (!_title_label) {
            _title_label = [UILabel new];
            _title_label.text = @"3";
            _title_label.font = [UIFont boldSystemFontOfSize:20.f];
            _title_label.textColor = [UIColor whiteColor];
            _title_label.textAlignment = NSTextAlignmentCenter;
        }
    _title_label;
    });
    return _title_label;
}

-(UIView *)countdownView{
    _countdownView = ({
        if (!_countdownView) {
            _countdownView = [[UIView alloc]initWithFrame:CGRectZero];
            _countdownView.backgroundColor = [UIColor clearColor];
        }
        _countdownView;
    });
    return _countdownView;
}

-(TX_WKG_RecordItemView *)recordItemView{
    _recordItemView = ({
        if (!_recordItemView) {
            CGFloat recordItemY = ScreenHeight - (heightEx(45+65/2+8)+ widthEx(80)/2.f);
            _recordItemView = [[TX_WKG_RecordItemView alloc]initWithFrame:CGRectMake((KScreenWidth - widthEx(80))/2.f, recordItemY, widthEx(80), widthEx(80))];
            __weak  typeof(self)weakSelf =self;
            _recordItemView.cancelCallback = ^(TX_WKG_VideoManner videoType, BOOL isVideoRecordEnded) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                if (strongSelf.progressView.videofragmentViews.count == 0 && isVideoRecordEnded == NO) {
                    if ([strongSelf.deleteVideoOptString isEqualToString:@"YES"]) {
                        [strongSelf resumeVideoRecord:NO];
                    }else if([strongSelf.deleteVideoOptString isEqualToString:@"NO"]){
                        [strongSelf startVideoRecord:NO];
                    }
                }else if (strongSelf.progressView.videofragmentViews.count != 0){
                    if (isVideoRecordEnded) {
                        [strongSelf pauseVideoRecord:YES];
                    }else if (!isVideoRecordEnded){
                        [strongSelf resumeVideoRecord:NO];
                    }
                }else{
                    [strongSelf resumeVideoRecord:isVideoRecordEnded];
                }
                [strongSelf.subViewsContainer enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj setHidden:!isVideoRecordEnded];
                    [strongSelf.interruptView setSubViewHidddenWithTitle:@"返回" hidden:!isVideoRecordEnded];
                }];
             };
        }
        _recordItemView;
    });
    return _recordItemView;
}
#pragma mark  -Video Camera Configure
-(void)pauseVideoRecord:(BOOL)isVideoRecordEnded{
    if ([[TXUGCRecord shareInstance]pauseRecord] == 0) {
        if (self.clipsMusicInfo) {
            [[TXUGCRecord shareInstance]pauseBGM];
        }
        [self.progressView setVideoRecordPause:isVideoRecordEnded];
    }
}

-(void)resumeVideoRecord:(BOOL)isVideoRecordEnded{
    if ([[TXUGCRecord shareInstance]resumeRecord] == 0) {
        if (self.clipsMusicInfo) {
            if (self.settingMusicPath.length == 0 ||![self.settingMusicPath isEqualToString:self.clipsMusicInfo.musicPath]) {
                self.settingMusicPath = self.clipsMusicInfo.musicPath;
                [[TXUGCRecord shareInstance]setBGM:self.clipsMusicInfo.musicPath];
                [[TXUGCRecord shareInstance]setBGMVolume:1.f];
                [[TXUGCRecord shareInstance]playBGMFromTime:self.clipsMusicInfo.start toTime:self.clipsMusicInfo.duration withBeginNotify:^(NSInteger errCode) {
                } withProgressNotify:^(NSInteger progressMS, NSInteger durationMS) {
                } andCompleteNotify:^(NSInteger errCode) {
                }];
            }else{
                [[TXUGCRecord shareInstance]resumeBGM];
            }
        }
        [self.progressView setVideoRecordPause:isVideoRecordEnded];
    }
}

//当用户点击下一步时候，需要检查是否用视频片段
-(void)finishedVideoRecord:(BOOL)isVideoRecordEnded{
    if (_hud == nil) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeDeterminate;
    }
    self.hud.labelText  = [NSString stringWithFormat:@"正在拼接视频中..."];
    if ([[TXUGCRecord shareInstance]pauseRecord] == 0) {
        [self.progressView setVideoRecordPause:isVideoRecordEnded];
    }
    NSArray * videos = [[[TXUGCRecord shareInstance]partsManager]getVideoPathList];
    if (self.videoJoiner == nil) {
            TXPreviewParam *param = [[TXPreviewParam alloc] init];
            param.renderMode = PREVIEW_RENDER_MODE_FILL_EDGE;
            self.videoJoiner = [[TXVideoJoiner alloc]initWithPreview:param];
            [self.videoJoiner setVideoPathList:videos];
            self.videoJoiner.joinerDelegate  = self;
            self.videoJoiner.previewDelegate = self;
    [self.videoJoiner joinVideo:VIDEO_COMPRESSED_720P videoOutputPath:self.outFilePath];
    }
}

-(void)stopVideoRecord:(BOOL)isVideoRecordEnded{
    if ([[TXUGCRecord shareInstance] stopRecord] == 0) {
        if (self.clipsMusicInfo) {
            [[TXUGCRecord shareInstance]stopBGM];
        }
        [self.progressView setVideoRecordPause:isVideoRecordEnded];
    }
}

-(void)startVideoRecord:(BOOL)isVideoRecordEnded{
    [self setSpeedRate];
    if ([[TXUGCRecord shareInstance] startRecord] == 0) {
        if (self.clipsMusicInfo) {
            [[TXUGCRecord shareInstance]setBGM:self.clipsMusicInfo.musicPath];
            [[TXUGCRecord shareInstance]setBGMVolume:1.f];
            [[TXUGCRecord shareInstance]playBGMFromTime:self.clipsMusicInfo.start toTime:self.clipsMusicInfo.duration withBeginNotify:^(NSInteger errCode) {
            } withProgressNotify:^(NSInteger progressMS, NSInteger durationMS) {
            } andCompleteNotify:^(NSInteger errCode) {
            }];;
        }
        [self.progressView setVideoRecordPause:isVideoRecordEnded];
    }
}

-(void)setSpeedRate{
    NSDictionary * json = @{@"极慢":@(VIDEO_RECORD_SPEED_SLOWEST),
                            @"慢":@(VIDEO_RECORD_SPEED_SLOW),
                            @"标准":@(VIDEO_RECORD_SPEED_NOMAL),
                            @"快":@(VIDEO_RECORD_SPEED_FAST),
                            @"极快":@(VIDEO_RECORD_SPEED_FASTEST),
                            };
    [[TXUGCRecord shareInstance] setRecordSpeed:[json[self.speedOptView.selectButton.currentTitle]integerValue]];
    [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_NOMAL];
}

-(void)startCameraPreview{
    TXUGCCustomConfig * param = [[TXUGCCustomConfig alloc] init];
    param.videoResolution =  _videoConfigure.videoResolution;
    param.videoFPS = _videoConfigure.fps;
    param.videoBitratePIN = _videoConfigure.bps;
    param.GOP = _videoConfigure.gop;
    param.minDuration = MIN_RECORD_TIME;
    param.maxDuration = MAX_RECORD_TIME;
    if ([[TXUGCRecord shareInstance] startCameraCustom:param preview:self.videoRecordView] != 0) {
        [[TXUGCRecord shareInstance] startCameraCustom:param preview:self.videoRecordView];
    }
    [[TXUGCRecord shareInstance] setAspectRatio:VIDEO_ASPECT_RATIO_9_16];
    [TXUGCRecord shareInstance].videoProcessDelegate = self;
    [TXUGCRecord shareInstance].recordDelegate = self;
}

-(void)subViewsIntoContainer{
    [self.subViewsContainer addObject:self.topOptView];
    [self.subViewsContainer addObject:self.bottomView];
    [self.subViewsContainer addObject:self.videoRecordStepView];
    [self.subViewsContainer addObject:self.speedOptView];
}

#pragma mark set
-(instancetype)initWithConfigure:(VideoConfigure*)configure{
    if (self = [super init]) {
        [TXUGCRecord shareInstance].recordDelegate = self;
        _videoConfigure = configure;
        //添加自定义视频录制路径
        self.view.backgroundColor = [UIColor blackColor];
        //添加各种通知
        self.shouldStartCameraPerView = @"YES";
    }
    return self;
}

-(void)setgpuCameraViews{
    self.videoRecordView = [[UIView alloc]initWithFrame:self.view.frame];
    self.videoRecordView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.videoRecordView];
}

-(void)setObjectViews{
    [self setgpuCameraViews];
    __weak typeof(self)weakSelf = self;
    __block CGFloat optViewWidth = widthEx(80.f+12.f);
    __block CGFloat padding = widthEx(12.f);
     self.countdownTime = 3.f;
    [self.view addSubview:self.videoRecordBackgroundImgView];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.interruptView];
    [self.view addSubview:self.topOptView];
    [self.view addSubview:self.speedOptView];
    [self.view addSubview:self.videoRecordStepView];
    [self.view addSubview:self.bottomView];
    [self.videoRecordBackgroundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsZero);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(padding);
          make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(-padding);
        make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(padding/3.f);
        make.height.mas_equalTo(@(padding/2.5f));
    }];
    [self.interruptView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (SC_iPhoneX) {
    make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(SC_StatusBarHeight+padding);
        }else{
        make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(padding);
        }
        make.left. mas_equalTo(weakSelf.progressView.left);
        make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(-padding);
        make.height.mas_equalTo(@(heightEx(33.f)));
    }];
    [self.topOptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.interruptView.mas_bottom).with.offset(padding);
        make.width.mas_equalTo(@(optViewWidth));
    }];
    [self.videoRecordStepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(@(heightEx(45.f)));
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf.view);
        make.height.mas_equalTo(@(heightEx(65.f)));
    make.bottom.mas_equalTo(weakSelf.videoRecordStepView.mas_top).with.offset(heightEx(-8.f));
    }];
    __block CGFloat speedViewMargin = widthEx(40.f);
    [self.speedOptView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(speedViewMargin);
        make.right.mas_equalTo(weakSelf.view.mas_right).with.offset(-speedViewMargin);
        make.height.mas_equalTo(@(speedViewMargin));
        make.bottom.mas_equalTo(weakSelf.bottomView.mas_top).with.offset(-widthEx(30));
    }];
    [self.view addSubview:self.recordItemView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    if ([self.shouldStartCameraPerView isEqualToString:@"YES"]) {
        [self startCameraPreview];
    }    [[VideoRecordNoficationManager shareInstance]addObserverNotifications];
    __weak  typeof(self)weakSelf = self;
    [[VideoRecordNoficationManager shareInstance]runingProcessMonopolizeCallback:^(BOOL foreground) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if ([[TXUGCRecord shareInstance]pauseRecord] == 0) {
            [strongSelf.progressView setVideoRecordPause:YES];
        }
        if (foreground == NO) {
            [strongSelf.videoAudioPlayer pausePlay];
        }
        if (foreground) {
            [strongSelf.videoAudioPlayer pausePlay];
            [strongSelf.recordItemView applicationDidBackGroundEvents];
            [strongSelf.subViewsContainer enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setHidden:NO];
                [strongSelf.interruptView setSubViewHidddenWithTitle:@"返回" hidden:NO];
            }];
        }
    }];
    [self.videoRecordStepView autolayoutScrollViewContentViewOffSet];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.progressView removeObserver:self forKeyPath:@"progressValue"];
    [self removeObserver:self forKeyPath:@"recordDuration"];
    [[VideoRecordNoficationManager shareInstance]removeAllObserverNotifications];
    self.shouldStartCameraPerView = @"NO";
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    [audioSession setActive:YES error:nil];
    [self.progressView addObserver:self forKeyPath:@"progressValue" options:NSKeyValueObservingOptionNew context:ObserverVideoRecordProgressKey];
    [self addObserver:self forKeyPath:@"recordDuration" options:NSKeyValueObservingOptionNew context:ObserverVodeoProgressTimeDurationKey];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasEditVideo = @"NO";
    self.deleteVideoOptString = @"NO";
    self.settingMusicPath = @"";
    self.resumeCount = 0.f;
    [self setObjectViews];
    [self subViewsIntoContainer];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.outFilePath = [documentsDirectory stringByAppendingPathComponent:@"recordOutPut.mp4"];
    self.recordFileManager = [TX_WKGRecordFileManager shareInstanace];
    NSString * outputPath = [self.recordFileManager creatDictionary:@"ExportVideo" fileName:@"recordOutPut.mp4"];
    self.outFilePath = outputPath;
    self.tx_wkgRecordVideoPath = [self.recordFileManager creatDictionary:@"ExportVideo"];
    //视频录制视频路径
    [self.view setUserInteractionEnabled:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dazzleTruncatSearchMusicOberver:) name:DazzleTruncatSearchMusicNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dazzleImportVideoOberver:) name:kDazzle_Video_PreViewingContentKey object:nil];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DazzleTruncatSearchMusicNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kDazzle_Video_PreViewingContentKey object:nil];

}

#pragma mark - NSNotification Observer
-(void)dazzleTruncatSearchMusicOberver:(NSNotification*)notification{
    id obj = notification.object;
    if ([obj isKindOfClass:[MusicOptionalModel class]]) {
        MusicOptionalModel * model = (MusicOptionalModel*)obj;
        if (model.pauseOrPlayModel.cachePath.length !=0) {
            [self.topOptView setSelectedStatus:YES opt:@"音乐"];
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
        } else {
            [self.topOptView setSelectedStatus:NO opt:@"音乐"];
            self.optionModel = nil;
            self.timeRange   = kCMTimeRangeZero;
            self.clipsMusicInfo = nil;
        }
    }
}

-(void)dazzleImportVideoOberver:(NSNotification*)notification{
    id obj = notification.object;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([obj isKindOfClass:[NSString class]]) {
            [self importVideoResult:obj];
        }
    });
}

- (void)importVideoResult:(NSString *)videoString{
    if (videoString.length == 0 || videoString == nil)return;
    NSString * absolute = videoString;
    NSString * scheme = @"file://";
    if ([absolute hasPrefix:scheme]) {
        videoString = [absolute substringWithRange:NSMakeRange(scheme.length, absolute.length - scheme.length)];
    }
    TX_WKG_VideoEditViewController * vc = [[TX_WKG_VideoEditViewController alloc]initWithCoverImage:nil videoPath:videoString musicpath:nil renderMode:RENDER_MODE_FILL_SCREEN isFromRecord:YES];
    vc.musicOptString = @"NO";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - obsever
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == ObserverVodeoProgressTimeDurationKey) {
        NSString * text = change[@"new"];
        CGFloat duration = [text floatValue];
        if (duration > (MAX_RECORD_TIME - 1.f)) {
            [self autoCompleteJoinVideo];
        }
    }
    else if (context == ObserverVideoRecordProgressKey) {
        float progress = [change[@"new"]floatValue];
        if (progress == 0){
            //当如果录制视频是回删的话，应该是使用resume继续录制
            [self.bottomView loadbackDeleteVideoView:NO];
            self.interruptView.tips_label.hidden = YES;
            self.topOptView.musicOpt_btn.enabled = YES;
        }else{
            [self.bottomView loadbackDeleteVideoView:YES];
            self.topOptView.musicOpt_btn.enabled = NO;
            [self.topOptView setStatusImageWithEnable: (self.clipsMusicInfo ? YES : NO)];
        }
        if (progress >=1.0f) {
            if (self.videoAudioPlayer && self.optionModel) {
                [self.videoAudioPlayer stopPlay];
            }
            [self.recordItemView setCompleted:YES];
            [self.interruptView setSubViewHidddenWithTitle:@"返回" hidden:NO];
            [self.subViewsContainer enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setHidden:NO];
            }];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    __weak  typeof(self)weakSelf = self;
    UIView * lastObjectView = (UIView*)[[self.topOptView subviews]lastObject];
    __block CGFloat maxY = CGRectGetMaxY(lastObjectView.frame) + widthEx(12.f);
    [self.topOptView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.view);
    make.top.mas_equalTo(weakSelf.interruptView.mas_bottom).with.offset(widthEx(12.f));
        make.width.mas_equalTo(@(widthEx(80.f+12.f)));
        make.height.mas_equalTo(@(maxY));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark  视频导入
-(void)inportAlbumVideo{
    Dazzle_Video_PreViewingController *  vc = [[Dazzle_Video_PreViewingController alloc]init];
    [self presentViewController:[[HXCustomNavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}


-(void)gotoAuthorizateEvents:(NSString*)msg{
    UIAlertController * controller = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction * sure =[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [controller addAction:cancel];
    [controller addAction:sure];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)albumListViewControllerDidCancel:(HXAlbumListViewController *)albumListViewController{
    _albumListViewController = nil;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
}

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original{
    _albumListViewController = nil;
    if (videoList == nil || videoList.count == 0) { return; }
    __block NSMutableArray *urlsArray = [NSMutableArray arrayWithCapacity:videoList.count];
    for (NSInteger i = 0; i < videoList.count; i++){
        [urlsArray addObject:[NSNull null]];
    }
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud  = hud;
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = @"视频导入中,请耐心等待...";
    HXPhotoModel *model = videoList.firstObject;
    __weak typeof(self) weakSelf = self;
    if (model.videoTime.integerValue > 1) {
        [self.photoManager afterSelectedListdeletePhotoModel:model];
        [HXPhotoTools getMediumQualityAVAssetWithPHAsset:model.asset startRequestIcloud:^(PHImageRequestID cloudRequestId) {
            
        } progressHandler:^(double progress) {
            float value = progress * 100;
            hud.labelText = [NSString stringWithFormat:@"正在导入%.2f%%",value];
        } completion:^(AVAsset *asset) {
            hud.labelText = @"正在合成，请勿退出";
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf dealWithSelVideo:asset];
        } failed:^(NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                MBProgressHUD *errorHub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                errorHub.mode = MBProgressHUDModeDeterminate;
                errorHub.labelText = @"导入视频失败";
                [errorHub hide:YES afterDelay:1.0];
            });
        }];
    } else {
        [self.photoManager afterSelectedListdeletePhotoModel:model];
        [HXPhotoTools getHighQualityAVAssetWithPHAsset:model.asset startRequestIcloud:^(PHImageRequestID cloudRequestId) {
        } progressHandler:^(double progress) {
            float value = progress * 100;
            hud.labelText = [NSString stringWithFormat:@"正在导入%.2f%%",value];
        } completion:^(AVAsset *asset) {
            hud.labelText = @"正在合成，请勿退出";
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf dealWithSelVideo:asset];
        } failed:^(NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                MBProgressHUD *errorHub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                errorHub.mode = MBProgressHUDModeDeterminate;
                errorHub.labelText = @"导入视频失败";
                [errorHub hide:YES afterDelay:1.0];
            });
        }];
    }
}

- (void)dealWithSelVideo:(AVAsset *)asset{
    [self.hud setHidden:YES];
    NSString * path = nil;
    if ([asset isKindOfClass:[AVURLAsset class]]) {
        AVURLAsset * urlAsset = (AVURLAsset*)asset;
        NSString * absolute = urlAsset.URL.absoluteString;
        NSString * scheme = @"file://";
        if ([absolute hasPrefix:scheme]) {
            path = [absolute substringWithRange:NSMakeRange(scheme.length, absolute.length - scheme.length)];
        }
    }
    TX_WKG_VideoEditViewController * vc = [[TX_WKG_VideoEditViewController alloc]initWithCoverImage:nil videoAsset:asset videoPath:path musicpath:nil renderMode:RENDER_MODE_FILL_SCREEN isFromRecord:YES];
    vc.musicOptString = @"NO";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)updateExportDisplay{
    CGFloat progress = self.exportSession.progress;
    float value = progress * 100;
    self.hud.labelText = [NSString stringWithFormat:@"合成中%.2f%%",value];
    if (progress > 0.99) {
        [self.exportProgressTiemer invalidate];
        self.exportProgressTiemer = nil;
    }
}

#pragma mark - 段视频录制代理
-(void) onRecordProgress:(NSInteger)milliSecond{
    if (self.interruptView.tips_label.hidden) {
        [self.interruptView.tips_label setHidden:NO];
    }
    CGFloat videoDuration = milliSecond/1000.f;
    self.recordDuration = videoDuration;
    self.interruptView.tips_label.text = [self getMMSSFromSS:videoDuration];
}
    
-(NSString *)getMMSSFromSS:(CGFloat)videoDuration{
    NSInteger  seconds     = videoDuration;
    NSInteger  m  = seconds / 60;
    NSInteger  s  = seconds % 60;
    NSString * str_minute;
    NSString * str_second;
    if (m > 9) {
        str_minute  = [NSString stringWithFormat:@"%zd",m];
    }else{
        str_minute  = [NSString stringWithFormat:@"0%zd",m];
    }
    if (s > 9) {
        str_second = [NSString stringWithFormat:@"%zd",s];
    }else{
        str_second = [NSString stringWithFormat:@"0%zd",s];
    }
    NSString * format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

-(void)onRecordComplete:(TXUGCRecordResult*)result{
    [self.hud hide:YES afterDelay:2.f];
    if (![[VideoRecordNoficationManager shareInstance]foreground])return;
    if (result.retCode  == UGC_RECORD_RESULT_OK ||  result.retCode  ==UGC_RECORD_RESULT_OK_BEYOND_MAXDURATION) {
        if ([[[TXUGCRecord shareInstance]partsManager]getVideoPathList].count == 1) {
            TX_WKG_VideoEditViewController * vc = [[TX_WKG_VideoEditViewController alloc]initWithCoverImage:result.coverImage videoPath:result.videoPath musicpath:self.clipsMusicInfo renderMode:RENDER_MODE_FILL_SCREEN isFromRecord:YES];
            vc.musicOptString =  self.clipsMusicInfo != nil ? @"YES" : @"NO";
            self.hasEditVideo = @"YES";
            _hud = nil;
            [self.navigationController pushViewController:vc animated:YES];

        }
    }
}

#pragma mark - BeautySettingPanelDelegate
- (void)onSetBeautyStyle:(int)beautyStyle beautyLevel:(float)beautyLevel whitenessLevel:(float)whitenessLevel ruddinessLevel:(float)ruddinessLevel{
     [[TXUGCRecord shareInstance] setBeautyStyle:beautyStyle beautyLevel:beautyLevel whitenessLevel:whitenessLevel ruddinessLevel:ruddinessLevel];
}

- (void)onSetEyeScaleLevel:(float)eyeScaleLevel{
    [[TXUGCRecord shareInstance] setEyeScaleLevel:eyeScaleLevel];
}

- (void)onSetFaceScaleLevel:(float)faceScaleLevel{
    [[TXUGCRecord shareInstance] setFaceScaleLevel:faceScaleLevel];
}

- (void)onSetFilter:(UIImage*)filterImage{
    [[TXUGCRecord shareInstance] setFilter:filterImage];
}

- (void)onSetGreenScreenFile:(NSURL *)file{
    [[TXUGCRecord shareInstance] setGreenScreenFile:file];
}

- (void)onSelectMotionTmpl:(NSString *)tmplName inDir:(NSString *)tmplDir{
    [[TXUGCRecord shareInstance] selectMotionTmpl:tmplName inDir:tmplDir];
}

- (void)onSetFaceVLevel:(float)faceVLevel{
    [[TXUGCRecord shareInstance] setFaceVLevel:faceVLevel];
}

- (void)onSetChinLevel:(float)chinLevel{
    [[TXUGCRecord shareInstance] setChinLevel:chinLevel];
}

- (void)onSetNoseSlimLevel:(float)slimLevel{
    [[TXUGCRecord shareInstance] setNoseSlimLevel:slimLevel];
}

- (void)onSetFaceShortLevel:(float)faceShortlevel{
    [[TXUGCRecord shareInstance] setFaceShortLevel:faceShortlevel];
}

- (void)onSetMixLevel:(float)mixLevel{
    [[TXUGCRecord shareInstance] setSpecialRatio:mixLevel / 10.0];
}

@end
