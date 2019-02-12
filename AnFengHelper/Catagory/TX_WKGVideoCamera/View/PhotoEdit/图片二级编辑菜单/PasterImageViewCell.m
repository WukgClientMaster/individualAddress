//
//  PasterImageViewCell.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "PasterImageViewCell.h"

@interface PasterImageViewCell()
@property (strong, nonatomic) UIView * negativeView;
@property (strong, nonatomic) UIImageView * imageView;

@end
@implementation PasterImageViewCell

#pragma mark - getter methods
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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    [self addSubview:self.negativeView];
    __weak  typeof(self)weakSelf = self;
    self.negativeView.layer.borderWidth  = widthEx(2.f);
    self.negativeView.layer.cornerRadius = widthEx(2.f);
    self.negativeView.layer.borderColor = UIColorFromRGB(0xfe4e5b).CGColor;
    [self.negativeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMakeEx(65+11, 65+11));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.top.mas_equalTo(weakSelf.mas_top).with.offset(heightEx(16.f));
    }];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.imageView.image = [UIImage imageNamed:@"qmx_bianji_sjtx"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.negativeView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMakeEx(65+9,65+9));
        make.centerX.mas_equalTo(weakSelf.negativeView.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.negativeView.mas_centerY);
    }];
}

-(void)setPasterNode:(TX_WKG_Paster_Node *)pasterNode{
    _pasterNode = pasterNode;
    self.imageView.image = [UIImage imageNamed:_pasterNode.imageString];
    if (_pasterNode.selected) {
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
