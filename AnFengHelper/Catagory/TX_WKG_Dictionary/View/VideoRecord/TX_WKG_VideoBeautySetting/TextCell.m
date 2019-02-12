//
//  TextCell.m
//  BeautyDemo
//
//  Created by kennethmiao on 17/5/9.
//  Copyright © 2017年 kennethmiao. All rights reserved.
//

#import "TextCell.h"
#import "ColorMacro.h"

@interface TextCell()
@property (strong, nonatomic) UIView * lineView;
@end


@implementation TextCell
#pragma mark - getter methods
-(UIView *)lineView{
    _lineView = ({
        if (!_lineView) {
            _lineView = [[UIView alloc]initWithFrame:CGRectZero];
            _lineView.backgroundColor = [UIColor clearColor];
        }
        _lineView;
    });
    return _lineView;
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

- (void)setSelected:(BOOL)selected
{
    if(selected){
        self.label.textColor = UIColorFromRGB(0x0ae7ce);
        self.lineView.backgroundColor = UIColorFromRGB(0x0ae7ce);
    }
    else{
        self.label.textColor = [UIColor whiteColor];
        self.lineView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setupView{
    self.label = [UILabel new];
    self.label.font = [UIFont systemFontOfSize:16.f];
    self.label.textColor = [UIColor whiteColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    [self addSubview:self.lineView];
    __weak  typeof(self)weakSelf = self;
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(-heightEx(4.f));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.height.mas_equalTo(@(heightEx(2.f)));
        make.width.mas_equalTo(@(widthEx(50.f)));
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(-heightEx(4.f));
    }];
}

@end
