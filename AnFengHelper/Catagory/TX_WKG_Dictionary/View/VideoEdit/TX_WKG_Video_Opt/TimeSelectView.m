//
//  TimeSelectView.m
//  TXLiteAVDemo_Enterprise
//
//  Created by xiang zhang on 2017/10/27.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "TimeSelectView.h"
#import "UIView+Additions.h"
#import "ColorMacro.h"

#define EFFCT_COUNT        4
#define EFFCT_IMAGE_WIDTH  55
#define EFFCT_IMAGE_SPACE  20

@interface TimeSelectView()
@property (strong, nonatomic) NSMutableArray * containers;
@property (strong, nonatomic) NSMutableArray * labelContainers;
@property (strong, nonatomic) UIImageView * selectedImageView;
@property (strong, nonatomic) UIScrollView * effectSelectView;
;

@end


@implementation TimeSelectView
{
}

#pragma mark - getter methods
-(UIImageView *)selectedImageView{
    _selectedImageView = ({
        if (!_selectedImageView) {
            UIImage * img = [UIImage imageNamed:@"qmx_bianji_xuanzhongzz"];
            _selectedImageView = [[UIImageView alloc]initWithImage:img];
        }
        _selectedImageView;
    });
    return _selectedImageView;
}

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

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat space = (self.width - EFFCT_IMAGE_WIDTH * EFFCT_COUNT) / (EFFCT_COUNT + 1);
        _effectSelectView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.width,EFFCT_IMAGE_WIDTH + heightEx(30))];
        _effectSelectView.backgroundColor = [UIColor clearColor];
        NSArray *effectNameS = @[@"无",@"慢动作",@"重复",@"倒放",];
        for (int i = 0 ; i < EFFCT_COUNT ; i ++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(space + (space + EFFCT_IMAGE_WIDTH) * i, 0, EFFCT_IMAGE_WIDTH, EFFCT_IMAGE_WIDTH)];
            [btn setBackgroundImage:[UIImage imageNamed:@"qmx_bianji_sjtx"] forState:UIControlStateNormal];
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            btn.layer.cornerRadius  = EFFCT_IMAGE_WIDTH / 2.0;
            btn.layer.masksToBounds = YES;
            btn.titleLabel.numberOfLines = 0;
            btn.tag = i;
            [self.containers addObject:btn];
            [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_effectSelectView addSubview:btn];
            if (i== 0) {
                self.selectedImageView.frame = CGRectMake(space, 0, EFFCT_IMAGE_WIDTH, EFFCT_IMAGE_WIDTH);
                [_effectSelectView addSubview:self.selectedImageView];
                [_effectSelectView bringSubviewToFront:self.selectedImageView];
            }
            UILabel * label = [UILabel new];
            label.text  = effectNameS[i];
            label.textColor = UIColorFromRGB(0xcdcdcd);
            label.font = [UIFont systemFontOfSize:12.f];
            label.textAlignment = NSTextAlignmentCenter;
            label.center = CGPointMake( btn.centerX,btn.bottom + heightEx(10.f));
            [_effectSelectView addSubview:label];
            [self.labelContainers addObject:label];
        }
        [self addSubview:_effectSelectView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat space = (self.width - EFFCT_IMAGE_WIDTH * EFFCT_COUNT) / (EFFCT_COUNT + 1);
    _effectSelectView.frame = CGRectMake(0, 0, self.width,CGRectGetHeight(self.frame));
    CGFloat padding =  (CGRectGetHeight(self.frame) - (EFFCT_IMAGE_WIDTH +heightEx(20.f)))/2.f;
    for (int i = 0; i < self.containers.count; i++) {
        UIButton * btn =  (UIButton*)self.containers[i];
        [btn setFrame:CGRectMake(space + (space + EFFCT_IMAGE_WIDTH) * i,padding, EFFCT_IMAGE_WIDTH, EFFCT_IMAGE_WIDTH)];
        if (i == 0) {
            self.selectedImageView.frame = CGRectMake(space,padding, EFFCT_IMAGE_WIDTH, EFFCT_IMAGE_WIDTH);
        }
    }
    [self.labelContainers enumerateObjectsUsingBlock:^(UILabel *  _Nonnull label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.frame = CGRectMake(space + (space + EFFCT_IMAGE_WIDTH) * idx, EFFCT_IMAGE_WIDTH + padding +heightEx(4.f), EFFCT_IMAGE_WIDTH, heightEx(20.f));
    }];
}

- (void)onBtnClick:(UIButton *)btn{
    if (btn.tag == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(onVideoTimeEffectsSpeed)]) {
            [_delegate onVideoTimeEffectsClear];
        }
    }
    else if (btn.tag == 3) {
        if (_delegate && [_delegate respondsToSelector:@selector(onVideoTimeEffectsSpeed)]) {
            [_delegate onVideoTimeEffectsBackPlay];
        }
    }
    else if (btn.tag == 2){
        if (_delegate && [_delegate respondsToSelector:@selector(onVideoTimeEffectsBackPlay)]) {
            [_delegate onVideoTimeEffectsRepeat];
        }
    }
    else if (btn.tag == 1){
        if (_delegate && [_delegate respondsToSelector:@selector(onVideoTimeEffectsRepeat)]) {
            [_delegate onVideoTimeEffectsSpeed];
        }
    }
    [self resetBtnColor:btn];
}

- (void)resetBtnColor:(UIButton *)args{
    NSInteger idx = [self.containers indexOfObject:args];
    CGFloat space = (self.width - EFFCT_IMAGE_WIDTH * EFFCT_COUNT) / (EFFCT_COUNT + 1);
    CGFloat padding =  (CGRectGetHeight(self.frame) - (EFFCT_IMAGE_WIDTH +heightEx(20.f)))/2.f;
    self.selectedImageView.frame = CGRectMake(space + (space + EFFCT_IMAGE_WIDTH) * idx,padding, EFFCT_IMAGE_WIDTH, EFFCT_IMAGE_WIDTH);
    [_effectSelectView bringSubviewToFront:self.selectedImageView];
}
@end
