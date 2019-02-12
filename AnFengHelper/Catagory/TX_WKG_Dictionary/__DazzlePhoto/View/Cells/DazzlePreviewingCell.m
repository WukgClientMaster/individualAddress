//
//  DazzlePreviewingCell.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "DazzlePreviewingCell.h"
#import "PhotoDowloadTool.h"

@interface DazzlePreviewingCell()
@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UIView * coverView;
@property (strong, nonatomic) UIView * videoSelectdView;
@property (strong, nonatomic) UIImageView * play_imageView;
@property (strong, nonatomic) UIButton * selected_item;
@property (strong, nonatomic) UILabel * duration_label;
@property (strong, nonatomic) UIImageView * slogon_imageView;

@end

@implementation DazzlePreviewingCell
#pragma mark - IBOutlet Events
-(void)selectedEvents:(UIButton*)args{
    args.selected = !args.selected;
    if (self.didSelectedCallback) {
        NSString * status = args.selected ? @"selected": @"unSelected";
        self.didSelectedCallback(self.model, status,self);
    }
}
#pragma mark - getter methods
-(UIImageView *)slogon_imageView{
	_slogon_imageView = ({
		if (!_slogon_imageView) {
			_slogon_imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
			_slogon_imageView.image = [HXPhotoTools hx_imageNamed:@"icon_yunxiazai@2x.png"];
			_slogon_imageView.contentMode = UIViewContentModeCenter;
			_slogon_imageView.layer.masksToBounds = YES;
		}
		_slogon_imageView;
	});
	return _slogon_imageView;
}

-(UIImageView *)imageView{
    _imageView = ({
        if (!_imageView) {
            _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
            _imageView.layer.masksToBounds = YES;
            _imageView.image = [Tools placeholderColorImage];
        }
        _imageView;
    });
    return _imageView;
}

-(UIView *)coverView{
    _coverView = ({
        if (!_coverView) {
            _coverView = [[UIView alloc]initWithFrame:CGRectZero];
            _coverView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1f];
        }
        _coverView;
    });
    return  _coverView;
}
-(UIView *)videoSelectdView{
    _videoSelectdView = ({
        if (!_videoSelectdView) {
            _videoSelectdView = [[UIView alloc]initWithFrame:CGRectZero];
            _videoSelectdView.backgroundColor = [UIColor clearColor];
            _videoSelectdView.layer.masksToBounds = YES;
            _videoSelectdView.layer.borderWidth = 2.f;
            _videoSelectdView.layer.borderColor = UIColorFromRGB(0x09E9CD).CGColor;
        }
        _videoSelectdView;
    });
    return _videoSelectdView;
}

-(UIImageView *)play_imageView{
    _play_imageView = ({
        if (!_play_imageView) {
            _play_imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            _play_imageView.contentMode = UIViewContentModeCenter;
            _play_imageView.layer.masksToBounds = YES;
            _play_imageView.image = [UIImage imageNamed:@"imgs.bundle/__wkg_qmx_photovideo_play"];
        }
        _play_imageView;
    });
    return _play_imageView;
}

-(UIButton *)selected_item{
    _selected_item = ({
        if (!_selected_item) {
            _selected_item = [UIButton buttonWithType:UIButtonTypeCustom];
            [_selected_item addTarget:self action:@selector(selectedEvents:) forControlEvents:UIControlEventTouchUpInside];
            [_selected_item setImage:[UIImage imageNamed:@"imgs.bundle/__wkg_qmx_photovideo_unselected"] forState:UIControlStateNormal];
            [_selected_item setImage:[UIImage imageNamed:@"imgs.bundle/__wkg_qmx_photovideo_selected"] forState:UIControlStateSelected];
        }
        _selected_item;
    });
    return _selected_item;
}
-(UILabel *)duration_label{
    _duration_label = ({
        if (!_duration_label) {
            _duration_label = [UILabel new];
            _duration_label.textColor = UIColorFromRGB(0xFEFEFE);
            _duration_label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11.f];
        }
        _duration_label;
    });
    return _duration_label;
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
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.play_imageView];
    [self.contentView addSubview:self.selected_item];
    [self.contentView addSubview:self.duration_label];
	[self.contentView addSubview:self.slogon_imageView];
}

-(void)setModel:(DazzleAssetModel *)model{
    _model = model;
    if (_model == nil)return;
	if (_model.clould) {
		[self.slogon_imageView setHidden:YES];
	}else{
		[self.slogon_imageView setHidden:YES];
	}
    if (_model.mediaType == PHAssetMediaTypeImage) {
        [self.duration_label setHidden:YES];
        [self.play_imageView setHidden:YES];
        [self.selected_item setHidden:NO];
	
        [self.selected_item setSelected:_model.selected];
    }else if (_model.mediaType == PHAssetMediaTypeVideo){
        [self.duration_label setHidden:NO];
        [self.play_imageView setHidden:NO];
        [self.selected_item setHidden:YES];
        self.duration_label.text = _model.durationName;
    }
    if (_model.selected) {
        if (_model.mediaType == PHAssetMediaTypeImage) {
            [self.contentView insertSubview:self.coverView belowSubview:self.selected_item];
            [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsZero);
            }];
        }else if (_model.mediaType == PHAssetMediaTypeVideo){
            [self.contentView addSubview:self.videoSelectdView];
            [self.videoSelectdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsZero);
            }];
        }
    }else{
        if ([[self.contentView subviews]containsObject:self.coverView]) {
            [self.coverView removeFromSuperview];
            [self.coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
            }];
        }
        if ([[self.contentView subviews]containsObject:self.videoSelectdView]) {
            [self.videoSelectdView removeFromSuperview];
            [self.videoSelectdView mas_remakeConstraints:^(MASConstraintMaker *make) {
            }];
        }
    }
    if (_model.image) {
        self.imageView.image = _model.image;
        return;
    }
    __weak typeof(self)weakSelf = self;
    [PhotoDowloadTool getHighQualityFormatPhoto:_model.phAsset size:CGSizeMake(100, 100) startRequestIcloud:^(PHImageRequestID cloudRequestId) {
    } progressHandler:^(double progress) {
    } completion:^(UIImage *image) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.imageView.image = image;
        _model.image = image;
    } failed:^(NSDictionary *info) {
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof(self)weakSelf = self;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsZero);
    }];
    [self.play_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 17));
        make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(4.f);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset(-4.f);
    }];
    [self.selected_item mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-4.f);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset(-4.f);
    }];
    [self.duration_label mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-4.f);
    make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset(-4.f);
    }];
	[self.slogon_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(0.f);
		make.top.mas_equalTo(weakSelf.contentView.mas_top).with.offset(0.f);
		make.size.mas_equalTo(CGSizeMake(20, 20));
	}];
}

@end
