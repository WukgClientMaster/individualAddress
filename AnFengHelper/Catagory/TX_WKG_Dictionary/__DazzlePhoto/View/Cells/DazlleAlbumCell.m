//
//  DazlleAlbumCell.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "DazlleAlbumCell.h"

@interface DazlleAlbumCell ()
@property (strong, nonatomic) UIImageView * bannar_imageView;
@property (strong, nonatomic) UIButton * delete_button;
@property (strong, nonatomic) UILabel * num_label;
@end

@implementation DazlleAlbumCell

#pragma mark -IBOutlet Events
-(void)deleteEvents:(UIButton*)args{
    if (self.callback) {
        self.callback(self.model);
    }
}
#pragma mark - getter methods
-(UILabel *)num_label{
    _num_label = ({
        if (!_num_label) {
            _num_label = [UILabel new];
            _num_label.backgroundColor = [UIColor blackColor];
            _num_label.textColor = [UIColor whiteColor];
            _num_label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:10.f];
        }
        _num_label;
    });
    return _num_label;
}

-(UIImageView *)bannar_imageView{
    _bannar_imageView = ({
        if (!_bannar_imageView) {
            _bannar_imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            _bannar_imageView.contentMode = UIViewContentModeScaleToFill;
            _bannar_imageView.layer.masksToBounds = YES;
            _bannar_imageView.image = [Tools placeholderColorImage];
        }
        _bannar_imageView;
    });
    return _bannar_imageView;
}

-(UIButton *)delete_button{
    _delete_button = ({
        if (!_delete_button) {
            _delete_button =  [UIButton buttonWithType:UIButtonTypeCustom];
            [_delete_button setImage:[UIImage imageNamed:@"imgs.bundle/__wkg_qmx_photovideo_delete"] forState:UIControlStateNormal];
            [_delete_button addTarget:self action:@selector(deleteEvents:) forControlEvents:UIControlEventTouchUpInside];
        }
        _delete_button;
    });
    return _delete_button;
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
    [self.contentView addSubview:self.bannar_imageView];
    [self.contentView addSubview:self.delete_button];
    [self.bannar_imageView addSubview:self.num_label];
}

-(void)setModel:(DazzleAssetModel *)model{
    _model = model;
    if (_model == nil)return;
    self.bannar_imageView.image = _model.image;
    self.num_label.text =  _model.sortNum;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.delete_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(0.f);
        make.top.mas_equalTo(self.contentView.mas_top);
    }];
    [self.bannar_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.delete_button.mas_centerY);
        make.left.mas_equalTo(self.delete_button.mas_centerX);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
    [self.num_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bannar_imageView.mas_right);
        make.bottom.mas_equalTo(self.bannar_imageView.bottom);
    }];
}
@end
