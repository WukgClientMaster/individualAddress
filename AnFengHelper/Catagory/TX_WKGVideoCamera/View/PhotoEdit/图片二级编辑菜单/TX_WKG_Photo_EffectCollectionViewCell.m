//
//  TX_WKG_Photo_EffectCollectionViewCell.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Photo_EffectCollectionViewCell.h"

@interface TX_WKG_Photo_EffectCollectionViewCell()
@property (strong, nonatomic) UIView * negativeView;
@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UIView * bottom_View;
@property (strong, nonatomic) UILabel * text_label;

@end

@implementation TX_WKG_Photo_EffectCollectionViewCell

-(UILabel *)text_label{
    _text_label = ({
        if (!_text_label) {
            _text_label = [UILabel new];
            _text_label.textColor = UIColorFromRGB(0x333333);
            _text_label.font = [UIFont systemFontOfSize:10.f];
            _text_label.textAlignment = NSTextAlignmentCenter;
            _text_label.text = @"默认";
        }
        _text_label;
    });
    return _text_label;
}

-(UIView *)bottom_View{
    _bottom_View = ({
        if (!_bottom_View) {
            _bottom_View = [[UIView alloc]initWithFrame:CGRectZero];
            _bottom_View.backgroundColor = [[UIColor lightTextColor]colorWithAlphaComponent:0.5f];
        }
        _bottom_View;
    });
    return _bottom_View;
}

-(UIImageView *)imageView{
    _imageView = ({
        if (!_imageView) {
            _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        _imageView;
    });
    return _imageView;
}

-(UIView *)negativeView{
    _negativeView = ({
        if (!_negativeView) {
            _negativeView = [[UIView alloc]initWithFrame:CGRectZero];
            _negativeView.layer.masksToBounds = YES;
        }
        _negativeView;
    });
    return _negativeView;
}

-(void)setup{
    [self addSubview:self.negativeView];
    __weak  typeof(self)weakSelf = self;
    self.negativeView.layer.borderWidth  = widthEx(2.f);
    self.negativeView.layer.cornerRadius = widthEx(2.f);
    self.negativeView.layer.borderColor = UIColorFromRGB(0xfe4e5b).CGColor;
    [self.negativeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.mas_top).with.offset(widthEx(7.f));
        make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(-widthEx(7.f));
    }];
    [self.negativeView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsMake(2, -2, 2, -2));
    }];
    [self.negativeView addSubview:self.bottom_View];
    [self.bottom_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf.negativeView.mas_width).with.offset(0.f);
        make.bottom.mas_equalTo(weakSelf.negativeView.mas_bottom);
        make.height.mas_equalTo(@(widthEx(25.f)));
    }];
    [self.bottom_View addSubview:self.text_label];
    [self.text_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.bottom_View.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.bottom_View.mas_centerY);
    }];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setEffectNode:(TX_WKG_Effect_Node *)effectNode{
    _effectNode = effectNode;
    self.text_label.text = _effectNode.text;
    self.imageView.image = [UIImage imageNamed:_effectNode.imageString];
    if (_effectNode.selected) {
        self.negativeView.layer.borderWidth  = widthEx(2.f);
        self.negativeView.layer.cornerRadius = widthEx(2.f);
        self.negativeView.layer.borderColor = UIColorFromRGB(0xfe4e5b).CGColor;
    }else{
        self.negativeView.layer.borderWidth  = widthEx(0.f);
        self.negativeView.layer.cornerRadius = widthEx(0.f);
        self.negativeView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
