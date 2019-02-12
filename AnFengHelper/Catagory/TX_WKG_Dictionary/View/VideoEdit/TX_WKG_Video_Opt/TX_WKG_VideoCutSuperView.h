//
//  TX_WKG_VideoCutSuperView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/19.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoRangeSlider.h"
#import "VideoCutView.h"

#ifndef  TX_WKG_VIDEOCUTSUPERVIEW
#define  TX_WKG_VIDEOCUTSUPERVIEW
typedef NS_ENUM(NSInteger,TX_WKG_VIDEO_CUTOPT_TYPE){
    TX_WKG_VIDEO_CUTOPT_CUT_TYPE,
    TX_WKG_VIDEO_CUTOPT_EFFECT_TYPE
};
#endif


@interface TX_WKG_VideoCutSuperView : UIView
@property (assign,nonatomic) TX_WKG_VIDEO_CUTOPT_TYPE  opt_type;
@property (strong, nonatomic) UIColor * bgroundColor;
@property (strong,readwrite,nonatomic) VideoCutView * videoCutView;
@property (strong, nonatomic) UILabel * tips_label;

- (instancetype)initWithFrame:(CGRect)frame videoPath:(NSString *)videoPath  videoAssert:(AVAsset *)videoAssert opt_Type:(TX_WKG_VIDEO_CUTOPT_TYPE)optType;

@end
