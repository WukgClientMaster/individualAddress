//
//  VideoRecordNoficationManager.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/13.
//  Copyright © 2018年 NRH. All rights reserved.
//


#import "VideoRecordNoficationManager.h"
static VideoRecordNoficationManager * _videoRecordNotificationManager = nil;
@interface VideoRecordNoficationManager()
@property (assign,readwrite,nonatomic) BOOL  foreground;
@property (copy,readwrite,nonatomic) VideoRecordNoficationAPPProcess callback;
@end

@implementation VideoRecordNoficationManager

+(instancetype)shareInstance{
    if (_videoRecordNotificationManager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (_videoRecordNotificationManager == nil) {
                _videoRecordNotificationManager = [[VideoRecordNoficationManager alloc]init];
            }
        });
    }
    return _videoRecordNotificationManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
         _foreground = YES;
        [self addObserverNotifications];
    }
    return self;
}
//后台
-(void)onAppDidEnterBackGround:(NSNotification*)notification{
    self.foreground = NO;
    if (self.callback) {
        self.callback(self.foreground);
    }
}
//立马进入前台
-(void)onAppWillEnterForeground:(NSNotification*)notification{
    self.foreground = YES;
    if (self.callback) {
        self.callback(self.foreground);
    }
}

//已经进入前台
-(void)onAppDidBecomeActive:(NSNotification*)notification{
    self.foreground = YES;
    if (self.callback) {
        self.callback(self.foreground);
    }
}
//将要失去前台活动任务
-(void)onAppWillResignActive:(NSNotification*)notification{
    self.foreground = NO;
    if (self.callback) {
        self.callback(self.foreground);
    }
}
//视频或者音频被打断
-(void)onAudioSessionEvent:(NSNotification*)notification{
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan){
        self.foreground = NO;
        
    }else if (type == AVAudioSessionInterruptionTypeEnded){
        self.foreground = YES;
    }
    if (self.callback) {
        self.callback(self.foreground);
    }
}

//横竖屏切换
-(void)statusBarOrientationChanged:(NSNotification*)notification{
    self.foreground = YES;
    if (self.callback) {
        self.callback(self.foreground);
    }
}

-(void)addObserverNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onAudioSessionEvent:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

-(void)runingProcessMonopolizeCallback:(VideoRecordNoficationAPPProcess)callback{
    _callback = callback;
}

-(void)removeAllObserverNotifications{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
