//
//  TextImageCell.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/24.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TextImageCell.h"

@interface TextImageCell()
@property (strong, nonatomic) UIView * negativeView;
@end

@implementation TextImageCell
#pragma mark -  getter methods
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
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupView];
    }
    return self;
}

+ (NSString *)reuseIdentifier{
    return NSStringFromClass([self class]);
}

- (void)setSelected:(BOOL)selected{
    if(selected){
        self.label.textColor = UIColorFromRGB(0x0ae7ce);
        self.negativeView.layer.borderColor = [UIColorFromRGB(0x0ae7ce) CGColor];
        self.negativeView.layer.borderWidth = widthEx(3.f);
    }
    else{
        self.label.textColor = UIColorFromRGB(0xcccccc);
        self.negativeView.backgroundColor = [UIColor clearColor];
        self.negativeView.layer.borderWidth = widthEx(3.f);
        self.negativeView.layer.borderColor = [[UIColor clearColor]CGColor];
    }
}

- (void)setupView{
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont systemFontOfSize:14.f];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    [self addSubview:self.negativeView];
    __weak  typeof(self)weakSelf = self;
    self.negativeView.layer.cornerRadius = widthEx(65+11)/2.f;
    [self.negativeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65+11, 65+11));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.top.mas_equalTo(weakSelf.mas_top).with.offset(widthEx(20.f));
    }];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.imageView.image = [UIImage imageNamed:@"qmx_bianji_sjtx"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.negativeView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65,65));
        make.centerX.mas_equalTo(weakSelf.negativeView.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.negativeView.mas_centerY);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.mas_equalTo(weakSelf.imageView.mas_centerX);
      make.top.mas_equalTo(weakSelf.imageView.mas_bottom).with.offset(widthEx(8.f));
    }];
}

@end
