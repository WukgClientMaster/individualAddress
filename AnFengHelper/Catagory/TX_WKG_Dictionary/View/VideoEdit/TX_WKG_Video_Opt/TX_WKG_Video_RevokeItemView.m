//
//  TX_WKG_Video_RevokeItemView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/19.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Video_RevokeItemView.h"

@interface TX_WKG_Video_RevokeItemView()
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIImageView * imageView;

@end

@implementation TX_WKG_Video_RevokeItemView
#pragma mark - IBOutlet Evnents
-(void)revokeEvents:(UIControl*)controll{
    if (self.callback) {
        self.callback(self);
    }
}

#pragma mark - getter methods
-(UILabel *)label{
    _label = ({
        if (!_label) {
            _label = [UILabel new];
            _label.textAlignment = NSTextAlignmentCenter;
            _label.text = @"撤销";
            _label.font = [UIFont systemFontOfSize:widthEx(13.f)];
            _label.textColor = [UIColor whiteColor];
        }
        _label;
    });
    return _label;
}

-(UIImageView *)imageView{
    _imageView = ({
        if (!_imageView) {
            _imageView = [[UIImageView alloc]init];
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
            _imageView.image = [UIImage imageNamed:@"qmx_bianji_chexiao"];
        }
        _imageView;
    });
    return _imageView;
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
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2f];
    [self addSubview:self.label];
    [self addSubview:self.imageView];
    [self addTarget:self action:@selector(revokeEvents:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setBgroundColor:(UIColor *)bgroundColor{
    _bgroundColor = bgroundColor;
    self.backgroundColor = _bgroundColor;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    __weak  typeof(self)weakSelf = self;
    __block CGFloat padding =  widthEx(12.f);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = widthEx(6.f);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(0.f);      make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.left.mas_equalTo(weakSelf.imageView.mas_right).with.offset(padding/2.f);
    }];
}
@end
