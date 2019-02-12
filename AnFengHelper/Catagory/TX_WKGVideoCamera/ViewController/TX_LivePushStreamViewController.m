//
//  TX_LivePushStreamViewController.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/25.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_LivePushStreamViewController.h"
#import <TXLivePush.h>
#import <TXLiveBase.h>
#import "HTLiveBeautyView.h"
#import "UIButton+Gradient.h"

typedef NS_ENUM(NSUInteger, LiveStateType) {
    LiveStateType_NotAnchor,       // 非主播
    LiveStateType_FlowStateEmpty,  // 无流量
    LiveStateType_FlowStateLow,    // 低流量
    LiveStateType_FlowStateEnough, // 高流量
};

@interface TX_LivePushStreamViewController () <
TXLiveRecordListener,
TXLivePushListener,
UIGestureRecognizerDelegate,
//HTLiveChatViewDelegate,
NIMChatroomManagerDelegate,
NIMChatManagerDelegate,
NIMConversationManagerDelegate,
HTLiveBeautyViewDelegate
>

/** 推流地址 */
@property (nonatomic, copy) NSString *urlString;
/** 推流类 */
@property (nonatomic, strong) TXLivePush *txLivePush;
/** 功能按钮父视图 */
@property (nonatomic, strong) UIView *actionView;
/** 退出按钮 */
@property (nonatomic, strong) UIButton *closeButton;
/** 美颜按钮 */
@property (nonatomic, strong) UIButton *beautyButton;
/** 美颜设置 */
@property (nonatomic, strong) HTLiveBeautyView *beautyView;
/** 切换摄像头按钮 */
@property (nonatomic, strong) UIButton *switchCameraButton;
/** 开启直播按钮 */
@property (nonatomic, strong) UIButton *openLiveStreamButton;
/** 底部消息按钮 */
@property (nonatomic, strong) UIButton *messageButton;
/** 底部美颜按钮 */
@property (nonatomic, strong) UIButton *bottomBeautyButton;
/** 底部切换摄像头按钮 */
@property (nonatomic, strong) UIButton *bottomSwitchCameraButton;
/** 底部开关麦按钮 */
@property (nonatomic, strong) UIButton *switchMicrophoneButton;
/** 底部分享按钮 */
@property (nonatomic, strong) UIButton *shareButton;
/** 推流地址模型 */
@property (strong, nonatomic) Response_shopLive_shopLivePushUrl *pushUrlModel;

/**< 直播码 */
@property (copy, nonatomic) NSString *liveSN;
/**< 推流编码 */
@property (copy, nonatomic) NSString *streamId;
/**< 直播用户的id */
@property (copy, nonatomic) NSString *userID;
/**< 依据是否有流量，判断是否可以直播 */
@property (assign, nonatomic) BOOL canLive;
/**< 直播状态类型 */
@property (assign, nonatomic) LiveStateType liveStateType;

@end

@implementation TX_LivePushStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithR:0 g:0 b:0 a:0]];
    
//    self.userID = [UserDataManager userData].id;
    self.userID = @"17";
    
    [TXLiveBase setConsoleEnabled:NO];
    
    [self setupViews];
    
//    [self.txLivePush startPreview:self.parentViewController.renderView];
    
//    [self requestUserInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKicked:)
                                                 name:@"HHKickedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameChange:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    [[NIMSDK sharedSDK].chatroomManager exitChatroom:self.roomId completion:^(NSError * _Nullable error) {
    //
    //    }];
}

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
        _txLivePush.recordDelegate = self;
        // 推流代理
        _txLivePush.delegate = self;
        // 初始化美颜
        [_txLivePush setBeautyStyle:self.beautyView.beautyStyle
                        beautyLevel:self.beautyView.beautyLevel
                     whitenessLevel:self.beautyView.whitenessLevel
                     ruddinessLevel:self.beautyView.ruddinessLevel];
    }
    return _txLivePush;
}

- (UIView *)actionView {
    if (_actionView == nil) {
        _actionView = [[UIView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickActionView:)];
        tap.delegate = self;
        [_actionView addGestureRecognizer:tap];
    }
    return _actionView;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setBackgroundImage:PPImage(@"lq_zhibo_close") forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(requestStopLive) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)beautyButton {
    if (_beautyButton == nil) {
        _beautyButton = [[UIButton alloc] init];
        [_beautyButton setBackgroundImage:PPImage(@"lq_zhibo_meiyan") forState:UIControlStateNormal];
        [_beautyButton addTarget:self action:@selector(beautyPanelShowOrHide:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beautyButton;
}

- (HTLiveBeautyView *)beautyView {
    if (_beautyView == nil) {
        _beautyView = [[HTLiveBeautyView alloc] init];
        _beautyView.delegate = self;
    }
    return _beautyView;
}

- (UIButton *)switchCameraButton {
    if (!_switchCameraButton) {
        _switchCameraButton = [[UIButton alloc] init];
        [_switchCameraButton setBackgroundImage:PPImage(@"lq_zhibo_jingtou") forState:UIControlStateNormal];
        [_switchCameraButton addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCameraButton;
}

- (UIButton *)openLiveStreamButton {
    if (!_openLiveStreamButton) {
        _openLiveStreamButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openLiveStreamButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        
        [_openLiveStreamButton.layer setMasksToBounds:YES];
        [_openLiveStreamButton.layer setCornerRadius:5];
        
        [_openLiveStreamButton setTitle:@"开启直播" forState:UIControlStateNormal];
        [_openLiveStreamButton setTitle:@"开启直播" forState:UIControlStateHighlighted];
        [_openLiveStreamButton gradientButtonWithSize:CGSizeMake(homeScale(270.f), homeScale(45.f)) colorArray:@[[Tools colorWithHexString:@"#FC6C4A"],[Tools colorWithHexString:@"#FF447F"]] percentageArray:@[@(0.5),@(1)] gradientType:GradientFromLeftToRight];
        
        [_openLiveStreamButton addTarget:self action:@selector(openLiveStreamButtonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openLiveStreamButton;
}

- (UIButton *)messageButton {
    if (_messageButton == nil) {
        _messageButton = [[UIButton alloc] init];
        [_messageButton setBackgroundImage:PPImage(@"lq_zhibotl_pinglun") forState:UIControlStateNormal];
        //        [_messageButton addTarget:self.chatInputView.textView action:@selector(becomeFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageButton;
}

- (UIButton *)bottomBeautyButton {
    if (_bottomBeautyButton == nil) {
        _bottomBeautyButton = [[UIButton alloc] init];
        [_bottomBeautyButton setBackgroundImage:PPImage(@"lq_zhibo_meiyan") forState:UIControlStateNormal];
        [_bottomBeautyButton addTarget:self action:@selector(beautyPanelShowOrHide:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBeautyButton;
}

- (UIButton *)bottomSwitchCameraButton {
    if (!_bottomSwitchCameraButton) {
        _bottomSwitchCameraButton = [[UIButton alloc] init];
        [_bottomSwitchCameraButton setBackgroundImage:PPImage(@"lq_zhibo_jingtou") forState:UIControlStateNormal];
        [_bottomSwitchCameraButton addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomSwitchCameraButton;
}

- (UIButton *)switchMicrophoneButton {
    if (!_switchMicrophoneButton) {
        _switchMicrophoneButton = [[UIButton alloc] init];
        [_switchMicrophoneButton setBackgroundImage:PPImage(@"lq_zhibotl_huatong") forState:UIControlStateNormal];
        [_switchMicrophoneButton setBackgroundImage:PPImage(@"lq_zhibotl_guanmai") forState:UIControlStateSelected];
        [_switchMicrophoneButton addTarget:self action:@selector(switchMicrophone:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchMicrophoneButton;
}

- (UIButton *)shareButton {
    if (_shareButton == nil) {
        _shareButton = [[UIButton alloc] init];
        [_shareButton setBackgroundImage:PPImage(@"lq_zhibotl_share") forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareLiveRoom:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

#pragma mark - Request Method
/**
 请求用户信息，判断当前用户是否具有直播权限（是否为主播）
 */
- (void)requestUserInfo {
    Request_game_findUserInfo *param = [[Request_game_findUserInfo alloc] init];
    NSString *loginUserId = self.userID;
    param.queryUserId = loginUserId;
    param.userId = loginUserId;
    
    [FaceFunsNetManager connectWithModel:param WithUrlSring:HOST isShowLoading:NO success:^(id dic) {
        
        Response_game_findUserInfo *userInfoModel = [[Response_game_findUserInfo alloc] initWithDictionary:dic error:nil];
        if (userInfoModel.data.isAttestation == 1) {
            [self requestShopLivePushUrl];
        }
        else {
            self.canLive = NO;
            self.liveStateType = LiveStateType_NotAnchor;
        }
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 请求直播推流地址
 */
- (void)requestShopLivePushUrl {
    Request_shopLive_shopLivePushUrl *reqArgs = [Request_shopLive_shopLivePushUrl new];
    reqArgs.userId = self.userID;
    reqArgs.hostType = @"1";
    
    [FaceFunsNetManager connectWithModel:reqArgs WithUrlSring:HOST isShowLoading:NO success:^(id dic) {
        
        Response_shopLive_shopLivePushUrl *model = [Response_shopLive_shopLivePushUrl mj_objectWithKeyValues:dic];
        if (model.code == 1) {
            self.pushUrlModel = model;
            self.urlString = self.pushUrlModel.data.pushUrl;
            
            switch (model.data.flowStatus) {
                case 0: {
                    self.canLive = NO;
                    self.liveStateType = LiveStateType_FlowStateEmpty;
                }
                    break;
                case 1: {
                    self.canLive = YES;
                    self.liveStateType = LiveStateType_FlowStateLow;
                }
                    break;
                case 2: {
                    self.canLive = YES;
                    self.liveStateType = LiveStateType_FlowStateEnough;
                }
                    break;
                default:
                    break;
            }
        }
        else {
            [[UIApplication sharedApplication].keyWindow makeToast:model.msg duration:1.0 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestStartToLive {
    
    if (self.pushUrlModel) {
        Request_shopLive_liveBegin *reqArgs = [Request_shopLive_liveBegin new];
        
        reqArgs.userId = [NSString stringWithFormat:@"%li", self.pushUrlModel.data.userId];
        reqArgs.streamId = self.pushUrlModel.data.streamId;
        reqArgs.platformType = @"2";  // 1 安卓 2 苹果
        reqArgs.clientFlag = @"3";    // 1 智大师 2 后台 3 脸圈
        reqArgs.hostType = [NSString stringWithFormat:@"%li", self.pushUrlModel.data.hostType];
        
        [FaceFunsNetManager connectWithModel:reqArgs WithUrlSring:HOST isShowLoading:NO success:^(id dic) {
            
            Response_shopLive_liveBegin *model = [Response_shopLive_liveBegin mj_objectWithKeyValues:dic];
            if (model.code == 1) {
                self.liveSN = model.data.liveSN;
                [self startPush];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)requestStopLive {
    __weak typeof(self)weakSelf = self;
    ShowConfirm(self, @"提示", @"\n当前正在直播，是否确定退出", @"取消", @"确定", nil, ^{
        [weakSelf shutDownLiveRoom];
    });
}

- (void)shutDownLiveRoom {
    Request_shopLive_liveEnd *reqArgs = [Request_shopLive_liveEnd new];
    reqArgs.liveSN = self.liveSN;
    reqArgs.streamId = self.streamId;
    [FaceFunsNetManager connectWithModel:reqArgs WithUrlSring:HOST isShowLoading:NO success:^(id dic) {
        
        Response_shopLive_liveEnd *model = [Response_shopLive_liveEnd mj_objectWithKeyValues:dic];
        if (model.code == 1) {}
        
    } failure:^(NSError *error) {
        
    }];
    
    [self stopPush];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Method
- (void)setupViews {
    [self.view addSubview:self.actionView];
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    [self.actionView addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(homeScale(14.f));
        make.top.mas_equalTo(SC_StatusBarHeight+homeScale(15.f));
        make.width.height.mas_equalTo(homeScale(22.f));
    }];
    
    [self.actionView addSubview:self.beautyButton];
    [self.beautyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.closeButton.mas_right).offset(homeScale(20.f));
        make.centerY.mas_equalTo(self.closeButton);
        make.width.height.mas_equalTo(homeScale(41.f));
    }];
    
    [self.actionView addSubview:self.switchCameraButton];
    [self.switchCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.beautyButton.mas_right).offset(homeScale(10.f));
        make.centerY.mas_equalTo(self.closeButton);
        make.width.height.mas_equalTo(homeScale(41.f));
    }];
    
    [self.actionView addSubview:self.openLiveStreamButton];
    [self.openLiveStreamButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.actionView.mas_bottom).offset(-20-SC_TabbarHeight);
        make.width.mas_equalTo(homeScale(270.f));
        make.height.mas_equalTo(homeScale(45.f));
    }];
    
    //
    [self.actionView addSubview:self.messageButton];
    [self.messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(homeScale(12.f));
        make.bottom.equalTo(self.actionView.mas_bottom).offset(-15.f-SC_TabbarSafeBottomMargin);
        make.width.height.mas_equalTo(homeScale(40.f));
    }];
    
    [self.actionView addSubview:self.bottomBeautyButton];
    [self.bottomBeautyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.messageButton.mas_right).offset(homeScale(15.f));
        make.centerY.mas_equalTo(self.messageButton);
        make.width.height.mas_equalTo(homeScale(40.f));
    }];
    
    [self.actionView addSubview:self.bottomSwitchCameraButton];
    [self.bottomSwitchCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomBeautyButton.mas_right).offset(homeScale(15.f));
        make.centerY.mas_equalTo(self.messageButton);
        make.width.height.mas_equalTo(homeScale(40.f));
    }];
    
    [self.actionView addSubview:self.switchMicrophoneButton];
    [self.switchMicrophoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bottomSwitchCameraButton.mas_right).offset(homeScale(15.f));
        make.centerY.mas_equalTo(self.messageButton);
        make.width.height.mas_equalTo(homeScale(40.f));
    }];
    
    [self.actionView addSubview:self.shareButton];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.actionView.mas_right).offset(-homeScale(15.f));
        make.centerY.mas_equalTo(self.messageButton);
        make.width.height.mas_equalTo(homeScale(40.f));
    }];
    
    [self showFirstPartControls:YES];
    [self showSecondPartControls:NO];
}

- (void)startPush {
    [self.txLivePush startPreview:self.parentViewController.live_renderView];
    int result = [self.txLivePush startPush:self.urlString];
    if (result == 0) {
        self.actionView.hidden = NO;
        
        [self showFirstPartControls:NO];
        [self showSecondPartControls:YES];
    }
}

- (void)stopPush {
    [self.txLivePush stopPreview];
    [self.txLivePush stopPush];
}

- (void)switchCamera {
    [self.parentViewController.txLivePush switchCamera];
}

- (void)showFirstPartControls:(BOOL)isShow {
    BOOL isHidden = !isShow;
    
    [self.closeButton setHidden:isHidden];
    [self.beautyButton setHidden:isHidden];
    [self.switchCameraButton setHidden:isHidden];
    [self.openLiveStreamButton setHidden:isHidden];
}

- (void)showSecondPartControls:(BOOL)isShow {
    BOOL isHidden = !isShow;
    
    [self.messageButton setHidden:isHidden];
    [self.bottomBeautyButton setHidden:isHidden];
    [self.bottomSwitchCameraButton setHidden:isHidden];
    [self.switchMicrophoneButton setHidden:isHidden];
    [self.shareButton setHidden:isHidden];
}

#pragma mark - Respond Method
- (void)clickActionView:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
    CGPoint location = [tap locationInView:self.actionView];
    [self.txLivePush setFocusPosition:location];
}

- (void)beautyPanelShowOrHide:(UIButton *)sender {
    [self.beautyView showInView:self.view];
}

- (void)openLiveStreamButtonClickedAction:(UIButton *)sender {
    
    if (self.canLive) {
        [self requestStartToLive];
    }
    else {
        NSString *tip = @"";
        switch (self.liveStateType) {
            case LiveStateType_NotAnchor:
                tip = @"您还未成为主播哦";
                break;
            case LiveStateType_FlowStateEmpty:
                tip = @"您的直播流量已用完";
                break;
            default:
                break;
        }
        [[UIApplication sharedApplication].keyWindow makeToast:tip duration:1.0 position:CSToastPositionCenter];
    }
}

- (void)switchMicrophone:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 关麦
        [self.txLivePush setMute:YES];
    }
    else { // 开麦
        [self.txLivePush setMute:NO];
    }
}

- (void)shareLiveRoom:(UIButton *)sender {
    
}

#pragma mark - Notification
//收到通知后，调用beginBackgroundTaskWithExpirationHandler
-(void)handleEnterBackground:(NSNotification *)notification {
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    }];
    //    if (self.isPaused) {
    //        //如果已手动暂停，不做处理
    //        return;
    //    }
    [self.txLivePush pausePush];
    [self.txLivePush setMute:YES];
    //    [self.pauseButton setBackgroundImage:PPImage(@"live_bofang") forState:UIControlStateNormal];
}

//切前台处理
- (void)handleEnterForeground:(NSNotification *)notification {
    //    if (self.isPaused) {
    //        //如果已手动暂停，不做处理
    //        return;
    //    }
    [self.txLivePush resumePush];
    [self.txLivePush setMute:NO];
    //    [self.pauseButton setBackgroundImage:PPImage(@"live_zanting") forState:UIControlStateNormal];
}

- (void)handleKicked:(NSNotification *)notification {
    [self shutDownLiveRoom];
}

- (void)keyBoardFrameChange:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    CGRect keyboardRect = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float duration = [dict[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //    [self.chatInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.equalTo(@0);
    //        if (CGRectGetMidY(keyboardRect) > PPScreenH) {
    //            make.top.equalTo(self.view.mas_bottom);
    //        } else {
    //            make.bottom.equalTo(self.view.mas_top).offset(keyboardRect.origin.y);
    //        }
    //    }];
    [UIView animateWithDuration:duration animations:^{
        [self.actionView layoutIfNeeded];
    }];
}

#pragma mark - TXLivePushListener
- (void)onPushEvent:(int)EvtID withParam:(NSDictionary *)param {
    //    NSLog(@"EvtID = %d%@",EvtID,param.yy_modelDescription);
    switch (EvtID) {
        case PUSH_WARNING_READ_WRITE_FAIL:
        case PUSH_WARNING_RECONNECT:
        case PUSH_WARNING_NET_BUSY: {
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [PPProgressHUD showTextHUDAddedTo:self.view text:@"网络连接不稳定"].userInteractionEnabled = NO;
            });
        } break;
        case PUSH_ERR_OPEN_MIC_FAIL: {
            ShowConfirm(self, @"麦克风权限未开启", @"\n直播需要开启您的麦克风权限，请从系统设置界面中开启", @"取消", @"去开启", nil, ^{
                // 无权限 引导去开启
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            });
        } break;
        case PUSH_ERR_OPEN_CAMERA_FAIL: {
            ShowConfirm(self, @"摄像头权限未开启", @"\n直播需要开启您的摄像头权限，请从系统设置界面中开启", @"取消", @"去开启", nil, ^{
                // 无权限 引导去开启
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            });
        } break;
        case PUSH_ERR_NET_DISCONNECT: {
            __weak typeof(self)weakSelf = self;
            ShowConfirm(self, @"直播中断", @"您的网络连接已断开，请检查网络并重试。", @"退出", @"重试", ^{
                [weakSelf shutDownLiveRoom];
            }, ^{
                [weakSelf startPush];
            });
        } break;
        default:
            break;
    }
}

- (void)onNetStatus:(NSDictionary *)param {
    
}

#pragma mark - HTLiveBeautyViewDelegate
- (void)beautyView:(HTLiveBeautyView *)beautyView setBeautyStyle:(int)beautyStyle {
    [self.txLivePush setBeautyStyle:beautyStyle
                        beautyLevel:beautyView.beautyLevel
                     whitenessLevel:beautyView.whitenessLevel
                     ruddinessLevel:beautyView.ruddinessLevel];
}

- (void)beautyView:(HTLiveBeautyView *)beautyView setBeautyLevel:(float)beautyLevel {
    [self.txLivePush setBeautyStyle:beautyView.beautyStyle
                        beautyLevel:beautyLevel
                     whitenessLevel:beautyView.whitenessLevel
                     ruddinessLevel:beautyView.ruddinessLevel];
}

- (void)beautyView:(HTLiveBeautyView *)beautyView setWhitenessLevel:(float)whitenessLevel {
    [self.txLivePush setBeautyStyle:beautyView.beautyStyle
                        beautyLevel:beautyView.beautyLevel
                     whitenessLevel:whitenessLevel
                     ruddinessLevel:beautyView.ruddinessLevel];
}

- (void)beautyView:(HTLiveBeautyView *)beautyView setRuddinessLevel:(float)ruddinessLevel {
    [self.txLivePush setBeautyStyle:beautyView.beautyStyle
                        beautyLevel:beautyView.beautyLevel
                     whitenessLevel:beautyView.whitenessLevel
                     ruddinessLevel:ruddinessLevel];
}

- (void)beautyView:(HTLiveBeautyView *)beautyView setFilter:(UIImage *)filterImage {
    [self.txLivePush setFilter:filterImage];
}

- (void)beautyView:(HTLiveBeautyView *)beautyView setFilterRatio:(float)filterRatio {
    [self.txLivePush setSpecialRatio:filterRatio];
}

@end
