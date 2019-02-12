//
//  TX_WKGVideoCameraController.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKGVideoCameraController.h"
#import "TX_WKGCameraBottomView.h"
#import "TX_WKGOptCameraOverView.h"
#import "TX_WKG_CameraOptionalView.h"
#import <TXLiteAVSDK_Professional/TXLiveSDKTypeDef.h>
#import <TXLiteAVSDK_Professional/TXVideoEditer.h>
#import "VideoConfigure.h"
#import "VideoRecordNoficationManager.h"
#import "TX_WKG_PhotoEditViewController.h"
#import "TX_WKG_Camera_EffectView.h"
#import "BeautySettingPanel.h"
#import "CY_FaceDynamicsIssueController.h"
#import "TX_WKG_Photo_EditConfig.h"


@interface TX_WKGVideoCameraController ()<UIGestureRecognizerDelegate,HXAlbumListViewControllerDelegate,TX_WKG_Camera_Effect_Delegate,BeautySettingPanelDelegate>
@property (strong, nonatomic) TX_WKG_CameraOptionalView * cameraOptionalView;
@property (strong, nonatomic) TX_WKGCameraBottomView *tx_wkgCameraBottomView;
@property (strong, nonatomic) TX_WKGOptCameraOverView *cameraOverView;
@property (strong, nonatomic) VideoConfigure * videoConfigure;
@property (strong, nonatomic) UIView * videoRecordView;
@property (strong, nonatomic) HXPhotoManager * photoManager;
@property (strong, nonatomic) HXDatePhotoToolManager * photoRequestManager;
@property (assign, nonatomic) BOOL toggleTorch;
@property (assign, nonatomic) NSInteger countdownTime;
@property (strong, nonatomic) UIView * countdownView;
@property (strong, nonatomic) UILabel * title_label;
@property (strong, nonatomic) dispatch_source_t timer;
@property (strong, nonatomic) TX_WKG_Camera_EffectView * camera_effectView;
@property (strong, nonatomic) BeautySettingPanel * beautySettingPanel;
@property (strong, nonatomic) UIView * coverView;
@property (copy, nonatomic) NSString  * dismissShouldPopViewController;
@property (copy, nonatomic) NSString * isShouldStartCameraPreView;
@property (copy, nonatomic) NSString * isElectPublishAddress;
@property (copy, nonatomic) NSString * isfrontCamera;
@end

@implementation TX_WKGVideoCameraController
#pragma mark - Configuation
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
    if ([[TXUGCRecord shareInstance] startCameraCustom:param preview:self.videoRecordView] != 0) {
        [[TXUGCRecord shareInstance]setZoom:1];
        [[TXUGCRecord shareInstance] startCameraCustom:param preview:self.videoRecordView];
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

-(void)setgpuCameraViews{
    self.videoRecordView = [[UIView alloc]initWithFrame:self.view.frame];
    self.videoRecordView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.videoRecordView];
}
#pragma mark -
-(void)dimssViewControllerEvents:(UIButton*)args{
    [[TXUGCRecord shareInstance] setBeautyStyle:0 beautyLevel:0.f whitenessLevel:0.f ruddinessLevel:0.f];
    [[TXUGCRecord shareInstance] stopCameraPreview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 * 功能修改：之前设置默认的美颜功能
 *   1,现在修改为：可调节的美颜的级别
 *   2,当视图按钮选中时候，移除或者显示调节美颜功能视图
 */

-(void)cameraBeautyEvents:(UIButton*)args{
    if ([[self.view subviews]containsObject:self.tx_wkgCameraBottomView]) {
        [self.tx_wkgCameraBottomView setHidden:YES];
    }
    if ([[self.view subviews]containsObject:self.camera_effectView]) {
        [self.camera_effectView removeFromSuperview];
    }
    if (![[self.view subviews]containsObject:self.beautySettingPanel]) {
        [self.view addSubview:self.beautySettingPanel];
    }
    __weak typeof(self)weakSelf = self;
    [self.view addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.cameraOptionalView.mas_bottom);
        make.left.and.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).with.offset(-(widthEx(375/3.f + 38.f + 17.f)));
    }];
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

-(void)removeFilterViewFromSuperViewEvents:(UITapGestureRecognizer*)gesture{
    [self.tx_wkgCameraBottomView setHidden:NO];
    [self.camera_effectView removeFromSuperview];
    [self.beautySettingPanel removeFromSuperview];
    _beautySettingPanel = nil;
    [self.coverView removeFromSuperview];
    [self.coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
    }];
}

//编辑弹窗
-(void)moreFuncationEvents:(UIButton*)args{
    if (![[self.view subviews]containsObject:self.cameraOverView]) {
        __weak typeof(self)weakSelf = self;
        [self.view addSubview:self.cameraOverView];
        [self.cameraOverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.cameraOptionalView.mas_bottom).with.offset(0.f);
            make.centerX.mas_equalTo(args.mas_centerX);
            make.width.mas_equalTo(widthEx(165.f));
            make.height.mas_equalTo(heightEx(145.f));
        }];
    }else{
        [self.cameraOverView removeFromSuperview];
        [self.cameraOverView mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
    }
}

-(void)cameraRotateEvents:(UIButton*)args{
    args.selected = !args.selected;
    // args.selected : YES 前置摄像头
    if (args.selected ==NO) {
        self.isfrontCamera  = @"NO";
        if ([[TXUGCRecord shareInstance]switchCamera:YES]) {
            [self.cameraOverView settingTX_WKG_CameraOverViewControlStatusWithOptType:@"闪光灯关闭"];
        }
    }else{
        self.isfrontCamera  = @"YES";
        self.toggleTorch = NO;
        [[TXUGCRecord shareInstance]switchCamera:!args.selected];
        [self.cameraOverView settingTX_WKG_CameraOverViewControlStatusWithOptType:@"闪光灯"];
    }
}

#pragma mark - OverView Events
-(void)optionCameraRatioEvents:(NSString*)title{
    if ([title isEqualToString:@"9-16"]) {
        [[TXUGCRecord shareInstance] setAspectRatio:VIDEO_ASPECT_RATIO_9_16];
        self.videoRecordView.frame = self.view.bounds;
        [self.cameraOptionalView settingCameraOptionalControllsColor:@"NO"];
        [self.tx_wkgCameraBottomView settingCameraBottomControllsColor:@"NO"];
        self.camera_effectView.backgroundColor = [UIColor clearColor];
        self.beautySettingPanel.beautyCollectionView.backgroundColor = [UIColor clearColor];
    }else if ([title isEqualToString:@"3-4"]){
        [[TXUGCRecord shareInstance] setAspectRatio:VIDEO_ASPECT_RATIO_3_4];
        self.videoRecordView.frame = CGRectMake(0, 0, KScreenWidth, kScreenWidth*4/3.f);
        [self.cameraOptionalView settingCameraOptionalControllsColor:@"NO"];
        [self.tx_wkgCameraBottomView settingCameraBottomControllsColor:@"YES"];
        self.camera_effectView.backgroundColor =   [UIColorFromRGB(0x151724)colorWithAlphaComponent:0.8];
        self.beautySettingPanel.beautyCollectionView.backgroundColor = [UIColorFromRGB(0x151724)colorWithAlphaComponent:0.8];
    }else{
        [[TXUGCRecord shareInstance] setAspectRatio:VIDEO_ASPECT_RATIO_1_1];
        CGFloat top = CGRectGetMaxY(self.cameraOptionalView.frame);
        self.videoRecordView.frame = CGRectMake(0,top, KScreenWidth, kScreenWidth);
        [self.cameraOptionalView settingCameraOptionalControllsColor:@"YES"];
        [self.tx_wkgCameraBottomView settingCameraBottomControllsColor:@"YES"];
        self.camera_effectView.backgroundColor = [UIColorFromRGB(0x151724)colorWithAlphaComponent:0.8];
        self.beautySettingPanel.beautyCollectionView.backgroundColor = [UIColorFromRGB(0x151724)colorWithAlphaComponent:0.8];
    }
}
/*
 @{@"optType":@"延迟拍摄",@"title":@"延迟拍摄",@"normal":@"delay_camera_normal",@"highlight":@"delay_camera_highlight"},
 @{@"optType":@"闪光灯关闭",@"title":@"闪光灯",@"normal":@"flashlight_close_normal",@"highlight":@"flashlight_close_normal"},
 @{@"optType":@"闪光灯",@"title":@"闪光灯",@"normal":@"flashlight_normal",@"highlight":@"flashlight_highlight"},
 @{@"optType":@"延迟拍摄关闭",@"title":@"延迟拍摄",@"normal":@"delay_camera_close_normal",@"highlight":@"delay_camera_close_highlight"},
 */
-(void)optionalDelayCameraEvents:(NSString*)title{
    self.countdownTime = [title isEqualToString:@"延迟拍摄"] ? 3.f : 0.f;
    if ([title isEqualToString:@"延迟拍摄"]) {
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
                [self tx_wkg_cameraEvents:nil];
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
    }
}

-(void)optionalFlashlightEvents:(NSString*)title{
    if ([title isEqualToString:@"闪光灯"]) {
        self.toggleTorch = !self.toggleTorch;
        //enable: YES, 打开    NO, 关闭
        NSString * type =  self.toggleTorch == NO ? @"闪光灯关闭":@"闪光灯";
        [self.cameraOverView settingTX_WKG_CameraOverViewControlStatusWithOptType:type];
        [[TXUGCRecord shareInstance]toggleTorch:self.toggleTorch];
    }else if([title isEqualToString:@"闪光灯关闭"]){
        if ([self.isfrontCamera isEqualToString:@"YES"]) {
            [[TXUGCRecord shareInstance]toggleTorch:YES];
            self.toggleTorch = YES;
            [self.cameraOverView settingTX_WKG_CameraOverViewControlStatusWithOptType:@"闪光灯"];
        }
    }
}

#pragma mark TX_WKG_Camera_Effect_Delegate
- (void)onSetFilter:(UIImage*)filterImage{
    [[TXUGCRecord shareInstance] setFilter:filterImage];
}
#pragma mark - 图片导入
-(void)inportAlbumPhoto{
    HXAlbumListViewController *vc = [[HXAlbumListViewController alloc] init];
    self.photoManager.configuration.photoMaxNum = 9 - self.selectedIndex;
    vc.manager = self.photoManager;
    vc.delegate = self;
    [self presentViewController:[[HXCustomNavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

- (void)albumListViewControllerDidCancel:(HXAlbumListViewController *)albumListViewController{
    [self.photoManager clearSelectedList];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
}

- (void)albumListViewController:(HXAlbumListViewController *)albumListViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original{
    __weak typeof(self)weakSelf = self;
    __block NSMutableArray * selectedImags = [photoList mutableCopy];
    [self.photoManager clearSelectedList];
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.photoRequestManager getSelectedImageList:selectedImags success:^(NSArray<UIImage *> *imageList) {
            if (weakSelf.FinishSelectBlock) {
                weakSelf.FinishSelectBlock(imageList);
                [weakSelf dismissViewControllerAnimated:NO completion:^{
                    
                }];
                return ;
            }
            CY_FaceDynamicsIssueController * vc = [CY_FaceDynamicsIssueController new];
            vc.selectImgArr = [imageList mutableCopy];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        } failed:^{
            
        }];
    });
}

#pragma mark - TX_WKGCameraBottomView Events
-(void)tx_wkg_exportSourcesEvents:(NSString*)title{
    [self inportAlbumPhoto];
}

-(void)tx_wkg_cameraEvents:(NSString*)title{
    if ([self.isfrontCamera isEqualToString:@"YES"] && self.toggleTorch) {
        [self  optionalFlashlightEvents:@"闪光灯"];
    }
    if ([[TXUGCRecord shareInstance]startRecord] ==0) {
        __weak typeof(self)weakSelf = self;
        [[TXUGCRecord shareInstance]snapshot:^(UIImage * snaps) {
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf)strongSelf = weakSelf;
                TX_WKG_PhotoEditViewController * photoEditVC = [[TX_WKG_PhotoEditViewController alloc]initWithCameraPhoto:snaps selecttedImages:nil];
                [strongSelf.navigationController pushViewController:photoEditVC animated:YES];
                photoEditVC.EditFinishBlock = ^(UIImage *image) {
                    
                    [[[TXUGCRecord shareInstance]partsManager]deleteAllParts];
                    [[TXUGCRecord shareInstance]stopRecord];
                    strongSelf.isShouldStartCameraPreView = @"NO";
                    
                    if (weakSelf.FinishSelectBlock) {
                        [self dismissViewControllerAnimated:NO completion:^{
                            NSMutableArray * viewArr = [self.navigationController.viewControllers mutableCopy];
                            if ([viewArr.lastObject isKindOfClass:[TX_WKG_PhotoEditViewController class]]) {
                                [viewArr removeLastObject];
                                self.navigationController.viewControllers = [viewArr copy];
                            }
                        }];
                        weakSelf.FinishSelectBlock(@[image]);
                    }else {
                        CY_FaceDynamicsIssueController * vc = [CY_FaceDynamicsIssueController new];
                        vc.selectImgArr = [@[image] mutableCopy];
                        [self.navigationController pushViewController:vc animated:NO];
                        
                    }
                };
                
            });
        }];
    }
}

-(void)tx_wkg_cameraEffectEvents:(NSString*)title{
    if ([[self.view subviews]containsObject:self.tx_wkgCameraBottomView]) {
        [self.tx_wkgCameraBottomView setHidden:YES];
    }
    if (![[self.view subviews]containsObject:self.camera_effectView]) {
        [self.view addSubview:self.camera_effectView];
    }
    __weak typeof(self)weakSelf = self;
    [self.view addSubview:self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.cameraOptionalView.mas_bottom);
        make.left.and.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).with.offset(-widthEx(375/3.f));
    }];
}

#pragma mark -getter method

-(HXDatePhotoToolManager *)photoRequestManager{
    _photoRequestManager = ({
        if (!_photoRequestManager) {
            _photoRequestManager = [[HXDatePhotoToolManager alloc]init];
        }
        _photoRequestManager;
    });
    return _photoRequestManager;
}

-(TX_WKG_Camera_EffectView *)camera_effectView{
    _camera_effectView = ({
        if (!_camera_effectView) {
            CGRect frame = CGRectMake(0,KScreenHeight - widthEx(375/3.f) , KScreenWidth, widthEx(375/3.f));
            if (kDevice_Is_iPhoneX) {
                frame = CGRectMake(0,KScreenHeight - widthEx(375/3.f) - widthEx(0.f) , KScreenWidth, widthEx(375/3.f));
            }
            _camera_effectView = [[TX_WKG_Camera_EffectView alloc]initWithFrame:frame];
            _camera_effectView.delegate = self;
        }
        _camera_effectView;
    });
    return _camera_effectView;
}

-(BeautySettingPanel *)beautySettingPanel{
    _beautySettingPanel = ({
        if (_beautySettingPanel == nil) {
            CGRect frame = CGRectMake(0, KScreenHeight - widthEx(375/3.f + 38.f + 17.f), CGRectGetWidth(self.view.frame), widthEx(375/3.f + 38.f + 17.f));
            _beautySettingPanel = [[BeautySettingPanel alloc]initWithFrame:frame beautyEffectType:@"photo"];
            _beautySettingPanel.delegate     = self;
        }
        _beautySettingPanel;
    });
    return _beautySettingPanel;
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

- (HXPhotoManager *)photoManager {
    if (!_photoManager) {
        _photoManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
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

-(TX_WKGOptCameraOverView *)cameraOverView{
    _cameraOverView = ({
        if (!_cameraOverView) {
            _cameraOverView = [[TX_WKGOptCameraOverView alloc]initWithFrame:CGRectZero];
            __weak  typeof(self)weakSelf = self;
            _cameraOverView.backgroundColor = [UIColor clearColor];
            _cameraOverView.callback = ^(NSString *title) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                NSDictionary * json = @{@"9-16":@"optionCameraRatioEvents:",
                                        @"3-4":@"optionCameraRatioEvents:",
                                        @"1-1":@"optionCameraRatioEvents:",
                                        @"延迟拍摄":@"optionalDelayCameraEvents:",
                                        @"延迟拍摄关闭":@"optionalDelayCameraEvents:",
                                        @"闪光灯":@"optionalFlashlightEvents:",
                                        @"闪光灯关闭":@"optionalFlashlightEvents:",
                                        };
                NSString * selector = json[title];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                SEL sel = NSSelectorFromString(selector);
                [strongSelf performSelector:sel withObject:title];
#pragma clang diagnostic pop
            };
        }
        _cameraOverView;
    });
    return _cameraOverView;
}

-(TX_WKGCameraBottomView *)tx_wkgCameraBottomView{
    _tx_wkgCameraBottomView = ({
        if (!_tx_wkgCameraBottomView) {
            _tx_wkgCameraBottomView = [[TX_WKGCameraBottomView alloc]initWithFrame:CGRectZero];
            __weak  typeof(self)weakSelf = self;
            _tx_wkgCameraBottomView.callback = ^(NSString *title) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                NSDictionary * json = @{@"导入":@"tx_wkg_exportSourcesEvents:",
                                        @"拍照":@"tx_wkg_cameraEvents:",
                                        @"滤镜":@"tx_wkg_cameraEffectEvents:",
                                        };
                NSString * selector = json[title];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                SEL sel = NSSelectorFromString(selector);
                [strongSelf performSelector:sel withObject:title];
#pragma clang diagnostic pop
            };
        }
        _tx_wkgCameraBottomView;
    });
    return _tx_wkgCameraBottomView;
}

-(TX_WKG_CameraOptionalView *)cameraOptionalView{
    _cameraOptionalView = ({
        if (!_cameraOptionalView) {
            _cameraOptionalView = [[TX_WKG_CameraOptionalView alloc]initWithFrame:CGRectZero];
            __weak  typeof(self)weakSelf = self;
            _cameraOptionalView.opt_callback = ^(UIButton *item, NSString *title) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                NSDictionary * json = @{@"返回":@"dimssViewControllerEvents:",
                                        @"更多":@"moreFuncationEvents:",
                                        @"美颜":@"cameraBeautyEvents:",
                                        @"旋转":@"cameraRotateEvents:",
                                        };
                NSString * selector = json[title];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                SEL sel = NSSelectorFromString(selector);
                [strongSelf performSelector:sel withObject:item];
#pragma clang diagnostic pop
            };
        }
        _cameraOptionalView;
    });
    return _cameraOptionalView;
}
#pragma mark - BeautySettingPanelDelegate
- (void)onSetBeautyStyle:(int)beautyStyle beautyLevel:(float)beautyLevel whitenessLevel:(float)whitenessLevel ruddinessLevel:(float)ruddinessLevel{
    [[TXUGCRecord shareInstance] setBeautyStyle:beautyStyle beautyLevel:beautyLevel whitenessLevel:whitenessLevel ruddinessLevel:ruddinessLevel];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    if ([self.isShouldStartCameraPreView isEqualToString:@"YES"]) {
    [[TXUGCRecord shareInstance]stopCameraPreview];
    [self startCameraPreview];
    //    }
    [self.cameraOverView settingTX_WKG_CameraOverViewControlStatusWithOptType:@"闪光灯关闭"];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationFade)];
    [[VideoRecordNoficationManager shareInstance]addObserverNotifications];
    [[VideoRecordNoficationManager shareInstance]runingProcessMonopolizeCallback:^(BOOL foreground) {
    }];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

#pragma mark - setter methods
//当前点击关闭按钮应该是popViewController
-(void)videoCameraHasSelectedImagesCount:(NSInteger)selectedCount images:(NSArray<UIImage*>*)images{
    //    self.dismissShouldPopViewController = @"YES";
    self.isShouldStartCameraPreView = @"NO";
    if (images == nil) return;
    [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
    }];
    self.photoManager.configuration.photoMaxNum = 9 - self.selectedIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toggleTorch = NO; //是否开启了闪光灯吧
    self.countdownTime = 3.f;
    self.isShouldStartCameraPreView = @"YES";
    self.isElectPublishAddress = @"NO";
    self.view.backgroundColor = rgba(247, 247, 247, 1.f);
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self loadObjectViews];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tx_wkg_photo_publish_events:) name:TX_WKG_PHOTO_PUBLISH_NOTIFICATION_DEFINER object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tx_wkg_photo_publish_elect_address_events:) name:TX_WKG_PHOTO_PUBLISH_ELECT_ADDRESS_NOTIFICATION_DEFINER object:nil];
}
-(void)tx_wkg_photo_publish_elect_address_events:(NSNotification*)notification{
    id obj = notification.object;
    if ([obj isKindOfClass:[NSString class]]) {
        NSString * string = obj;
        self.isShouldStartCameraPreView = string;
        self.isElectPublishAddress = @"YES";
    }
}

-(void)tx_wkg_photo_publish_events:(NSNotification*)notification{
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:TX_WKG_PHOTO_PUBLISH_NOTIFICATION_DEFINER object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:TX_WKG_PHOTO_PUBLISH_ELECT_ADDRESS_NOTIFICATION_DEFINER object:nil];
    
}

-(void)loadObjectViews{
    __weak typeof(self)weakSelf = self;
    [self setgpuCameraViews];
    [self.view addSubview:self.cameraOptionalView];
    SC_ViewSafeAreInsets(self.view);
    [self.cameraOptionalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf.view);
        if (SC_iPhoneX) {
            make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(SC_StatusBarHeight);
        }else{
            make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(0);
        }
        make.height.mas_equalTo(heightEx(30+ 2*12.f));
    }];
    [self.view addSubview:self.tx_wkgCameraBottomView];
    [self.tx_wkgCameraBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).with.offset(-widthEx(13.f));
        make.height.mas_equalTo(@(heightEx(80+ 12*2.f)));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

