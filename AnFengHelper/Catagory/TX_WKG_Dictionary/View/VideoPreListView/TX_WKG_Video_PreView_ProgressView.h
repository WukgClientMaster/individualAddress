//
//  TX_WKG_Video_PreView_ProgressView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/30.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef  TX_WKG_VIDEO_PREVIEW_CONTENT_KEY
#define  TX_WKG_VIDEO_PREVIEW_CONTENT_KEY
typedef NS_ENUM(NSInteger,TX_WKG_VIDEO_PREVIEW_ZOOM_SCALE_TYPE){
    TX_WKG_VIDEO_PREVIEW_ZOOM_SCALE_NONE,
    TX_WKG_VIDEO_PREVIEW_ZOOM_SCALE_RETIO,
};
#endif

//@"type":@"进度",@"value":@(timeinterval)
typedef void (^TX_WKG_VIDEO_AUTO_PROGRESS_CALLBACK)(NSDictionary * optjson);

@interface TX_WKG_Video_PreView_ProgressView : UIView
@property (assign, nonatomic) TX_WKG_VIDEO_PREVIEW_ZOOM_SCALE_TYPE  zoomScaleType;
@property (copy, nonatomic) TX_WKG_VIDEO_AUTO_PROGRESS_CALLBACK autoprogressCallback;

-(void)setOptionalZoomScaleWithStatus:(BOOL)status;
-(void)setVideoDurationWithUrl:(NSURL*)videoUrl;
-(void)setVideoPlayProgress:(CGFloat)progress; //设置播放进度
@end
