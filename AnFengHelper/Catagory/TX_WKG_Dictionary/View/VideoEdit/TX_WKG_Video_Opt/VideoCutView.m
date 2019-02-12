//
//  VideoCutView.m
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/11.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "VideoCutView.h"
#import "VideoRangeConst.h"
#import "VideoRangeSlider.h"
#import "RangeConfig.h"
#import "ColorMacro.h"
#import "UIView+Additions.h"
#import <TXLiteAVSDK_Professional/TXVideoEditer.h>


@interface VideoCutView ()<VideoRangeSliderDelegate>

@end

@implementation VideoCutView
{
    CGFloat         _duration;          //视频时长
    UILabel*        _timeTipsLabel;    //当前播放时间显示
    NSString*       _videoPath;         //视频路径
    AVAsset*        _videoAssert;
    BOOL            _isContinue;
}

- (id)initWithFrame:(CGRect)frame videoPath:(NSString *)videoPath  videoAssert:(AVAsset *)videoAssert
{
    if (self = [super initWithFrame:frame]) {
        _videoPath = videoPath;
        _videoAssert = videoAssert;
        
        _timeTipsLabel = [[UILabel alloc] init];
        _timeTipsLabel.text = @"0 s";
        _timeTipsLabel.textAlignment = NSTextAlignmentCenter;
        _timeTipsLabel.font = [UIFont systemFontOfSize:14];
        _timeTipsLabel.textColor = [UIColor whiteColor];
        [self addSubview:_timeTipsLabel];
        RangeConfig * config = [[RangeConfig alloc]init];
        config.pinWidth    = PIN_WIDTH;
        config.thumbHeight = THUMB_HEIGHT;
        config.borderHeight = BORDER_HEIGHT;
        config.leftPinImage = [UIImage imageNamed:@"left@2x.png"];
        config.centerPinImage = [UIImage imageNamed:@"center"];
        config.rightPigImage = [UIImage imageNamed:@"right@2x.png"];
        _videoRangeSlider = [[VideoRangeSlider alloc]initWithFrame:CGRectMake(CGRectGetMinX(frame), heightEx(20), CGRectGetWidth(frame), CGRectGetHeight(frame) - heightEx(20.f))];
        _videoRangeSlider.appearanceConfig = config;
        [self addSubview:_videoRangeSlider];
        TXVideoInfo *videoMsg = [TXVideoInfoReader getVideoInfoWithAsset:_videoAssert];
        _duration   = videoMsg.duration;
        
        //显示微缩图列表
        _imageList = [NSMutableArray new];
        int imageNum = 12;
        
        _isContinue = YES;
        [TXVideoInfoReader getSampleImages:imageNum videoAsset:_videoAssert progress:^BOOL(int number, UIImage *image) {
            if (!_isContinue) {
                return NO;
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!_isContinue) {
                        return;
                    }
                    if (number == 1) {
                        _videoRangeSlider.delegate = self;
                        for (int i = 0; i < imageNum; i++) {
                            [_imageList addObject:image];
                        }
                        [_videoRangeSlider setImageList:_imageList];
                        [_videoRangeSlider setDurationMs:_duration];
                    } else {
                        _imageList[number-1] = image;
                        [_videoRangeSlider updateImage:image atIndex:number-1];
                    }
                });
                return YES;
            }
        }];
    }
    return self;
}

- (void)stopGetImageList
{
    _isContinue = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _timeTipsLabel.frame = CGRectMake(self.width / 2 - 30 * kScaleX, 0, 60 * kScaleX, heightEx(20));
     CGFloat videoRangeSliderHeight = CGRectGetHeight(self.frame) - heightEx(20);
    _videoRangeSlider.frame = CGRectMake(0, _timeTipsLabel.bottom, self.width,  videoRangeSliderHeight);
}

- (void)dealloc
{
    NSLog(@"VideoCutView dealloc");
}

- (void)setPlayTime:(CGFloat)time
{
    _videoRangeSlider.currentPos = time;
    _timeTipsLabel.text = [NSString stringWithFormat:@"%.2f s",time];
}

- (void)setCenterPanHidden:(BOOL)isHidden
{
    [_videoRangeSlider setCenterPanHidden:isHidden];
}

- (void)setCenterPanFrame:(CGFloat)time
{
    [_videoRangeSlider setCenterPanFrame:time];
}

- (void)startColoration:(UIColor *)color alpha:(CGFloat)alpha
{
    [_videoRangeSlider startColoration:color alpha:alpha];
}
- (void)stopColoration
{
    [_videoRangeSlider stopColoration];
}
- (void)removeLastColoration
{
    [_videoRangeSlider removeLastColoration];
}

- (void)onEffectDelete
{
    [self removeLastColoration];
    [self.delegate onEffectDelete];
}

#pragma mark - VideoRangeDelegate
//左拉
- (void)onVideoRangeLeftChanged:(VideoRangeSlider *)sender
{
    [self.delegate onVideoLeftCutChanged:sender];
}

- (void)onVideoRangeLeftChangeEnded:(VideoRangeSlider *)sender
{
    _videoRangeSlider.currentPos = sender.leftPos;
    _timeTipsLabel.text = [NSString stringWithFormat:@"%.2f s",sender.leftPos];
    [self.delegate onVideoCutChangedEnd:sender];
}

//中拉
- (void)onVideoRangeCenterChanged:(VideoRangeSlider *)sender
{
    [self.delegate onVideoCenterRepeatChanged:sender];
}

- (void)onVideoRangeCenterChangeEnded:(VideoRangeSlider *)sender
{
    [self.delegate onVideoCenterRepeatEnd:sender];
}

//右拉
- (void)onVideoRangeRightChanged:(VideoRangeSlider *)sender {
    [self.delegate onVideoRightCutChanged:sender];
}

- (void)onVideoRangeRightChangeEnded:(VideoRangeSlider *)sender
{
    _videoRangeSlider.currentPos = sender.leftPos;
    _timeTipsLabel.text = [NSString stringWithFormat:@"%.2f s",sender.leftPos];
    [self.delegate onVideoCutChangedEnd:sender];
}

- (void)onVideoRangeLeftAndRightChanged:(VideoRangeSlider *)sender {
    
}

//拖动缩略图条
- (void)onVideoRange:(VideoRangeSlider *)sender seekToPos:(CGFloat)pos {
    _timeTipsLabel.text = [NSString stringWithFormat:@"%.2f s",pos];
    [self.delegate onVideoCutChange:sender seekToPos:pos];
}

@end
