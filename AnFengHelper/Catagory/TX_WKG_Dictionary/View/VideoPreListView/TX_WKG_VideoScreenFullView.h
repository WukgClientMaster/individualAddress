//
//  TX_WKG_VideoScreenFullView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/1.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QMX_VideoPlayerView;
@class TX_WKG_Video_PreView_ProgressView;

@interface TX_WKG_VideoScreenFullView : UIView

-(instancetype)initWithVideoPlayer:(UIView*)videoPlayer progressView:(TX_WKG_Video_PreView_ProgressView*)preProgressView  playProgress:(CGFloat)progress;
-(void)setFullScreenProgressStatusWithTitle:(NSString*)title;

@end
