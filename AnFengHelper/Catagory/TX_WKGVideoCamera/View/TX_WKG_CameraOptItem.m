//
//  TX_WKG_CameraOptItem.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_CameraOptItem.h"

@interface TX_WKG_CameraOptItem ()
@property (strong,readwrite,nonatomic) UILabel * title_label;
@property (copy,readwrite,nonatomic) NSString * optType;

@end

@implementation TX_WKG_CameraOptItem

-(UILabel *)title_label{
    _title_label = ({
        if (!_title_label) {
            _title_label = [UILabel new];
            _title_label.font = [UIFont systemFontOfSize:widthEx(13.f)];
            _title_label.textColor = [UIColor whiteColor];
            _title_label.textAlignment = NSTextAlignmentCenter;
            _title_label.backgroundColor = [UIColor clearColor];
        }
        _title_label;
    });
    return _title_label;
}

-(void)setup{
    [super setup];
    self.imageView.contentMode = UIViewContentModeCenter;
    [self  addSubview:self.title_label];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof(self)weakSelf = self;
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    make.top.mas_equalTo(weakSelf.imageView.mas_bottom).with.offset(widthEx(4.f));
    }];
}

-(void)configParamImgString:(NSString*)imgString title:(NSString*) title indefiner:(NSString*)indefiner optType:(NSString*)optType{
    [super configParamImgString:imgString highlight:title indefiner:indefiner];
    self.optType = optType;
}

-(void)configParamImgString:(NSString *)imgString title:(NSString *)title indefiner:(NSString *)indefiner{
    [super configParamImgString:imgString indefiner:indefiner];
    self.title_label.text = title;
}
@end
