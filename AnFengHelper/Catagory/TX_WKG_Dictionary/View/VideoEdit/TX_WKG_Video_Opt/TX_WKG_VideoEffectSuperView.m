//
//  TX_WKG_VideoEffectSuperView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/19.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_VideoEffectSuperView.h"
#import "TX_WKG_Video_RevokeItemView.h"


@interface TX_WKG_VideoEffectSuperView ()<VideoEffectViewDelegate,TimeSelectViewDelegate>
@property (strong, nonatomic) EffectSelectView * effectSelectView;
@property (strong, nonatomic) TimeSelectView * timeSelectView;
@property (strong, nonatomic) UILabel * title_label;
@property (strong, nonatomic) UIView * indicatorView;
@property (strong, nonatomic) UIView * bottom_View;
@property (strong, nonatomic) NSMutableArray * containers;
@property (strong, nonatomic) UIButton * selectedButton;
@property (strong, nonatomic) TX_WKG_Video_RevokeItemView *revokeItem;

@end

@implementation TX_WKG_VideoEffectSuperView
#pragma mark VideoEffectViewDelegate
- (void)onVideoEffectBeginClick:(TXEffectType)effectType{
    if (self.effectDelegate && [self.effectDelegate respondsToSelector:@selector(onVideoEffectBeginClick:)]){
        [self.effectDelegate onVideoEffectBeginClick:effectType];
    }
}

- (void)onVideoEffectEndClick:(TXEffectType)effectType{
    if (self.effectDelegate && [self.effectDelegate respondsToSelector:@selector(onVideoEffectEndClick:)]){
        [self.effectDelegate onVideoEffectEndClick:effectType];
    }
}

#pragma mark TimeSelectViewDelegate
- (void)onVideoTimeEffectsClear{
    if (self.timeDelegate && [self.timeDelegate respondsToSelector:@selector(onVideoTimeEffectsClear)]) {
        [self.timeDelegate onVideoTimeEffectsClear];
    }
}

- (void)onVideoTimeEffectsSpeed{
    if (self.timeDelegate && [self.timeDelegate respondsToSelector:@selector(onVideoTimeEffectsSpeed)]) {
        [self.timeDelegate onVideoTimeEffectsSpeed];
    }
}
- (void)onVideoTimeEffectsBackPlay{
    if (self.timeDelegate && [self.timeDelegate respondsToSelector:@selector(onVideoTimeEffectsBackPlay)]) {
        [self.timeDelegate onVideoTimeEffectsBackPlay];
    }
}

- (void)onVideoTimeEffectsRepeat{
    if (self.timeDelegate && [self.timeDelegate respondsToSelector:@selector(onVideoTimeEffectsRepeat)]) {
        [self.timeDelegate onVideoTimeEffectsRepeat];
    }
}

#pragma mark - IBOutlet Events
-(void)itemEvents:(UIButton*)args{
    if ([args isEqual:self.selectedButton])return;
    __weak  typeof(self)weakSelf = self;
    [self.selectedButton setSelected:NO];
    [args setSelected:YES];
    self.selectedButton = args;
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(args.mas_centerX).with.offset(0.f);
        make.width.mas_equalTo(widthEx(50.f));
        make.height.mas_equalTo(@(heightEx(3.f)));
     make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(widthEx(-1.f));
    }];
    [self loadEffectViewWith:args];
}

-(void)loadEffectViewWith:(UIButton*)args{
    __weak  typeof(self)weakSelf = self;
    if ([args.currentTitle isEqualToString:@"时间特效"]) {
        self.title_label.text = @"点击使用效果";
        [self.revokeItem setHidden:YES];
        if ([[self subviews]containsObject:self.effectSelectView]) {
            [self.effectSelectView removeFromSuperview];
            [self.effectSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
            }];
        }
        if ([[self subviews]containsObject:self.timeSelectView]) {
            [self.timeSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(weakSelf);
                make.top.mas_equalTo(weakSelf.title_label.mas_bottom).with.offset(0.f);
                make.bottom.mas_equalTo(weakSelf.bottom_View.mas_top).with.offset(0.f);
            }];
        }else if (![[self subviews]containsObject:self.timeSelectView]){
            self.timeSelectView.backgroundColor = [UIColor clearColor];
            [self addSubview:self.timeSelectView];
            [self.timeSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(weakSelf);
                make.top.mas_equalTo(weakSelf.title_label.mas_bottom).with.offset(0.f);
                make.bottom.mas_equalTo(weakSelf.bottom_View.mas_top).with.offset(0.f);
            }];
        }
    }else if([args.currentTitle isEqualToString:@"滤镜特效"]){
        self.title_label.text = @"长按使用效果";
        [self.revokeItem setHidden:NO];
        if ([[self subviews]containsObject:self.timeSelectView]) {
            [self.timeSelectView removeFromSuperview];
            [self.timeSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
            }];
        }
        if ([[self subviews]containsObject:self.effectSelectView]) {
            [self.effectSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(weakSelf);
            make.top.mas_equalTo(weakSelf.revokeItem.mas_bottom).with.offset(0.f);
            make.bottom.mas_equalTo(weakSelf.bottom_View.mas_top).with.offset(0.f);
            }];
        }else if (![[self subviews]containsObject:self.effectSelectView]){
            self.effectSelectView.backgroundColor = [UIColor clearColor];
            [self addSubview:self.effectSelectView];
            [self.effectSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(weakSelf);
                make.top.mas_equalTo(weakSelf.revokeItem.mas_bottom).with.offset(0.f);
                make.bottom.mas_equalTo(weakSelf.bottom_View.mas_top).with.offset(0.f);
            }];
        }
    }
}

#pragma mark - getter methods
-(TimeSelectView *)timeSelectView{
    _timeSelectView = ({
        if (!_timeSelectView) {
            _timeSelectView = [[TimeSelectView alloc]initWithFrame:CGRectZero];
            _timeSelectView.delegate = self;
        }
        _timeSelectView;
    });
    return _timeSelectView;
}

-(EffectSelectView *)effectSelectView{
    _effectSelectView = ({
        if (!_effectSelectView) {
            _effectSelectView = [[EffectSelectView alloc]initWithFrame:CGRectZero];
            _effectSelectView.delegate = self;
            
        }
        _effectSelectView;
    });
    return _effectSelectView;
}

-(TX_WKG_Video_RevokeItemView *)revokeItem{
    _revokeItem = ({
        if (!_revokeItem) {
            _revokeItem = [[TX_WKG_Video_RevokeItemView alloc]initWithFrame:CGRectZero];
            __weak  typeof(self)weakSelf = self;
            _revokeItem.callback = ^(UIControl *controll) {
                if (weakSelf.callback) {
                    weakSelf.callback(@"撤销");
                }
            };
        }
        _revokeItem;
    });
    return _revokeItem;
}

-(UILabel *)title_label{
    _title_label = ({
        if (!_title_label) {
            _title_label = [UILabel new];
            _title_label.textAlignment = NSTextAlignmentLeft;
            _title_label.font = [UIFont systemFontOfSize:widthEx(13.f)];
            _title_label.textColor = [UIColor whiteColor];
            _title_label.text = @"点击使用效果";
        }
        _title_label;
    });
    return _title_label;
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

-(UIView *)bottom_View{
    _bottom_View = ({
        if (!_bottom_View) {
            _bottom_View = [[UIView alloc]initWithFrame:CGRectZero];
            _bottom_View.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5f];
        }
        _bottom_View;
    });
    return _bottom_View;
}

-(UIView *)indicatorView{
    _indicatorView = ({
        if (!_indicatorView) {
            _indicatorView = [[UIView alloc]initWithFrame:CGRectZero];
            _indicatorView.backgroundColor = UIColorFromRGB(0x0ae7ce);
        }
        _indicatorView;
    });
    return _indicatorView;
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
    __block CGFloat margin  = widthEx(12.f);
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3f];
    [self addSubview:self.title_label];
    [self.revokeItem setHidden:YES];
    self.revokeItem.bgroundColor = UIColorFromRGB(0x55586d);

    [self addSubview:self.revokeItem];
    [self.title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(margin);
        make.top.mas_equalTo(weakSelf.mas_top).with.offset(margin*1.5);
    }];
    [self.revokeItem mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.mas_equalTo(weakSelf.title_label.mas_centerY).with.offset(0.f);
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-margin);
        make.width.mas_equalTo(@(widthEx(70)));
        make.height.mas_equalTo(@(heightEx(30)));
    }];
    [self addSubview:self.bottom_View];
    [self.bottom_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(0.f);
        make.height.mas_equalTo(@(heightEx(40.f)));
    }];
    self.timeSelectView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.timeSelectView];
    [self.timeSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.and.right.mas_equalTo(weakSelf);
     make.top.mas_equalTo(weakSelf.title_label.mas_bottom).with.offset(0.f);
     make.bottom.mas_equalTo(weakSelf.bottom_View.mas_top).with.offset(0.f);
    }];
    NSArray * titleColors = @[[UIColor whiteColor],UIColorFromRGB(0x0ae7ce)];
    NSArray * titles = @[@"时间特效",@"滤镜特效"];
    for (int i = 0; i < titles.count; i++) {
        UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
        [item setTitleColor:titleColors[0] forState:UIControlStateNormal];
        [item setTitleColor:titleColors[1] forState:UIControlStateSelected];
        [item setTitle:titles[i] forState:UIControlStateNormal];
        item.titleLabel.textAlignment = NSTextAlignmentCenter;
        item.titleLabel.font = [UIFont systemFontOfSize:widthEx(14.f)];
        if (i== 0) {
            self.selectedButton = item;
            [self.selectedButton setSelected:YES];
        }
        [item addTarget:self action:@selector(itemEvents:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottom_View addSubview:item];
        [self.containers addObject:item];
    }
    [self.bottom_View addSubview:self.indicatorView];
    __block CGFloat padding = widthEx(40.f);
    __block UIButton * anchor = nil;
    __block CGFloat width =  (kScreenWidth - 4 *padding)/2.f;
    [self.containers enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.bottom_View.mas_centerY);
            if (anchor == nil) {
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
            }else{
        make.left.mas_equalTo(anchor.mas_right).with.offset(2* padding);
            }
        make.size.mas_equalTo(CGSizeMakeEx(width, heightEx(30.f)));
        }];
        anchor = obj;
    }];
    UIButton * item = (UIButton*)[self.containers firstObject];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(item.mas_centerX).with.offset(0.f);
        make.width.mas_equalTo(widthEx(50.f));
        make.height.mas_equalTo(@(heightEx(3.f)));
        make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(widthEx(-1.f));
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}


@end
