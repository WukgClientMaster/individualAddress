//
//  TX_WKG_ProgressView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/3/27.
//  Copyright © 2018年 NRH. All rights reserved.
//
typedef NS_ENUM(NSInteger, ProgressThumbViewStyle){
    ProgressThumbView_Left_Corner_Style = 0,
    ProgressThumbView_Right_Corner_Style,
    ProgressThumbView_None_Corner_Style,
}KProgressThumbViewStyle;

@interface TX_WKG_ProgressView_ThumbView : UIView
@property (strong, nonatomic) UIColor * thumbColor;
@property (assign, nonatomic) ProgressThumbViewStyle thumbStyle;
@end


@implementation TX_WKG_ProgressView_ThumbView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2f];
    _thumbColor = [[UIColor blackColor]colorWithAlphaComponent:0.2f];
    _thumbStyle = ProgressThumbView_None_Corner_Style;
}

#pragma mark - setter methods
-(void)setThumbColor:(UIColor *)thumbColor{
    _thumbColor = thumbColor;
    _thumbColor = _thumbColor == nil ? [[UIColor blackColor]colorWithAlphaComponent:0.2f] : _thumbColor;
    self.backgroundColor = _thumbColor;
}

-(void)setThumbStyle:(ProgressThumbViewStyle)thumbStyle{
    _thumbStyle = thumbStyle;
    [self drawCustomViewStyle];
}

-(void)drawCustomViewStyle{
    UIRectCorner corner;
    CGSize cornerSize;
    CGRect rect = self.frame;
    if (_thumbStyle == ProgressThumbView_Left_Corner_Style) {
        corner = UIRectCornerTopLeft |UIRectCornerBottomLeft;
        cornerSize = CGSizeMakeEx(CGRectGetHeight(rect), CGRectGetHeight(rect));
    }else if(_thumbStyle == ProgressThumbView_Right_Corner_Style){
        corner = UIRectCornerTopRight |UIRectCornerBottomRight;
        cornerSize = CGSizeMakeEx(CGRectGetHeight(rect), CGRectGetHeight(rect));
    }else{
        corner = UIRectCornerAllCorners;
        cornerSize = CGSizeZero;
    }
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:cornerSize];
    bezierPath.lineWidth = 0.f;
    bezierPath.lineCapStyle = kCGLineCapRound;
    CAShapeLayer * shape = [CAShapeLayer layer];
    shape.fillColor = _thumbColor.CGColor;
    shape.path = bezierPath.CGPath;
    [self.layer addSublayer:shape];
}

@end
@interface  TX_WKG_Progress_IndicatorView: UIView
@property (strong, nonatomic) UIColor * indicatorTintColor;
@end

@implementation TX_WKG_Progress_IndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
#pragma mark -  setter methods
-(void)setIndicatorTintColor:(UIColor *)indicatorTintColor{
    _indicatorTintColor = indicatorTintColor;
    _indicatorTintColor = _indicatorTintColor == nil ? [UIColor whiteColor] : _indicatorTintColor;
    self.backgroundColor = _indicatorTintColor;
}

-(void)setup{
    self.backgroundColor = [UIColor whiteColor];
}
@end


#import "TX_WKG_ProgressView.h"

@interface TX_WKG_ProgressView()<CAAnimationDelegate>
@property (assign,readwrite,nonatomic) float value;
@property (assign,readwrite,nonatomic) float progressValue;
@property (assign,readwrite,nonatomic) BOOL   pause;
@property (strong, nonatomic) NSTimer * autorunloopTimer;
@property (strong,readwrite,nonatomic) NSMutableArray * videofragmentViews;
@property (strong, nonatomic) TX_WKG_ProgressView_ThumbView *currentProgressThumbView;
@property (strong, nonatomic) TX_WKG_Progress_IndicatorView *currentProgressIndicatorView;

@end
NSString * CCAnimationPositionKey = @"CCAnimationPositionKey";
@implementation TX_WKG_ProgressView
#pragma mark - getter methods

-(void)obseverProgressValue{
    if (self.videofragmentViews.count == 0) {
        self.progressValue = 0.f;
    }else{
        UIView * lastView = [self.videofragmentViews lastObject];
        float value = CGRectGetMaxX(lastView.frame) / CGRectGetWidth(self.frame);
        self.progressValue = value;
        if (self.progressValue >= 0.999f) {
            [self removeRunloopTaskEvents];
        }
    }
}

-(NSTimer *)autorunloopTimer{
    _autorunloopTimer = ({
        if (!_autorunloopTimer) {
            __weak typeof(self)weakSelf = self;
            _autorunloopTimer = [NSTimer scheduledTimerWithTimeInterval:1.f repeats:YES block:^(NSTimer * _Nonnull timer) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                 strongSelf.value ++;
                [strongSelf setProgressValue:strongSelf.value animated:YES];
            }];
        }
        _autorunloopTimer;
    });
    return _autorunloopTimer;
}

-(NSMutableArray *)videofragmentViews{
    _videofragmentViews = ({
        if (!_videofragmentViews) {
            _videofragmentViews = [NSMutableArray array];
        }
        _videofragmentViews;
    });
    return _videofragmentViews;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
#pragma mark - layoutObjectViews
-(void)layoutObjectViews{
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [self obseverProgressValue];
}

#pragma mark - setter methods
-(void)setMaximumValue:(float)maximumValue{
    _maximumValue = maximumValue;
    _maximumValue = _maximumValue == 0 ? 180: _maximumValue;
}

-(void)setMinimumValue:(float)minimumValue{
    _minimumValue = minimumValue;
    _minimumValue = (_minimumValue > 0) ? 0 : _minimumValue;
}

-(void)setTrackTintColor:(UIColor *)trackTintColor{
    _trackTintColor = trackTintColor;
    _trackTintColor = _trackTintColor == nil ? [[UIColor blackColor]colorWithAlphaComponent:0.5f] : _trackTintColor;
    self.backgroundColor = _trackTintColor;
}

-(void)setIndicatorColor:(UIColor *)indicatorColor{
    _indicatorColor = indicatorColor;
    _indicatorColor = (_indicatorColor == nil) ? [UIColor whiteColor] : _indicatorColor;
}

-(void)setThumbColor:(UIColor *)thumbColor{
    _thumbColor = thumbColor;
    _thumbColor = (_thumbColor == nil) ? [[UIColor blackColor]colorWithAlphaComponent:0.4f] :
    _thumbColor;
}
#pragma mark - config views style
- (void)setVideoRecordPause:(BOOL)pause{
   //每一次暂停生产一个节点
    if (self.progressValue >0.99999f)return;
    self.pause = pause;
    if (self.pause) {
        if (self.videofragmentViews.count !=0) {
            UIView * lastView = [self.videofragmentViews lastObject];
            if ([lastView isKindOfClass:[TX_WKG_Progress_IndicatorView class]]) {
                [self videoResumeRecord];
            }else{
                [self videoStopRecord];
            }
        }
    }else{
        self.value = 0.f;
        if (self.videofragmentViews.count == 0) {
            [self videoStartRecord];
        }else{
            [self videoResumeRecord];
        }
    }
    [self autoRunloopPoolWithVideoRecordStatus:self.pause];
}

-(void)autoRunloopPoolWithVideoRecordStatus:(BOOL)pause{
    if (pause) {
        [self.autorunloopTimer setFireDate:[NSDate distantFuture]];
    }else{
        [self.autorunloopTimer setFireDate:[NSDate date]];
        [[NSRunLoop currentRunLoop]addTimer:self.autorunloopTimer forMode:NSDefaultRunLoopMode];
    }
}

-(void)videoStopRecord{
    TX_WKG_Progress_IndicatorView * indicatorView = [[TX_WKG_Progress_IndicatorView alloc]init];
    indicatorView.indicatorTintColor = self.indicatorColor;
    UIView * lastView = [self.videofragmentViews lastObject];
    indicatorView.frame = CGRectMake(CGRectGetMaxX(lastView.frame), 0, widthEx(2.f), CGRectGetHeight(self.frame));
    [self addSubview:indicatorView];
     self.currentProgressIndicatorView = indicatorView;
    [self.videofragmentViews addObject:indicatorView];
}

-(void)videoResumeRecord{
    TX_WKG_ProgressView_ThumbView * thumbView = [[TX_WKG_ProgressView_ThumbView alloc]init];
    thumbView.thumbColor = self.thumbColor;
    thumbView.thumbStyle = ProgressThumbView_None_Corner_Style;
    UIView * lastView = [self.videofragmentViews lastObject];
    thumbView.frame = CGRectMake(CGRectGetMaxX(lastView.frame), 0, 0, CGRectGetHeight(self.frame));
    [self addSubview:thumbView];
     self.currentProgressThumbView = thumbView;
    [self.videofragmentViews addObject:thumbView];
}

-(void)videoStartRecord{
    TX_WKG_ProgressView_ThumbView * thumbView = [[TX_WKG_ProgressView_ThumbView alloc]init];
    thumbView.thumbColor = self.thumbColor;
    thumbView.thumbStyle = ProgressThumbView_Left_Corner_Style;
    [self addSubview:thumbView];
    thumbView.frame = CGRectMake(0, 0, 0, CGRectGetHeight(self.frame));
    self.currentProgressThumbView = thumbView;
    [self.videofragmentViews addObject:thumbView];
}

- (void)removelastProgressView{
    if (self.videofragmentViews.count < 2) return;
    UIView * lastView = [self.videofragmentViews lastObject];
    if ([lastView isKindOfClass:[TX_WKG_ProgressView_ThumbView class]]) {
        NSTimeInterval timeInterval = 1.f;
        [UIView animateWithDuration:timeInterval animations:^{
            lastView.width = 0.5f;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [lastView removeFromSuperview];
                [self.videofragmentViews removeLastObject];
                [self refreshSubViewsLayout];
            });
        }];
    }else{
        UIView * lastThumbView = [self.videofragmentViews objectAtIndex:(self.videofragmentViews.count -2)];
        //CGFloat width = CGRectGetWidth(lastView.frame);
        //CGFloat thumbWidth = CGRectGetWidth(lastThumbView.frame);
        lastView.width = 0.f;
        [lastView removeFromSuperview];
        NSTimeInterval timeInterval = 1.f;
        [UIView animateWithDuration:timeInterval animations:^{
            lastThumbView.width = 0.5f;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.08 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [lastThumbView removeFromSuperview];
                [self.videofragmentViews removeObjectAtIndex:(self.videofragmentViews.count -2)];
                [self.videofragmentViews removeLastObject];
                [self refreshSubViewsLayout];
            });
        }];
    }
}

-(void)refreshSubViewsLayout{
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

#pragma mark - privite methods
- (void)setProgressValue:(float)value animated:(BOOL)animated{
    //每一次暂停之后，新生成的连续录制视频片段
    if (self.currentProgressThumbView == nil)return;
    if (self.currentProgressThumbView) {
        value =  value > self.maximumValue ? self.maximumValue : value;
        CGFloat width = value / self.maximumValue * CGRectGetWidth(self.frame);
        if (animated) {
            [UIView animateWithDuration:0.001 delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
                self.currentProgressThumbView.width = width;
            } completion:^(BOOL finished) {
                
            }];
        }else{
            self.currentProgressThumbView.width = width;
        }
    }
}

-(void)removeRunloopTaskEvents{
    if (_autorunloopTimer) {
        [_autorunloopTimer setFireDate:[NSDate distantFuture]];
        [_autorunloopTimer invalidate];
         _autorunloopTimer = nil;
    }
}

-(void)dealloc{
    [self removeRunloopTaskEvents];
}

#pragma mark - CAAnimationDelegate
-(void)setup{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    self.thumbColor = [[UIColor blackColor]colorWithAlphaComponent:0.4f];
    self.indicatorColor = [UIColor whiteColor];
    self.trackTintColor = [[UIColor blackColor]colorWithAlphaComponent:0.5f];
    self.minimumValue = 0.f;
    self.maximumValue = 20.f;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CGRectGetHeight(self.frame)/2.f;
}

@end
