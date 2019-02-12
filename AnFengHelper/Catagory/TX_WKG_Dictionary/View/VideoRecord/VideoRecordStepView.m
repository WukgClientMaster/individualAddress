//
//  VideoRecordStepView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/3/26.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "VideoRecordStepView.h"

@interface VideoRecordStepView()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) UIView * indicatorView;
@property (strong, nonatomic) NSMutableArray * containers;
@property (copy, nonatomic) NSString * isDidTapControl;
@property (strong, nonatomic) UILabel *currentIndicatorLabel;

@end

@implementation VideoRecordStepView
-(NSMutableArray *)containers{
    _containers = ({
        if (!_containers) {
            _containers = [NSMutableArray array];
        }
        _containers;
    });
    return _containers;
}

-(UIView *)indicatorView{
    _indicatorView = ({
        if (!_indicatorView) {
            _indicatorView = [[UIView alloc]initWithFrame:CGRectZero];
            _indicatorView.backgroundColor = [UIColor whiteColor];
        }
        _indicatorView;
    });
    return _indicatorView;
}

-(UIScrollView *)scrollView{
    _scrollView = ({
        if (!_scrollView) {
            _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
            _scrollView.backgroundColor = [UIColor clearColor];
            _scrollView.scrollEnabled = NO;
            _scrollView.showsVerticalScrollIndicator = NO;
            _scrollView.showsHorizontalScrollIndicator = NO;
            _scrollView.delegate = self;
            if (@available(ios 11.0,*)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
        }
        _scrollView;
    });
    return _scrollView;
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
    [self addSubview:self.scrollView];
    __weak typeof(self)weakSelf = self;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(weakSelf).with.insets(UIEdgeInsetsZero);
    make.height.mas_equalTo(weakSelf.mas_height).with.offset(0.f);
    }];
    [self addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(widthEx(3), heightEx(4)));
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(-widthEx(4.f));
    }];
    NSArray * items = @[@"长按拍摄",@"单击拍摄"];
    for (int i = 0; i <  items.count; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = items[i];
        label.font = [UIFont systemFontOfSize:14.f];
        label.userInteractionEnabled = YES;
        label.textColor = [UIColor whiteColor];
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemOptEvents:)];
        gesture.numberOfTapsRequired = 1.f;
        [label addGestureRecognizer:gesture];
        label.textAlignment = NSTextAlignmentCenter;
        label.alpha = (i== 0) ?  1.0f : 0.7f;
        if (i == 0) {
            self.currentIndicatorLabel = label;
        }
        [self.scrollView addSubview:label];
        [self.containers addObject:label];
    }
    __block UILabel * anchor = nil;
    __block CGFloat margin = widthEx(45.f);
    [self.containers enumerateObjectsUsingBlock:^(UILabel* label, NSUInteger idx, BOOL *  stop) {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.scrollView.mas_centerY).with.offset(0.f);
            if (anchor == nil) {
           make.centerX.mas_equalTo(weakSelf.scrollView.mas_centerX).with.offset(0.f);
            }else{
            make.left.mas_equalTo(anchor.mas_right).with.offset(margin);
            }
        }];
        anchor = label;
    }];
}

-(void)autolayoutScrollViewContentViewOffSet{
    CGFloat middleX = CGRectGetMidX(self.currentIndicatorLabel.frame);
    if (middleX == 0)return;
    [self.containers enumerateObjectsUsingBlock:^(UILabel* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.alpha = 0.7f;
    }];
    [UIView animateWithDuration:0.2 animations:^{
    } completion:^(BOOL finished) {
        self.currentIndicatorLabel.alpha = 1.f;
        [self.scrollView setContentOffset:CGPointMake((middleX - KScreenWidth/2.f), 0)animated:YES];
    }];
}

-(void)itemOptEvents:(UITapGestureRecognizer*)gesture{
    self.isDidTapControl =  @"YES";
    [self.containers enumerateObjectsUsingBlock:^(UILabel* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.alpha = 0.7f;
    }];
    UILabel * touchView = (UILabel*)gesture.view;
    if (![touchView isEqual:self.currentIndicatorLabel]) {
        self.currentIndicatorLabel = touchView;
    }
    if (self.block) {
        self.block(self.currentIndicatorLabel.text);
    }
    CGFloat middleX = CGRectGetMidX(touchView.frame);
    [UIView animateWithDuration:0.2 animations:^{
    } completion:^(BOOL finished) {
         touchView.alpha = 1.f;
        [self.scrollView setContentOffset:CGPointMake((middleX - KScreenWidth/2.f), 0)animated:YES];
    }];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    /*
    [self adjustScrollViewContentSubViews:scrollView];
    if (self.block) {
        self.block(self.currentIndicatorLabel.text);
    }
    */
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    /*
    if (decelerate == NO) {
        [self adjustScrollViewContentSubViews:scrollView];
        if (self.block) {
            self.block(self.currentIndicatorLabel.text);
        }
    }
    */
}

-(void)adjustScrollViewContentSubViews:(UIScrollView *)scrollView{
    self.isDidTapControl = @"NO";
    CGFloat offsetX = scrollView.contentOffset.x;
    UILabel * firstLabel = [self.containers firstObject];
    UILabel * lastLabel  = [self.containers lastObject];
    CGFloat margin = widthEx(45.f);
    if (offsetX < 0) {
        self.currentIndicatorLabel = firstLabel;
        [UIView animateWithDuration:0.2 animations:^{
            [self.containers enumerateObjectsUsingBlock:^(UILabel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.alpha = 0.7f;
            }];
        } completion:^(BOOL finished) {
            self.currentIndicatorLabel.alpha = 1.f;
            [self.scrollView setContentOffset:CGPointZero];
        }];
    }else if(offsetX > 0){
        if ([self.currentIndicatorLabel isEqual:firstLabel]) {
            if (offsetX < margin * (2/3.f)){
                [UIView animateWithDuration:0.2 animations:^{
                    [self.containers enumerateObjectsUsingBlock:^(UILabel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.alpha = 0.7f;
                    }];
                } completion:^(BOOL finished) {
                    self.currentIndicatorLabel.alpha = 1.f;
                    [self.scrollView setContentOffset:CGPointZero];
                }];
            }else if(offsetX > margin * (2/3.f)){
                self.currentIndicatorLabel = lastLabel;
                [UIView animateWithDuration:0.2 animations:^{
                    [self.containers enumerateObjectsUsingBlock:^(UILabel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.alpha = 0.7f;
                    }];
                } completion:^(BOOL finished) {
                    self.currentIndicatorLabel.alpha = 1.f;
                    [self.scrollView setContentOffset:CGPointMake(CGRectGetMidX(lastLabel.frame) - KScreenWidth/2.f, 0)];
                }];
            }
        }else{
            CGFloat relativeOffsetX = offsetX - (CGRectGetMidX(lastLabel.frame) - KScreenWidth/2.f);
            if (relativeOffsetX > 0) {
                self.currentIndicatorLabel = lastLabel;
                [UIView animateWithDuration:0.2 animations:^{
                    [self.containers enumerateObjectsUsingBlock:^(UILabel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.alpha = 0.7f;
                    }];
                } completion:^(BOOL finished) {
                    self.currentIndicatorLabel.alpha = 1.f;
                    [self.scrollView setContentOffset:CGPointMake(CGRectGetMidX(lastLabel.frame) - KScreenWidth/2.f, 0)];
                }];
            }else if(relativeOffsetX < 0){
                self.currentIndicatorLabel = firstLabel;
                [UIView animateWithDuration:0.2 animations:^{
                    [self.containers enumerateObjectsUsingBlock:^(UILabel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.alpha = 0.7f;
                    }];
                } completion:^(BOOL finished) {
                    self.currentIndicatorLabel.alpha = 1.f;
                    [self.scrollView setContentOffset:CGPointZero];
                }];
            }
        }
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.scrollView setContentSize:CGSizeMakeEx(KScreenWidth*1.1, CGRectGetHeight(self.frame))];
}
@end
