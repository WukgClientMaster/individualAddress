//
//  IndicatorViewManager.m
//  smarket
//
//  Created by client on 2017/7/20.
//  Copyright © 2017年 原研三品. All rights reserved.
//

#import "IndicatorViewManager.h"
#import "IndicatorView.h"
#import "CycleAnimation.h"

static IndicatorViewManager * _indicatorViewManager = nil;
static NSInteger kanimationInterval = 2.f;
@interface IndicatorViewManager()
@property(nonatomic,strong) IndicatorView * indicatorView;

@end

@implementation IndicatorViewManager

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_indicatorViewManager) {
            _indicatorViewManager = [[IndicatorViewManager alloc]init];
        }
    });
    return _indicatorViewManager;
}

-(IndicatorView *)indicatorView
{
    _indicatorView = ({
        if (!_indicatorView) {
            _indicatorView  = [[IndicatorView alloc]initWithFrame:CGRectZero];
        }
        _indicatorView;
    });
    return _indicatorView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.indicatorImages = @[];
        self.frame =  [UIScreen mainScreen].bounds;
        self.backgroudColor = [[UIColor blackColor]colorWithAlphaComponent:0.2f];
        self.autoAnimationInterval = kanimationInterval;
    }
    return self;
}

-(void)setIndicatorImages:(NSArray *)indicatorImages
{
    _indicatorImages = indicatorImages;
    NSAssert(_indicatorImages, @"_indicatorImages is not nil");
}

-(void)diagnosticPush:(NSString *)type
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.indicatorView];
    [UIApplication sharedApplication].keyWindow.backgroundColor = self.backgroudColor;
    [[UIApplication sharedApplication]beginIgnoringInteractionEvents];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(APPAdapterScaleWith(100.f), APPAdapterScaleWith(100.f)));
        make.centerX.mas_equalTo([UIApplication sharedApplication].keyWindow.mas_centerX);
        make.centerY.mas_equalTo([UIApplication sharedApplication].keyWindow.mas_centerY);
    }];
    [self.indicatorView startAnimating];
}

-(void)diagnosticPop:(NSString *)type
{
    if ([[[UIApplication sharedApplication].keyWindow subviews] containsObject:self.indicatorView]) {
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        [self.indicatorView removeFromSuperview];
        [[UIApplication sharedApplication]endIgnoringInteractionEvents];
        [self.indicatorView stopAnimating];
    }
}

@end
