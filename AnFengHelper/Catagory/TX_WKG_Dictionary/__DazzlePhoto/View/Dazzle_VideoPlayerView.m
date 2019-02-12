//
//  Dazzle_VideoPlayerView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "Dazzle_VideoPlayerView.h"

@interface Dazzle_VideoPlayerView ()
@property (strong,readwrite,nonatomic) AlbumVideoPreView * videoPreview;
@property (strong, nonatomic) UIImageView * imageView;
@end

@implementation Dazzle_VideoPlayerView

#pragma mark - getter methods
-(AlbumVideoPreView *)videoPreview{
    _videoPreview = ({
        if (!_videoPreview) {
            _videoPreview = [[AlbumVideoPreView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, CGRectGetHeight(self.frame))];
        }
        _videoPreview;
    });
    return _videoPreview;
}
-(UIImageView *)imageView{
	_imageView = ({
		if(!_imageView){
			_imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, CGRectGetHeight(self.frame))];
			_imageView.contentMode = UIViewContentModeScaleAspectFill;
			_imageView.layer.masksToBounds = YES;
		}
		_imageView;
	});
	return _imageView;
}

-(void)layoutSubviews{
    [super layoutSubviews];
     self.videoPreview.frame = CGRectMake(0, 0, KScreenWidth, CGRectGetHeight(self.frame));
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)stopVideo{
    if (self.videoPreview) {
        [self.videoPreview onVideoStop];
    }
}

-(void)setAssetModel:(DazzleAssetModel *)assetModel{
    _assetModel = assetModel;
	if (!_assetModel)return;
	if (_assetModel.videoUrlString == nil || _assetModel.videoUrlString.length == 0) {
		[_imageView setHidden:NO];
		_imageView.image = _assetModel.image;
	}else{
		[_imageView setHidden:YES];
		[self.videoPreview replaceCurrentItemWithUrlString:_assetModel.videoUrlString];
	}
}

-(void)setup{
    [self addSubview:self.videoPreview];
	[self addSubview:self.imageView];
}

@end
