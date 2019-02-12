//
//  TX_WKG_VideoRecord_AuthorizateManager.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/24.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_VideoRecord_AuthorizateManager.h"

static TX_WKG_VideoRecord_AuthorizateManager * _authorizateManager = nil;

@interface TX_WKG_VideoRecord_AuthorizateManager()
@property (copy, nonatomic) TX_WKG_VideoRecordAuthorizateCallback callback;
@end

@implementation TX_WKG_VideoRecord_AuthorizateManager

+(instancetype)shareInstance{
    if (_authorizateManager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _authorizateManager = [[TX_WKG_VideoRecord_AuthorizateManager alloc]init];
        });
    }
    return _authorizateManager;
}

-(void)authVideo{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        BOOL authResult = NO;
        switch (authStatus) {
            case AVAuthorizationStatusNotDetermined:
                //没有询问是否开启相机
                break;
            case AVAuthorizationStatusRestricted:
                //未授权，家长限制
                break;
            case AVAuthorizationStatusDenied:
                //未授权
                break;
            case AVAuthorizationStatusAuthorized:
                //玩家授权
                authResult = YES;
                break;
            default:
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.callback) {
                self.callback(authResult, TX_WKGVideoRecoredAuthVideo);
            }
        });
    }];
}

-(void)authAudio{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted){
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        BOOL authResult = NO;
        switch (authStatus) {
            case AVAuthorizationStatusNotDetermined:
                //没有询问是否开启麦克风
                break;
            case AVAuthorizationStatusRestricted:
                //未授权，家长限制
                break;
            case AVAuthorizationStatusDenied:
                //玩家未授权
                break;
            case AVAuthorizationStatusAuthorized:
                //玩家授权
                authResult = YES;
                break;
            default:
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.callback) {
                self.callback(authResult, TX_WKGVideoRecoredAuthAudio);
            }
        });
    }];
}

-(void)authPhotoLibrary{
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    BOOL authResult = NO;
    switch (photoAuthorStatus) {
        case PHAuthorizationStatusAuthorized:
            authResult = YES;
            break;
        case PHAuthorizationStatusDenied:
            break;
        case PHAuthorizationStatusNotDetermined:
            break;
        case PHAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.callback) {
            self.callback(authResult, TX_WKGVideoRecoredAuthPhotoLibrary);
        }
    });
}

-(void)obtainAccountAuthorizateWithAuthType:(TX_WKGVideoRecoredAuthType)authType callback:(TX_WKG_VideoRecordAuthorizateCallback)callback{
    _callback = [callback copy];
    switch (authType) {
        case TX_WKGVideoRecoredAuthVideo:
            [self authVideo];
            break;
        case TX_WKGVideoRecoredAuthAudio:
            [self authAudio];
            break;
        case TX_WKGVideoRecoredAuthPhotoLibrary:
            [self authPhotoLibrary];
            break;
        default:
            break;
    }
}

@end
