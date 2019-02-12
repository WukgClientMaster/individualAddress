//
//  WKG_VideoCollectionCell.m
//  SmartCity
//
//  Created by 吴可高 on 2018/1/25.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "WKG_VideoCollectionCell.h"

@interface WKG_VideoCollectionCell()
@property(nonatomic,strong) UIImageView * imgView;
@end
@implementation WKG_VideoCollectionCell

#pragma mark -getter methods
-(UIImageView *)imgView{
    _imgView = ({
        if (!_imgView) {
            _imgView  = [[UIImageView alloc]initWithFrame:CGRectZero];
            _imgView.layer.masksToBounds = YES;
            _imgView.clipsToBounds = YES;
        }
        _imgView;
    });
    return _imgView;
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
    __weak  typeof(self)weakSelf  = self;
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsZero);
    }];
}

-(void)setCoverImage:(UIImage *)coverImage{
    _coverImage = coverImage;
    self.imgView.image = _coverImage;
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
}

@end


