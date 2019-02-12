//
//  VideoAudioPlayer.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/12.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MusicOptionalModel;
@interface VideoAudioPlayer : NSObject
@property (strong,readonly, nonatomic) AVAudioPlayer * player;
@property (assign,readonly,nonatomic)  CMTimeRange timeRange;

-(instancetype)initWithContentsOfURL:(NSURL*)url timeRange:(CMTimeRange) timeRange musicOpt:(MusicOptionalModel*)musicOpt error:(NSError**)error;

-(void)pausePlay;

-(void)stopPlay;

-(void)resumePlay;

-(void)deallocAudioPlayer;

@end
