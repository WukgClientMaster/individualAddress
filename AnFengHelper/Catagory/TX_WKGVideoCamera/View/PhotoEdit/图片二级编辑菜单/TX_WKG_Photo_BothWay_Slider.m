//
//  TX_WKG_Photo_BothWay_Slider.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/7/4.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Photo_BothWay_Slider.h"
#import "TX_WKG_Photo_EditConfig.h"

@interface TX_WKG_Photo_BothWay_Slider()
@property (strong, nonatomic) UIImageView * maxTrackImageView; //最大值轨道视图
@property (strong, nonatomic) UIImageView * minTrackImageView;//最小值轨道视图
@property (strong, nonatomic) UIView * groundView;//底部视图
@property (strong, nonatomic) UIImageView * thumbImageView;
@property (strong, nonatomic) UIView * indicatorView;
@property (strong, nonatomic) NSMutableDictionary * jsonData;
@property (copy, nonatomic) NSString * sliderOperationString;

@end

@implementation TX_WKG_Photo_BothWay_Slider

#pragma mark - Events
-(void)dragethumbViewEvents:(UIPanGestureRecognizer*)pangesture{
    UIView * touchView = pangesture.view;
    if (pangesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pangesture locationInView:self];
        CGFloat middle_X = CGRectGetMinX(self.indicatorView.frame);
        CGRect superRect = CGRectMake(0, 0, CGRectGetWidth(self.frame)- CGRectGetWidth(self.thumbImageView.frame)/2.f, CGRectGetHeight(self.frame));
        if (CGRectContainsPoint(superRect, point)) {
            [self.thumbImageView setX:point.x];
            CGFloat thumbViewWidth = fabs(point.x - CGRectGetMinX(self.indicatorView.frame));
            CGRect frame = CGRectZero;
            CGFloat originX = 0.f;
            if (middle_X > point.x) {
                 originX = CGRectGetMinX(self.indicatorView.frame)- thumbViewWidth;
                self.value = -(thumbViewWidth / CGRectGetMinX(self.indicatorView.frame)*1.f);

            }else{
                 originX = CGRectGetMinX(self.indicatorView.frame);
                 self.value = thumbViewWidth / CGRectGetMinX(self.indicatorView.frame)* 1.f;
            }
            frame = CGRectMake(originX, CGRectGetMinY(self.minTrackImageView.frame), thumbViewWidth, CGRectGetHeight(self.minTrackImageView.frame));
            self.minTrackImageView.frame = frame;
        }
    }
    if (pangesture.state == UIGestureRecognizerStateCancelled ||
        pangesture.state == UIGestureRecognizerStateEnded) {
        [pangesture setTranslation:CGPointZero inView:touchView];
        if ([[self.jsonData allKeys]containsObject:self.sliderOperationString]) {
            NSNumber * num = @(self.value);
            [self.jsonData setObject:num forKey:self.sliderOperationString];
            [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_PHOTO_NEWDECOMMEND_ADPATOR_EFFECTIVE_NOTIFICATION_DEFINER object:@{@"optional":self.sliderOperationString,@"value":num} userInfo:nil];
        }
    }
}

-(void)initSetViewsWith:(NSString*)title{
    self.sliderOperationString = title;
    self.value = 0.0f;
    self.thumbImageView.frame = CGRectMake(CGRectGetMidX(self.frame) - CGRectGetMinX(self.frame)- widthEx(8.f)-0, CGRectGetMidY(self.frame) - widthEx(8.f), widthEx(16.f), widthEx(16.f));
    self.minTrackImageView.frame = CGRectMake(CGRectGetMidX(self.frame) - CGRectGetMinX(self.frame)-0, CGRectGetMidY(self.frame) - widthEx(3.f),0, widthEx(6.f));
}

-(void)resetViews{
    self.jsonData = @{@"亮度":@(0),
                      @"饱和度":@(0),
                      @"色温":@(0),
                      @"锐化":@(0),
                      }.mutableCopy;
    self.value = 0.0f;
    self.thumbImageView.frame = CGRectMake(CGRectGetMidX(self.frame) - CGRectGetMinX(self.frame)- widthEx(8.f)-0, CGRectGetMidY(self.frame) - widthEx(8.f), widthEx(16.f), widthEx(16.f));
    self.minTrackImageView.frame = CGRectMake(CGRectGetMidX(self.frame) - CGRectGetMinX(self.frame)-0, CGRectGetMidY(self.frame) - widthEx(3.f),0, widthEx(6.f));
}

-(void)setSliderWithValue:(CGFloat)value cata:(NSString*)title{
    self.value = value;
    self.sliderOperationString = title;
    if ([[self.jsonData allKeys]containsObject:title]) {
        NSNumber * num = @(value);
        [self.jsonData setObject:num forKey:title];
    }
    if (value < 0.f) {
        CGFloat width =  fabs(CGRectGetMinX(self.indicatorView.frame) * self.value);
        self.thumbImageView.frame = CGRectMake(CGRectGetMinX(self.indicatorView.frame) - width,CGRectGetMidY(self.frame) - widthEx(8.f),widthEx(16.f), widthEx(16.f));
        self.minTrackImageView.frame = CGRectMake(CGRectGetMinX(self.indicatorView.frame) - width, CGRectGetMidY(self.frame) - widthEx(3.f),width,widthEx(6.f));
    }else{
        CGFloat width = CGRectGetMinX(self.indicatorView.frame) * self.value;
        self.thumbImageView.frame = CGRectMake(CGRectGetMinX(self.indicatorView.frame)+ width,CGRectGetMidY(self.frame) - widthEx(8.f),widthEx(16.f), widthEx(16.f));
        self.minTrackImageView.frame = CGRectMake(CGRectGetMaxX(self.indicatorView.frame), CGRectGetMidY(self.frame) - widthEx(3.f),width, widthEx(6.f));
    }
}

#pragma mark - getter methods
-(UIImageView *)minTrackImageView{
    _minTrackImageView = ({
        if (!_minTrackImageView) {
            CGRect frame = CGRectMake(CGRectGetMidX(self.frame) - CGRectGetMinX(self.frame)-0, CGRectGetMidY(self.frame) - widthEx(3.f),0, widthEx(6.f));
            _minTrackImageView = [[UIImageView alloc]initWithFrame:frame];
            _minTrackImageView.backgroundColor = UIColorFromRGB(0xFC4C70);
        }
        _minTrackImageView;
    });
    return _minTrackImageView;
}

-(UIImageView *)maxTrackImageView{
    _maxTrackImageView = ({
        if (!_maxTrackImageView) {
             CGRect frame = CGRectMake(0, CGRectGetMidY(self.frame) - widthEx(3.f), CGRectGetWidth(self.frame), widthEx(6.f));
            _maxTrackImageView = [[UIImageView  alloc]initWithFrame:frame];
            _maxTrackImageView.backgroundColor = UIColorFromRGB(0xE5E5E5);
            _maxTrackImageView.layer.masksToBounds = YES;
            _maxTrackImageView.layer.cornerRadius = widthEx(3.f);
        }
        _maxTrackImageView;
    });
    return _maxTrackImageView;
}

-(UIImageView *)thumbImageView{
    _thumbImageView = ({
        if (!_thumbImageView) {
            CGRect frame = CGRectMake(CGRectGetMidX(self.frame) - CGRectGetMinX(self.frame)- widthEx(8.f)-0, CGRectGetMidY(self.frame) - widthEx(8.f), widthEx(16.f), widthEx(16.f));
            _thumbImageView = [[UIImageView alloc]initWithFrame:frame];
            _thumbImageView.backgroundColor = [UIColor whiteColor];
            _thumbImageView.layer.masksToBounds = YES;
            _thumbImageView.layer.cornerRadius = widthEx(8.f);
            _thumbImageView.layer.borderWidth = widthEx(2.f);
            _thumbImageView.layer.borderColor = UIColorFromRGB(0xFC4C70).CGColor;
        }
        _thumbImageView;
    });
    return _thumbImageView;
}

-(UIView *)indicatorView{
    _indicatorView = ({
        if (!_indicatorView) {
            CGRect frame = CGRectMake(CGRectGetMidX(self.frame)- CGRectGetMinX(self.frame) - widthEx(1.f), CGRectGetMidY(self.frame) - widthEx(5.f), widthEx(2.f), widthEx(10.f));
            _indicatorView = [[UIView alloc]initWithFrame:frame];
            _indicatorView.backgroundColor = UIColorFromRGB(0xFC4C70);
        }
        _indicatorView;
    });
    return _indicatorView;
}

-(UIView *)groundView{
    _groundView = ({
        if (!_groundView) {
            CGRect frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            _groundView = [[UIView alloc]initWithFrame:frame];
            _groundView.backgroundColor = [UIColor clearColor];
        }
        _groundView;
    });
    return _groundView;
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
    self.jsonData = @{@"亮度":@(0),
                      @"饱和度":@(0),
                      @"色温":@(0),
                      @"锐化":@(0),
                      }.mutableCopy;
    self.sliderOperationString = @"亮度";
    [self addSubview:self.groundView];
    [self addSubview:self.indicatorView];
    [self addSubview:self.maxTrackImageView];
    [self addSubview:self.minTrackImageView];
    [self addSubview:self.thumbImageView];
    [self bringSubviewToFront:self.indicatorView];
    [self bringSubviewToFront:self.thumbImageView];
    UIPanGestureRecognizer * pangesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragethumbViewEvents:)];
    [self.groundView setUserInteractionEnabled:YES];
    [self.groundView addGestureRecognizer:pangesture];
}

@end
