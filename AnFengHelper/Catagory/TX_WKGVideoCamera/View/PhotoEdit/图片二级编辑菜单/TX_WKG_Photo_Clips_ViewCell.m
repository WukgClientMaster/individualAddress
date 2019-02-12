//
//  TX_WKG_Photo_Clips_ViewCell.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/24.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Photo_Clips_ViewCell.h"
@interface TX_WKG_Photo_Clips_ViewCell()
@property (strong, nonatomic) UIImageView * imageView;
@end

@implementation TX_WKG_Photo_Clips_ViewCell

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
-(void)setClips_node:(TX_WKG_Clips_Node *)clips_node{
    _clips_node = clips_node;
    if (_clips_node == nil) return;
    if (_clips_node.selected) {
        self.imageView.image  = [UIImage imageNamed:_clips_node.selectedImgString];
    }else{
        self.imageView.image  = [UIImage imageNamed:_clips_node.normalImgString];
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
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(widthEx(55), widthEx(55)));
    }];
}
@end
