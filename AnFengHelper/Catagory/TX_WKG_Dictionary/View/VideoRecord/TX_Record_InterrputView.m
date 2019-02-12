//
//  TX_Record_InterrputView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/10.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_Record_InterrputView.h"

@interface TX_Record_InterrputView()
@property (strong, nonatomic) UIButton * nextStepButton;
@property (strong, nonatomic) UIButton * dismissBuuton;
@end

@implementation TX_Record_InterrputView
#pragma mark -IBOutlet Enevts
-(void)dismissEvents:(UIButton*)args{
    if (self.callback) {
        self.callback(@"返回");
    }
}

-(void)nextStepEvents:(UIButton*)args{
    if (self.callback) {
        self.callback(@"下一步");
    }
}

-(void)setSubViewHidddenWithTitle:(NSString *)title hidden:(BOOL)hidden{
    NSAssert(title, @"title is not nil");
    if ([title isEqualToString:@"下一步"]) {
        [self.nextStepButton setHidden:hidden];
    }
    if ([title isEqualToString:@"返回"]) {
        [self.dismissBuuton setHidden:hidden];
    }
}

#pragma mark - getter methods
-(UILabel *)tips_label{
    _tips_label = ({
        if (!_tips_label) {
            _tips_label = [UILabel new];
            _tips_label.textColor = [UIColor whiteColor];
            _tips_label.font = [UIFont systemFontOfSize:14.f];
            _tips_label.text = @"0.00";
        }
        _tips_label;
    });
    return _tips_label;
}

-(UIButton *)dismissBuuton{
    _dismissBuuton = ({
        if (!_dismissBuuton) {
            _dismissBuuton = [UIButton buttonWithType:UIButtonTypeCustom];
             UIImage * img = [UIImage imageNamed:@"qmx_paishe_guanbi"];
            [_dismissBuuton setImage:img forState:UIControlStateNormal];
            [_dismissBuuton addTarget:self action:@selector(dismissEvents:) forControlEvents:UIControlEventTouchUpInside];
        }
        _dismissBuuton;
    });
    return _dismissBuuton;
}

-(UIButton *)nextStepButton{
    _nextStepButton = ({
        if (!_nextStepButton) {
            _nextStepButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
            [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _nextStepButton.backgroundColor = UIColorFromRGB(0x07eecb);
            _nextStepButton.layer.cornerRadius = widthEx(5.f);
            _nextStepButton.layer.masksToBounds = YES;
            [_nextStepButton addTarget:self action:@selector(nextStepEvents:) forControlEvents:UIControlEventTouchUpInside];
        }
        _nextStepButton;
    });
    return  _nextStepButton;
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
    __weak  typeof(self)weakSelf = self;
    [self addSubview:self.dismissBuuton];
    [self addSubview:self.nextStepButton];
    [self.tips_label setHidden:YES];
    [self addSubview:self.tips_label];
    __block CGFloat padding = widthEx(12.f);
    [self.tips_label mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(weakSelf.mas_centerX).with.offset(0.f);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
    [self.dismissBuuton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMakeEx(30,30));
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
    }];
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMakeEx(72, 32));
        make.centerY.mas_equalTo(weakSelf.mas_centerY).with.offset(0.f);
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(0);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
