//
//  TX_WKG_VideoCutSuperView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/19.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_VideoCutSuperView.h"
@interface TX_WKG_VideoCutSuperView()
@property (copy, nonatomic) NSString * videoPath;
@property (strong, nonatomic) AVAsset * videoAsset;
@end

@implementation TX_WKG_VideoCutSuperView
#pragma mark - getter methods
-(UILabel *)tips_label{
    _tips_label = ({
        if (!_tips_label) {
            _tips_label = [UILabel new];
            _tips_label.text = @"请选择视频的剪裁区域";
            _tips_label.font = [UIFont systemFontOfSize:14];
            _tips_label.textColor = [UIColor whiteColor];
            _tips_label.textAlignment = NSTextAlignmentCenter;
        }
        _tips_label;
    });
    return _tips_label;
}

- (instancetype)initWithFrame:(CGRect)frame videoPath:(NSString *)videoPath  videoAssert:(AVAsset *)videoAssert opt_Type:(TX_WKG_VIDEO_CUTOPT_TYPE)optType{
    if (self = [super initWithFrame:frame]) {
        _opt_type = optType;
        _videoPath = videoPath;
        _videoAsset  = videoAssert;
    }
    return self;
}

-(void)judgementWithOptType:(TX_WKG_VIDEO_CUTOPT_TYPE)optType{
    if (optType == TX_WKG_VIDEO_CUTOPT_EFFECT_TYPE) {
        if ([[self subviews]containsObject:self.tips_label]) {
            [self.tips_label removeFromSuperview];
        }
    }else if(optType == TX_WKG_VIDEO_CUTOPT_CUT_TYPE){
         self.tips_label.frame = CGRectMake(0, CGRectGetMaxY(self.videoCutView.frame) + heightEx(30.f), CGRectGetWidth(self.frame),([self.tips_label getTextHeight]) * 1.5);
         [self addSubview:self.tips_label];
    }
}

-(void)setBgroundColor:(UIColor *)bgroundColor{
    _bgroundColor = bgroundColor;
    self.backgroundColor = _bgroundColor;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self judgementWithOptType:_opt_type];
}
@end
