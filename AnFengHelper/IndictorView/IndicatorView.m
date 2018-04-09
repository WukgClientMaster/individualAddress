//
//  IndicatorView.m
//  smarket
//
//  Created by client on 2017/7/20.
//  Copyright © 2017年 原研三品. All rights reserved.
//

#import "IndicatorView.h"
#import "IndicatorAnimationProtocol.h"
#import "CycleAnimation.h"

@interface IndicatorView ()
@property(nonatomic,retain)id <IndicatorAnimationProtocol> animation;
@property(nonatomic,assign) BOOL isAnimating;

@end
@implementation IndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
        [self setup];
    }
    return self;
}

-(void)setup
{
    __weak  typeof(self)weakSelf = self;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.05f];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = APPAdapterScaleWith(8.f);
    __block CGFloat size = 40.f;
    __block CGFloat left_margin = 20.f;
    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(size, size));
        make.centerX.mas_equalTo(weakSelf.mas_centerX).with.offset(0.f);
        make.top.mas_equalTo(APPAdapterAdjustHeight(25.f));
    }];
    [self addSubview:self.indicatorLabel];
    [self.indicatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(left_margin);
        make.top.mas_equalTo(weakSelf.imgView.mas_bottom).with.offset(APPAdapterAdjustHeight(5.f));
    }];
    [self addSubview:self.indicator];
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.indicatorLabel.mas_right).with.offset(APPAdapterScaleWith(2.f));
        make.centerY.mas_equalTo(weakSelf.indicatorLabel.mas_centerY).with.offset(0.f);
        make.size.mas_equalTo(CGSizeMake(APPAdapterScaleWith(40), APPAdapterScaleWith(20.f)));
    }];
}

-(UIImageView *)imgView
{
    _imgView = ({
        if (!_imgView) {
            _imgView  = [[UIImageView alloc]initWithFrame:CGRectZero];
            _imgView.contentMode = UIViewContentModeScaleAspectFill;
            _imgView.image = [UIImage imageNamed:@"logo_mine"];
        }
        _imgView;
    });
    return _imgView;
}

-(UILabel *)indicatorLabel
{
    _indicatorLabel = ({
        if (!_indicatorLabel) {
            _indicatorLabel  = [[UILabel alloc]initWithFrame:CGRectZero];
            _indicatorLabel.text = @"loading";
        }
        _indicatorLabel;
    });
    return _indicatorLabel;
}


-(UIView *)indicator
{
    _indicator = ({
        if (!_indicator) {
            _indicator  = [[UIView alloc]initWithFrame:CGRectZero];
        }
        _indicator;
    });
    return _indicator;
}

#pragma mark - Animation
-(void)startAnimating
{
    self.indicator.layer.sublayers = nil;
    self.animation =[[CycleAnimation alloc]init];
    if ([self.animation respondsToSelector:@selector(configAnimationAtLayer:withTintColor:size:)]) {
        [self.animation configAnimationAtLayer:self.indicator.layer withTintColor:[UIColor grayColor] size:CGSizeMake(APPAdapterScaleWith(40), APPAdapterScaleWith(20))];
    }
    self.isAnimating = YES;
}

- (void)stopAnimating{
    if (self.isAnimating == YES) {
        if ([self.animation respondsToSelector:@selector(removeAnimation)]) {
            [self.animation removeAnimation];
            self.isAnimating = NO;
            self.animation = nil;
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

#pragma mark - Did enter background

- (void)appWillEnterBackground{
    if (self.isAnimating == YES) {
        [self.animation removeAnimation];
    }
}

- (void)appWillBecomeActive{
    if (self.isAnimating == YES) {
        [self startAnimating];
    }
}

@end
