//
//  TX_WKG_VideoRecord_Item.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/3/27.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_VideoRecord_Item.h"

@interface  TX_WKG_VideoRecord_Item()
@property (strong,readwrite,nonatomic)UILabel * label;
@end
@implementation TX_WKG_VideoRecord_Item
#pragma mark - getter methods
-(UILabel *)label{
    _label = ({
        if (!_label) {
            _label = [[UILabel alloc]initWithFrame:CGRectZero];
            _label.font = [UIFont systemFontOfSize:13.f];
            _label.textAlignment = NSTextAlignmentCenter;
        }
        _label;
    });
    return _label;
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
    [super setup];
    [self addSubview:self.label];
    __weak  typeof(self)weakSelf = self;
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(weakSelf.imageView.mas_bottom).with.offset(0.f);
    make.centerX.mas_equalTo(weakSelf.mas_centerX).with.offset(0.f);
    }];
}

#pragma mark - configData
-(void)configParams:(NSString *)title imgString:(NSString *)imgString{
    NSAssert(title ,@"title is not nil");
    NSAssert(imgString,@"imgString is not nil");
    [super configParamImgString:imgString];
    self.label.text = title;
}

@end
