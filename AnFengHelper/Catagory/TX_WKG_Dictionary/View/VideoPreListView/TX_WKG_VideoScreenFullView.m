//
//  TX_WKG_VideoScreenFullView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/1.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_VideoScreenFullView.h"
#import "TX_WKG_Video_PreView_ProgressView.h"
#import "QMX_VideoPlayerView.h"
#import "AlbumVideoPreView.h"

@interface TX_WKG_VideoScreenFullView ()
@property (strong, nonatomic) TX_WKG_Video_PreView_ProgressView  * preProgressView;
@property (strong, nonatomic) UIView * playerView;
@property (assign, nonatomic) CGFloat videoProgress;
@end


@implementation TX_WKG_VideoScreenFullView
-(instancetype)initWithVideoPlayer:(UIView*)videoPlayer progressView:(TX_WKG_Video_PreView_ProgressView*)preProgressView  playProgress:(CGFloat)progress{
    CGRect rect = [UIScreen mainScreen].bounds;
    if ([super initWithFrame:rect]) {
        self.playerView = videoPlayer;
        self.videoProgress = progress;
        self.preProgressView = preProgressView;
        [self setup];
    }
    return self;
}

-(void)setup{
    self.backgroundColor = [UIColor blackColor];
    self.transform = CGAffineTransformMakeRotation(M_PI_2*3);
    self.playerView.frame = CGRectMake(0,0,KScreenHeight,KScreenWidth);
    if ([self.playerView isKindOfClass:[AlbumVideoPreView class]]) {
        AlbumVideoPreView * preView = (AlbumVideoPreView*)self.playerView;
        preView.renderView.frame =CGRectMake(0,0,KScreenHeight,KScreenWidth);
        preView.playLayer.bounds   = preView.renderView.bounds;
        preView.playLayer.position = preView.renderView.center;
    }
    self.preProgressView.frame = CGRectMake(0, KScreenWidth - widthEx(40+ 12), KScreenHeight, widthEx(40));
    [self addSubview:self.playerView];
    [self addSubview:self.preProgressView];
}


-(void)setFullScreenProgressStatusWithTitle:(NSString*)title{
    BOOL status = [title isEqualToString:@"YES"] ? NO : YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.preProgressView.alpha = 1.f;
    }completion:^(BOOL finished) {
        [self.preProgressView setHidden:status];
    }];
}
@end
