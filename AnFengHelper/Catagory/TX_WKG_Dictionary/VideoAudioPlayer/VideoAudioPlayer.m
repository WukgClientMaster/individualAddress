//
//  VideoAudioPlayer.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/12.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "VideoAudioPlayer.h"
#import "QMX_MusicTool.h"
#import "MusicOptionalModel.h"
#import "MusicPauseOrPlayOptModel.h"

@interface VideoAudioPlayer()<AVAudioPlayerDelegate>

@property (strong,readwrite, nonatomic) AVAudioPlayer * player;
@property (assign,readwrite,nonatomic) CMTimeRange timeRange;
@property (strong, nonatomic) MusicOptionalModel *optionModel;
@end
@implementation VideoAudioPlayer

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player{
    if (self.player || [self.player prepareToPlay]) {
        [self.player play];
    }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    if (self.player|| [self.player isPlaying]) {
        [self.player stop];
    }
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag && self.player) {
        if ([self.player prepareToPlay]) {
            //判断要不要seek
            CMTime start = self.timeRange.start;
            CMTime end = self.timeRange.duration;
            if (start.value == 0 && end.value == _optionModel.pauseOrPlayModel.duration.value) {
                [self.player play];
            }else{
                [self autoCircleEvents];
            }
        }
    }
}

-(instancetype)initWithContentsOfURL:(NSURL*)url timeRange:(CMTimeRange) timeRange musicOpt:(MusicOptionalModel*)musicOpt error:(NSError**)error{
    if (self = [super init]) {
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:error];
        [_player setVolume:1.0f];
        _player.delegate = self;
        _timeRange = timeRange;
        _optionModel = musicOpt;
        if ([_player isPlaying]) {
            [_player play];
        }
        else if ([_player prepareToPlay]) {
            CMTime start = _timeRange.start;
            CMTime end   = _timeRange.duration;
            if (start.value == 0 && end.value == _optionModel.pauseOrPlayModel.duration.value) {
                [_player play];
            }else{
                [self autoCircleEvents];
            }
        }
    }
    return self;
}

-(void)autoCircleEvents{
    CMTime start = self.timeRange.start;
    CMTime end = self.timeRange.duration;
    NSTimeInterval startTimeInterval = start.value / start.timescale;
    NSTimeInterval endTimeInterval = end.value / end.timescale + startTimeInterval;
    if (self.player.playing) {
        [self.player setCurrentTime:startTimeInterval];
    }else{
        [self.player play];
        [self.player setCurrentTime:startTimeInterval];
    }
    CGFloat interval = endTimeInterval - startTimeInterval;
    __weak typeof(self)weakSelf = self;
    [QMX_MusicTool shareInstance].count +=1;
    [[QMX_MusicTool shareInstance]autoCircleCalcuateForInterval:interval complete:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.player setCurrentTime:startTimeInterval];
    }];
}

-(void)pausePlay{
    if (self.player) {
        [self.player pause];
    }
}

-(void)stopPlay{
    if (self.player) {
        [self.player stop];
    }
}

-(void)resumePlay{
    if (self.player) {
        [self.player play];
    }
}

-(void)deallocAudioPlayer{
    _player = nil;
    _timeRange = kCMTimeRangeZero;
    _optionModel = nil;
}
@end
