//
//  AssetOptionalTopView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "AssetOptionalTopView.h"
@interface  AssetOptionalTopView ()
@property (strong, nonatomic) UIButton * dismiss_item;
@property (strong, nonatomic) UIButton * next_item;
@property (strong, nonatomic) UIView * titleView;
@property (strong, nonatomic) UILabel * title_label;
@property (strong, nonatomic) UIImageView * indicatorImageView;

@end

@implementation AssetOptionalTopView

#pragma mark - IBOutlet Events
// @"next", @"category",@"dismiss"
-(void)categoryEvents:(UIButton*)args{
    if (self.callback) {
        self.callback(@"category");
    }
}

-(void)dismissEvents:(UIButton*)args{
    if (self.callback) {
        self.callback(@"dismiss");
    }
}
-(void)nextEvents:(UIButton*)args{
    if (self.callback) {
        self.callback(@"next");
    }
}

-(UIButton *)dismiss_item{
    _dismiss_item = ({
        if (!_dismiss_item) {
            _dismiss_item = [UIButton buttonWithType:UIButtonTypeCustom];
            [_dismiss_item setImage:[UIImage imageNamed:@"imgs.bundle/__wkg_qmx_photovideo_close"] forState:UIControlStateNormal];
            _dismiss_item.imageView.contentMode = UIViewContentModeCenter;
            [_dismiss_item addTarget:self action:@selector(dismissEvents:) forControlEvents:UIControlEventTouchUpInside];
            _dismiss_item.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
        _dismiss_item;
    });
    return _dismiss_item;
}

-(UIButton *)next_item{
    _next_item = ({
        if (!_next_item) {
            _next_item = [UIButton buttonWithType:UIButtonTypeCustom];
            [_next_item setTitle:@"下一步" forState:UIControlStateNormal];
            [_next_item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _next_item.titleLabel.font = [UIFont systemFontOfSize:15.f];
            [_next_item addTarget:self action:@selector(nextEvents:) forControlEvents:UIControlEventTouchUpInside];
            _next_item.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
        _next_item;
    });
    return _next_item;
}
-(UIView *)titleView{
    _titleView = ({
        if (!_titleView) {
            _titleView = [[UIView alloc]initWithFrame:CGRectZero];
            [_titleView setUserInteractionEnabled:YES];
            UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(categoryEvents:)];
            gesture.numberOfTapsRequired = 1.f;
            [_titleView addGestureRecognizer:gesture];
        }
        _titleView;
    });
    return _titleView;
}

-(UILabel *)title_label{
    _title_label = ({
        if (!_title_label) {
            _title_label = [UILabel new];
            _title_label.text = @"相机胶券";
            _title_label.font = [UIFont systemFontOfSize:16.f];
            _title_label.textColor = UIColorFromRGB(0x333333);
            _title_label.textAlignment = NSTextAlignmentCenter;
        }
        _title_label;
    });
    return _title_label;
}

-(UIImageView *)indicatorImageView{
    _indicatorImageView = ({
        if (!_indicatorImageView) {
            _indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            _indicatorImageView.image = [UIImage imageNamed:@"imgs.bundle/__wkg_qmx_photovideo_more"];
            _indicatorImageView.contentMode = UIViewContentModeCenter;
        }
        _indicatorImageView;
    });
    return _indicatorImageView;
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
    [self addSubview:self.dismiss_item];
    [self addSubview:self.next_item];
    [self addSubview:self.titleView];
    [self.titleView addSubview:self.title_label];
    [self.titleView addSubview:self.indicatorImageView];
}

-(void)setCategoryWithString:(NSString*)string{
    if(string == nil|| string.length ==0)return;
    self.title_label.text = string;
}

-(void)setCategoryViewsHidden:(BOOL)hidden{
    if (self.dismiss_item && self.next_item) {
        [self.dismiss_item setHidden:hidden];
        [self.next_item setHidden:hidden];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof(self)weakSelf = self;
    CGFloat offSetY = SC_iPhoneX ? 18 : 6;
    [self.dismiss_item mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24.f));
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(12.f);
        make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(offSetY);
    }];
    [self.next_item mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 30.f));
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-12.f);
        make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(offSetY);
    }];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX).with.offset(0.f);
        make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(offSetY);
        make.size.mas_equalTo(CGSizeMake(140, CGRectGetHeight(self.frame)));
    }];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.titleView.mas_centerX).with.offset(0.f);
        make.centerY.mas_equalTo(weakSelf.titleView.mas_centerY);
    }];
    [self.indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.title_label.mas_right).with.offset(4.f);
        make.centerY.mas_equalTo(weakSelf.titleView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
}
@end
