//
//  ActionSheetView.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/18.
//  Copyright © 2016年 吴可高. All rights reserved.
//
static const CGFloat  kItemTitleHeight = 40.f;
static const CGFloat  kItemMarginHeight = 1.f;
static const CGFloat  kDefaultAnimationDuration  = 1.5f;
static const CGFloat  kItemSuitableHeight  = kItemTitleHeight + kItemMarginHeight;


#import "ActionSheetView.h"
@interface ActionSheetView ()
{
    CGSize  _size;
}
@property (strong, nonatomic) UIView * backgroundView;
@end

@implementation ActionSheetView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr;
{
    if (self  = [super initWithFrame:frame])
    {
        self = [super initWithFrame:frame];
        _size = [UIScreen mainScreen].bounds.size;
        [self setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSheet)];
        [self addGestureRecognizer:tap];
        [self makeBaseUIWithTitleArr:titleArr];
    }
    return self;
}

-(void)makeBaseUIWithTitleArr:(NSArray*)titles
{
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, _size.height, _size.width, (titles.count+1) * kItemSuitableHeight)];
    _backgroundView.backgroundColor = [UIColor colorWithRed:0xe9/255.0 green:0xe9/255.0 blue:0xe9/255.0 alpha:1.0];
    [self addSubview:_backgroundView];
    
    
    CGFloat y = [self createBtnWithTitle:@"取消" origin_y: _backgroundView.frame.size.height -kItemSuitableHeight tag:-1 action:@selector(hiddenSheet)]-kItemSuitableHeight;
    for (int i = (int)titles.count-1; i >= 0; i--)
    {
        y = [self createBtnWithTitle:titles[i] origin_y:y tag:i action:@selector(click:)];
    }
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        CGRect frame = _backgroundView.frame;
        frame.origin.y -= frame.size.height;
        _backgroundView.frame = frame;
    }];
}

- (CGFloat)createBtnWithTitle:(NSString *)title origin_y:(CGFloat)y tag:(NSInteger)tag action:(SEL)method
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, y, _size.width,kItemTitleHeight);
    btn.backgroundColor = [UIColor whiteColor];
    btn.tag = tag;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:method forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:btn];
    return y -= tag == -1 ? 0 : kItemSuitableHeight;
}

- (void)hiddenSheet {
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        CGRect frame = _backgroundView.frame;
        frame.origin.y += frame.size.height;
        _backgroundView.frame = frame;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDefaultAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)click:(UIButton *)btn {
    if (_Click) {
        _Click(btn.tag);
    }
}

@end
