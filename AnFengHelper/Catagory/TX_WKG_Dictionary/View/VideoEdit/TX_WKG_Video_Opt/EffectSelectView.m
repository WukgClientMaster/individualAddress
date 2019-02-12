//
//  VideoEffectSlider.m
//  TXLiteAVDemo
//
//  Created by xiang zhang on 2017/11/3.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "EffectSelectView.h"
#import "UIView+Additions.h"
#import "ColorMacro.h"

#define EFFCT_COUNT        4
#define EFFCT_IMAGE_WIDTH  55

@interface EffectSelectView()
@property (strong, nonatomic) NSMutableArray * containers;
@property (strong, nonatomic) NSMutableArray * labelContainers;
@property (strong, nonatomic) CAShapeLayer * shapeLayer;

@end
NSString * kScaleShapeLayerKey = @"kScaleShapeLayerKey";
@implementation EffectSelectView
{
    UIScrollView *_effectSelectView;
}

#pragma mark - getter methods
-(NSMutableArray *)labelContainers{
    _labelContainers = ({
        if (!_labelContainers) {
            _labelContainers = [NSMutableArray array];
        }
        _labelContainers;
    });
    return _labelContainers;
}
-(NSMutableArray *)containers{
    _containers = ({
        if (!_containers) {
            _containers = [NSMutableArray array];
        }
        _containers;
    });
    return _containers;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat space = (self.width - EFFCT_IMAGE_WIDTH * EFFCT_COUNT) / (EFFCT_COUNT + 1);
        _effectSelectView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.width,EFFCT_IMAGE_WIDTH)];
        _effectSelectView.backgroundColor = [UIColor clearColor];
        NSArray *effectNameS = @[@"灵魂出窍",@"画中画",@"抖动",@"黑白"];
        for (int i = 0 ; i < EFFCT_COUNT ; i ++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(space + (space + EFFCT_IMAGE_WIDTH) * i,heightEx(8.f), EFFCT_IMAGE_WIDTH, EFFCT_IMAGE_WIDTH)];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setBackgroundColor:[UIColor blueColor]];
            btn.layer.cornerRadius = EFFCT_IMAGE_WIDTH / 2.0;
            btn.layer.masksToBounds = YES;
            btn.titleLabel.numberOfLines = 0;
            btn.tag = i;
            
            [btn addTarget:self action:@selector(beginPress:) forControlEvents:UIControlEventTouchDown];
            [btn addTarget:self action:@selector(endPress:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
            [_effectSelectView addSubview:btn];
            [self.containers addObject:btn];
            
            UILabel * label = [UILabel new];
            label.text  = effectNameS[i];
            label.textColor = UIColorFromRGB(0xcdcdcd);
            label.font = [UIFont systemFontOfSize:12.f];
            label.textAlignment = NSTextAlignmentCenter;
            label.center = CGPointMake( btn.centerX,btn.bottom + heightEx(10.f));
            [_effectSelectView addSubview:label];
            [self.labelContainers addObject:label];
            switch ((TXEffectType)btn.tag) {
                case 2:
                {
                    [btn setBackgroundImage:[UIImage imageNamed:@"qmx_bianji_dd"] forState:UIControlStateNormal];
                }
                    break;
                case 3:
                {
                     [btn setBackgroundImage:[UIImage imageNamed:@"qmx_bianji_hmf"] forState:UIControlStateNormal];
                    
                }
                    break;
                case 0:
                {
                    [btn setBackgroundImage:[UIImage imageNamed:@"qmx_bianji_lhcq"] forState:UIControlStateNormal];
                }
                    break;
                case 1:
                {
                     [btn setBackgroundImage:[UIImage imageNamed:@"qmx_bianji_hzh"] forState:UIControlStateNormal];
                }
                    break;
                    
                default:
                    break;
            }
        }
        [self addSubview:_effectSelectView];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat space = (self.width - EFFCT_IMAGE_WIDTH * EFFCT_COUNT) / (EFFCT_COUNT + 1);
    _effectSelectView.frame = CGRectMake(0,0, self.width,CGRectGetHeight(self.frame));
    CGFloat padding =  (CGRectGetHeight(self.frame) - (EFFCT_IMAGE_WIDTH +heightEx(20.f)))/2.f;
    for (int i = 0 ; i < self.containers.count; i++) {
        UIButton * btn = (UIButton*)self.containers[i];
        btn.frame = CGRectMake(space + (space + EFFCT_IMAGE_WIDTH) * i,padding, EFFCT_IMAGE_WIDTH, EFFCT_IMAGE_WIDTH);
    }
    [self.labelContainers enumerateObjectsUsingBlock:^(UILabel *  _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.frame = CGRectMake(space + (space + EFFCT_IMAGE_WIDTH) * idx, EFFCT_IMAGE_WIDTH + padding + heightEx(4.f), EFFCT_IMAGE_WIDTH, heightEx(20.f));
    }];
}

//响应事件
-(void) beginPress: (UIButton *) button {
    TXEffectType type = (TXEffectType)button.tag;
    if (button.tag == 1) {
        type =  TXEffectType_DARK_DRAEM;
    }
    if (button.tag == 3) {
        type =  TXEffectType_SCREEN_SPLIT;
    }
    [self.delegate onVideoEffectBeginClick:type];
    button.transform = CGAffineTransformScale(button.transform, 1.2, 1.2);
    NSArray * colors = @[UIColorFromRGB(0x1FBCB6),UIColorFromRGB(0xEC8435),UIColorFromRGB(0xEC5F9B),UIColorFromRGB(0x449FF3)];
    [button setBackgroundColor:[colors[button.tag]colorWithAlphaComponent:0.7]];
    if (self.shapeLayer == nil) {
        self.shapeLayer = [CAShapeLayer layer];
    }
    self.shapeLayer.backgroundColor = [colors[button.tag] colorWithAlphaComponent:0.7].CGColor;
    self.shapeLayer.bounds   = CGRectMake(0, 0, CGRectGetWidth(button.frame)*1.2, CGRectGetHeight(button.frame) * 1.2);
    self.shapeLayer.position = CGPointMake(CGRectGetWidth(button.frame) * 1.2 /2.f, CGRectGetHeight(button.frame)*1.2 /2.f);
    [button.layer addSublayer:self.shapeLayer];
}

//响应事件
-(void) endPress: (UIButton *) button {
    TXEffectType type = (TXEffectType)button.tag;
    [self.delegate onVideoEffectEndClick:type];
     button.transform = CGAffineTransformIdentity;
    if (_shapeLayer) {
        [_shapeLayer removeAllAnimations];
        [_shapeLayer removeFromSuperlayer];
        _shapeLayer = nil;
    }
}

@end

