//
//  MusicPauseOrPlayOptModel.m
//  SmartCity
//
//  Created by 吴可高 on 2018/1/18.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "MusicPauseOrPlayOptModel.h"
@implementation MusicPauseOrPlayOptModel

-(CMTimeRange)selMusicRange{
    if (self.calcauteDurationSuccess == NO) {
        CMTime startTime = CMTimeMake((int64_t)0, (int32_t)self.duration.value /self.duration.timescale);
        CMTime endTime = CMTimeMake((int64_t)self.duration.value, (int32_t)self.duration.value/self.duration.timescale);
        return CMTimeRangeFromTimeToTime(startTime, endTime);
    }
    return _selMusicRange;
}

-(CMTime)duration{
    if (self.calcauteDurationSuccess == NO) {
        if (self.cachePath.length !=0 || self.cachePath != nil) {
            AVAsset *as = [AVAsset assetWithURL:[NSURL fileURLWithPath:self.cachePath]];
            self.calcauteDurationSuccess = YES;
            return as.duration;
        }
        return kCMTimeZero;
    }
    return _duration;
}

-(NSTimeInterval)startTime{
    return self.calcauteDurationSuccess == NO ? 0 : _startTime;
}

-(NSTimeInterval)endTime{
    return self.calcauteDurationSuccess == NO ?(self.duration.value / self.duration.timescale) : _endTime;
}

@end
