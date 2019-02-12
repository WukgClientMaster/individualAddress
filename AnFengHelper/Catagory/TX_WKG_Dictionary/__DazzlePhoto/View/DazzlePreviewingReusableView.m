//
//  DazzlePreviewingReusableView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "DazzlePreviewingReusableView.h"

@interface DazzlePreviewingReusableView ()
@property (strong, nonatomic) UIImageView * placeholder_imageView;
@property (strong, nonatomic) UILabel * placeholder_label;
@end

@implementation DazzlePreviewingReusableView

#pragma mark - getter methods
-(UIImageView *)placeholder_imageView{
    _placeholder_imageView = ({
        if (!_placeholder_imageView) {
            _placeholder_imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            _placeholder_imageView.contentMode = UIViewContentModeCenter;
            _placeholder_imageView.layer.masksToBounds = YES;
            _placeholder_imageView.image = [UIImage imageNamed:@"imgs.bundle/__wkg_qmx_photovideo_zhanwei"];
        }
        _placeholder_imageView;
    });
    return _placeholder_imageView;
}

-(UILabel *)placeholder_label{
    _placeholder_label = ({
        if (!_placeholder_label) {
            _placeholder_label = [UILabel new];
            _placeholder_label.text = @"请选择视频或图片，照片至少3张";
            _placeholder_label.textColor = UIColorFromRGB(0x999999);
            _placeholder_label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14.f];
        }
        _placeholder_label;
    });
    return _placeholder_label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    [self addSubview:self.placeholder_imageView];
    [self addSubview:self.placeholder_label];
}

-(void)setViewsHidden:(BOOL)hidden{
    if (self.placeholder_imageView && self.placeholder_label) {
        [self.placeholder_imageView setHidden:hidden];
        [self.placeholder_label setHidden:hidden];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.placeholder_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(97, 85));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).with.offset(-30.f);
    }];
    [self.placeholder_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.placeholder_imageView.mas_bottom).with.offset(22.f);
    }];
}

@end
