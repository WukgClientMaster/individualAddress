//
//  TX_WKG_Photo_AdapterCollectionCell.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/7/4.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Photo_AdapterCollectionCell.h"

@interface TX_WKG_Photo_AdapterCollectionCell()
@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UILabel * desc_label;
@end

@implementation TX_WKG_Photo_AdapterCollectionCell

-(UILabel *)desc_label{
    _desc_label = ({
        if (!_desc_label) {
            _desc_label = [[UILabel alloc]init];
            _desc_label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12.f];
            _desc_label.textColor = UIColorFromRGB(0xFC4C70);
            _desc_label.textAlignment = NSTextAlignmentCenter;
        }
        _desc_label;
    });
    return _desc_label;
}

-(UIImageView *)imageView{
    _imageView = ({
        if (!_imageView) {
            _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            _imageView.contentMode = UIViewContentModeCenter;
        }
        _imageView;
    });
    return _imageView;
}

#pragma mark - setter methods
-(void)setAdapterNode:(TX_WKG_Clips_Node *)adapterNode{
    _adapterNode  = adapterNode;
    if (_adapterNode == nil) return;
    self.desc_label.text = _adapterNode.title;
    if (_adapterNode.selected) {
        self.imageView.image  = [UIImage imageNamed:_adapterNode.selectedImgString];
        self.desc_label.textColor = UIColorFromRGB(0xFC4C70);
    }else{
        self.desc_label.textColor = UIColorFromRGB(0x444444);
        self.imageView.image  = [UIImage imageNamed:_adapterNode.normalImgString];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    [self addSubview:self.imageView];
    __weak typeof(self)weakSelf = self;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
    make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY).with.offset(-widthEx(8.f));
        make.size.mas_equalTo(CGSizeMake(widthEx(35), widthEx(35)));
    }];
    [self addSubview:self.desc_label];
    [self.desc_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
     make.top.mas_equalTo(weakSelf.imageView.mas_bottom).with.offset(0.f);
    }];
}

@end
