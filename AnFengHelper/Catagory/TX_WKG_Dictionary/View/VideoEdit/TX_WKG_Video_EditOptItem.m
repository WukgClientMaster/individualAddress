//
//  TX_WKG_Video_EditOptItem.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Video_EditOptItem.h"

@interface TX_WKG_Video_EditOptItem()
@property (strong, nonatomic) UILabel * title_label;
@property (strong, nonatomic) UIView * backgroundView;
@end

@implementation TX_WKG_Video_EditOptItem

-(void)touchEvents:(UITapGestureRecognizer*)gesture{
    if (self.callback) {
        self.callback(self);
    }
}

-(void)configParamImgString:(NSString *)imgString title:(NSString *)title indefiner:(NSString *)indefiner{
    [super configParamImgString:imgString indefiner:indefiner];
    self.title_label.text = title;
}

#pragma mark - getter methods
-(UIView *)backgroundView{
    _backgroundView = ({
        if (!_backgroundView) {
            _backgroundView = [[UIView alloc]initWithFrame:CGRectZero];
            _backgroundView.layer.masksToBounds = YES;
            _backgroundView.backgroundColor = [UIColor clearColor];
        }
        _backgroundView;
    });
    return _backgroundView;
}

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
    [self.imageView removeFromSuperview];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
    }];
    [self.backgroundView setUserInteractionEnabled:YES];
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchEvents:)];
    gesture.numberOfTapsRequired = 1.f;
    [self.backgroundView addGestureRecognizer:gesture];
    [self addSubview:self.title_label];
    [self addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.imageView];
}


-(void)layoutSubObjects{
    __weak typeof(self)weakSelf = self;
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.mas_top);
        make.height.mas_equalTo(@(widthEx(50.f)));
    }];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.backgroundView.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.backgroundView.mas_centerY);
    }];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    make.top.mas_equalTo(weakSelf.backgroundView.mas_bottom).with.offset(widthEx(-4.f));
    }];
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.cornerRadius = widthEx(50.f)/2.f;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self layoutSubObjects];
}

@end
