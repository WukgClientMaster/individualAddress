//
//  MusicPauseOrPlayOptModel.h
//  SmartCity
//
//  Created by 吴可高 on 2018/1/18.
//  Copyright © 2018年 NRH. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface MusicPauseOrPlayOptModel : NSObject
@property (assign, nonatomic) NSTimeInterval startTime;
@property (assign, nonatomic) NSTimeInterval endTime;
@property (assign, nonatomic) NSTimeInterval playedTime;
@property (assign, nonatomic) CMTimeRange    selMusicRange;
@property(nonatomic,assign) CMTime  duration;
@property(nonatomic,assign,getter=isPause) BOOL  pause;// 暂停
@property (assign, nonatomic) NSInteger playCount;//播放次数
@property (assign, nonatomic) NSInteger userEditMusicCount;
@property(nonatomic,copy) NSString * cachePath;//缓存路径
@property(nonatomic,copy) NSString * clipsAudioPath;//缓存路径
@property (assign, nonatomic) BOOL  calcauteDurationSuccess;
@property (assign, nonatomic) BOOL  flage;
@end
