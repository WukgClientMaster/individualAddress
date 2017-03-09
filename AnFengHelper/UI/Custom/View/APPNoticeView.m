//
//  APPNoticeView.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/14.
//  Copyright © 2016年 吴可高. All rights reserved.
#import "APPNoticeView.h"
#import "NSString+FilterException.h"

static dispatch_once_t once;
static APPNoticeView * shareAppNoticeView = nil;

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeiht [UIScreen mainScreen].bounds.size.height
@interface APPNoticeView ()

@end
@implementation APPNoticeView

+(instancetype)shareInstance;
{
    @synchronized(self) {
        dispatch_once(&once, ^{
            shareAppNoticeView  =  [[APPNoticeView alloc]initWithFrame:CGRectZero];
        });
    }
    return shareAppNoticeView;
}

-(UIView *)backgroundView
{
    _backgroundView  =({
        if (!_backgroundView) {
            _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/8,kScreenHeiht/4.f, kScreenWidth *3/4, kScreenHeiht/4.f)];
            _backgroundView.backgroundColor  = [[UIColor lightGrayColor]colorWithAlphaComponent:1.f];
        }
        _backgroundView;
    });
    return _backgroundView;
}
-(UIButton *)titleItemButton
{
    _titleItemButton = ({
        if (!_titleItemButton) {
            _titleItemButton  = [UIButton buttonWithType:UIButtonTypeCustom];
            _titleItemButton.frame = CGRectMake(CGRectGetMidX(_backgroundView.frame)/3,20, CGRectGetWidth(_backgroundView.frame) -(CGRectGetMidX(_backgroundView.frame)/3)*2,30);
            [_titleItemButton setTitleColor:UIColorFromRGB(0xFF6B00) forState:UIControlStateNormal];
            [_backgroundView addSubview:_titleItemButton];
        }
            _titleItemButton.enabled = NO;
            _titleItemButton;
    });
    return _titleItemButton;
}
-(UILabel *)lineLabel
{
    _lineLabel = ({
        if (!_lineLabel) {
             _lineLabel  = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleItemButton.frame) + 2, CGRectGetWidth(_backgroundView.frame)- 40.f, 1.f)];
            _lineLabel.backgroundColor  = [UIColor lightTextColor];
        }
        _lineLabel;
    });
    return _lineLabel;
}
-(UILabel *)descTextLabel
{
    _descTextLabel  = ({
        if (!_descTextLabel) {
            _descTextLabel  = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_titleItemButton.frame)+ 4,CGRectGetWidth(_backgroundView.frame) - 40,kScreenHeiht/4.f - CGRectGetMaxY(self.titleItemButton.frame) - 40)];
            _descTextLabel.numberOfLines = 0;
            _descTextLabel.textAlignment = NSTextAlignmentCenter;
            _descTextLabel.font = [UIFont systemFontOfSize:14.f];
            _descTextLabel.textColor =[UIColor lightTextColor];
        }
        [_backgroundView addSubview:_descTextLabel];
        _descTextLabel;
    });
    return _descTextLabel;
}
-(UIButton *)leftBtn
{
    if (!_leftBtn)
    {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        _leftBtn.frame = CGRectMake(20, CGRectGetMaxY(self.descTextLabel.frame),(CGRectGetWidth(_backgroundView.frame)-60)/2.f,30);
        
        _leftBtn.backgroundColor = [UIColor whiteColor] ;
        [_leftBtn setTitle:@"忽略" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:UIColorFromRGB(0xFF6B00) forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14] ;
        [_backgroundView addSubview:_leftBtn];
    }
    return _leftBtn ;
}
-(UIButton *)rightBTn
{
    if (!_rightBTn)
    {
        _rightBTn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        _rightBTn.frame = CGRectMake(CGRectGetMaxX(_leftBtn.frame) +20 , CGRectGetMaxY(self.descTextLabel.frame),(CGRectGetWidth(_backgroundView.frame)-60)/2.f,30) ;
        _rightBTn.backgroundColor = [UIColor whiteColor] ;
        [_rightBTn setTitle:@"重试" forState:UIControlStateNormal];
        [_rightBTn setTitleColor:UIColorFromRGB(0xFF6B00) forState:UIControlStateNormal];
        _rightBTn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_backgroundView addSubview:_rightBTn];
    }
    return _rightBTn ;
}
#pragma mark Initialize View Style
-(instancetype)initWithTitle:(NSString *)title appNoticeType:(APPNoticeType)type andDesText:(NSString *)text
{
    if ( self = [super init])
    {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeiht) ;
        self.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2] ;
        [self addSubview:self.backgroundView];
        self.backgroundView.layer.cornerRadius = 5.0f ;
        self.backgroundView.layer.masksToBounds = YES ;
        NSString * imageName = type == kAPPNoticeAsynRequestType ? @"WJStatusBarHUD_error.png":@"WJStatusBarHUD_warning.png";
        UIImage * titleImg = [UIImage imageNamed:imageName];
        [self.titleItemButton setImage:titleImg forState:UIControlStateNormal];
        NSString * titleName = type ==kAPPNoticeAsynRequestType ? @"请求异常":@"警告";
        if (!title||title.length ==0)title =@"";
        NSString * itemString =  title.matchingIsEmpty ?  titleName:title;
        [self.titleItemButton setTitle:itemString forState:UIControlStateNormal];
        
        [self.backgroundView addSubview:self.lineLabel];
        self.descTextLabel.text  = text;
        [self.leftBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBTn addTarget:self action:@selector(sureBtn) forControlEvents:UIControlEventTouchUpInside]; ;
        self.backgroundView.center = CGPointMake(kScreenWidth /2, 0) ;
        [UIView animateWithDuration:1.f delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.1f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.backgroundView.center = CGPointMake(kScreenWidth/2.0,kScreenHeiht/2.f);
        } completion:^(BOOL finished) {
        }];
        UITapGestureRecognizer *tapOne =  [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView:)];
        [self addGestureRecognizer:tapOne];
    }
    return self;
}
-(void)appNoticeShow
{
    UIView *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview: self];
}
-(void)appNoticeRemove
{
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.backgroundView.center = CGPointMake(kScreenWidth/2.0,kScreenHeiht+ CGRectGetHeight(_backgroundView.frame));
        self.backgroundColor = [UIColor clearColor] ;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark IBOutlet Action View
-(void)cancelClick
{
    [self appNoticeRemove];
}
-(void)sureBtn
{
    [self appNoticeRemove];
}

-(void)removeView:(UITapGestureRecognizer *)tap
{
    [self appNoticeRemove];
}
@end
