//
//  TX_WKG_PhotoCollectionViewCell.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/15.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_PhotoCollectionViewCell.h"

@interface TX_WKG_PhotoCollectionViewCell()
@property (strong,readwrite,nonatomic) UILabel *label;
@property (strong,readwrite,nonatomic) UIImageView * imageView;
@end
@implementation TX_WKG_PhotoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.textColor = UIColorFromRGB(0x666666);
    self.label.font = [UIFont systemFontOfSize:13.f];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.imageView.image = [UIImage imageNamed:@"qmx_bianji_sjtx"];
    self.imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.imageView];
    __weak typeof(self)weakSelf = self;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMakeEx(35,35));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(-widthEx(10));
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.imageView.mas_centerX);
        make.top.mas_equalTo(weakSelf.imageView.mas_bottom);
    }];
}

-(void)setPhotoOptionalModel:(TX_WKG_PhotoOptionalModel *)photoOptionalModel{
    _photoOptionalModel = photoOptionalModel;
    self.imageView.image = [UIImage imageNamed:_photoOptionalModel.imageString];
    self.label.text = _photoOptionalModel.title;
}

@end
