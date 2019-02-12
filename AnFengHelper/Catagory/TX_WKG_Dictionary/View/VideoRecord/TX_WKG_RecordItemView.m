//
//  TX_WKG_RecordItemView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/3/27.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_RecordItemView.h"

@interface TX_WKG_RecordItemView()<UIGestureRecognizerDelegate>
@property (strong, nonatomic) NSMutableDictionary * viewGesturesDictionary;
@property (strong, nonatomic) NSMutableArray <CAShapeLayer*>* singleDrawShapeLayers;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) BOOL pause;
@property (strong, nonatomic) NSMutableArray * superViewLayers;
@property (strong, nonatomic) CAShapeLayer * superContainerLayer;
@property (copy, nonatomic) NSString * delayRecordVideo;
@property (strong, nonatomic) UIImageView * imageView;
@end

@implementation TX_WKG_RecordItemView
#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

-(void)dealloc{
    [self resetDeallocTimer];
}

-(void)resetDeallocTimer{
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)removeEventsViewLayers{
    //移除所有的layer
    if (self.singleDrawShapeLayers.count !=0) {
        [self.singleDrawShapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull shapeLayer, NSUInteger idx, BOOL * _Nonnull stop) {
            [shapeLayer removeAllAnimations];
            [shapeLayer removeFromSuperlayer];
        }];
    }
}

-(void)creatLongpressEventsViewLayers:(UIColor*)color{
    [self layerRemoveFromSuperLayer];
    [self.superViewLayers removeAllObjects];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) radius:CGRectGetWidth(self.frame) startAngle:0 endAngle:M_PI*2 clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = widthEx(2.f);
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineJoinRound;
    shapeLayer.path = path.CGPath;
    self.superContainerLayer.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self.superContainerLayer addSublayer:shapeLayer];
    [self.superViewLayers addObject:self.superContainerLayer];
    [self.superview.layer addSublayer:self.superContainerLayer];
    __block CAShapeLayer * animatedLayer = [CAShapeLayer layer];
    __block CGFloat width = widthEx(4.f);
    __block UIBezierPath *animationPath;
    __block BOOL flage = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03f repeats:YES block:^(NSTimer * _Nonnull timer) {
        animatedLayer.fillColor = [UIColor clearColor].CGColor;
        if (width <= widthEx(12.f)) {
            if (!flage) {
                width ++;
            }else{
                width--;
                if (width ==widthEx(4.f)) {
                    flage = NO;
                }
            }
            if (width == widthEx(12.f)) {
                flage = YES;
            }
        }else if(flage){
            width--;
        }
        animatedLayer.lineWidth   =  width;
        animatedLayer.strokeColor =  color.CGColor;
        animatedLayer.fillColor   =  [UIColor clearColor].CGColor;
        animationPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) radius:CGRectGetWidth(self.frame) -width/4.f startAngle:0 endAngle:M_PI*2 clockwise:YES];
        animatedLayer.path = animationPath.CGPath;
        [animatedLayer removeFromSuperlayer];
        [self.superContainerLayer addSublayer:animatedLayer];
    }];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)creatSingTapEvnetsViewLayers{
    CAShapeLayer * rectangleShapeLayer = [CAShapeLayer layer];
    rectangleShapeLayer.fillColor = UIColorFromRGB(0x00fbc5).CGColor;
    CGFloat width_height = widthEx(40.f);
    CGFloat x = CGRectGetWidth(self.frame) - width_height/2.f;
    CGFloat y = CGRectGetHeight(self.frame) - width_height/2.f;
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, width_height, width_height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(widthEx(8.f), widthEx(8.f))];
    rectangleShapeLayer.path = path.CGPath;
    [self.superContainerLayer addSublayer:rectangleShapeLayer];
}

-(void)layerRemoveFromSuperLayer{
    [self resetDeallocTimer];
    [self.superContainerLayer removeAllAnimations];
    [self.superContainerLayer removeFromSuperlayer];
}

-(void)exchangeVideoMannerLayers{
    //移除点击拍摄视图图层
    [self.singleDrawShapeLayers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeAllAnimations];
        [obj removeFromSuperlayer];
    }];
    [self.singleDrawShapeLayers removeAllObjects];
}

#pragma mark - IBOutlet Events
//对于事件处理来说//单击比双击困难
-(void)longPressEvents:(UILongPressGestureRecognizer*)longpressGesture{
    if ([self.subviews containsObject:self.imageView]) {
        [self.imageView removeFromSuperview];
    }
    if (longpressGesture.state == UIGestureRecognizerStateBegan) {
        // 初始化layer
        self.backgroundColor = [UIColor clearColor];
        [self creatLongpressEventsViewLayers:UIColorFromRGB(0x09e8cd)];
        if (self.cancelCallback) {
            self.cancelCallback(TX_WKG_VideoManner_LongPress,NO);
        }

    }else if(longpressGesture.state == UIGestureRecognizerStateChanged){
        //改变layer的位置
        self.backgroundColor = [UIColor clearColor];
        CGPoint point = [longpressGesture locationInView:self.superview];
        self.superContainerLayer.position = point;
    }else if((longpressGesture.state == UIGestureRecognizerStateEnded)
             ||(longpressGesture.state == UIGestureRecognizerStateCancelled)){
        [self removeEventsViewLayers];
        [self layerRemoveFromSuperLayer];
        [self.singleDrawShapeLayers removeAllObjects];
        [self.superViewLayers removeAllObjects];
        self.backgroundColor = [UIColor clearColor];
        _superContainerLayer = nil;
        if (![self.subviews containsObject:self.imageView]) {
            [self addSubview:self.imageView];
        }
        //改变layer的位置
        if (self.cancelCallback) {
            self.cancelCallback(TX_WKG_VideoManner_LongPress,YES);
        }
    }
}

-(void)applicationDidBackGroundEvents{
    [self removeEventsViewLayers];
    [self layerRemoveFromSuperLayer];
    [self.superViewLayers removeAllObjects];
    _superContainerLayer = nil;
    self.pause = NO;
    if (_videoRecordType == TX_WKG_VideoManner_SingleTip) {
        self.backgroundColor = [UIColor clearColor];
        [self singleMannerRecordVideoDrawView];
        UILongPressGestureRecognizer * longpress = self.viewGesturesDictionary[@"longpress"];
        [self removeGestureRecognizer:longpress];
        [self.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removeGestureRecognizer:obj];
        }];
        [self.viewGesturesDictionary removeObjectForKey:@"longpress"];
        UITapGestureRecognizer * singletap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singtapEvents:)];
        singletap.delegate = self;
        singletap.numberOfTapsRequired = 1.f;
        [self addGestureRecognizer:singletap];
        [self.viewGesturesDictionary setObject:singletap forKey:@"singletap"];
        [self.imageView removeFromSuperview];
        [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        } completion:^(BOOL finished) {
            self.backgroundColor = [UIColor clearColor];
        }];
    }else{
            [self exchangeVideoMannerLayers];
            self.backgroundColor = [UIColor clearColor];
            if (![self.subviews containsObject:self.imageView]){
                [self addSubview:self.imageView];
                if ([[self.viewGesturesDictionary allKeys]containsObject:@"singletap"]) {
                    UITapGestureRecognizer * singletap = self.viewGesturesDictionary[@"singletap"];
                    [self removeGestureRecognizer:singletap];
                }
                if (![[self.viewGesturesDictionary allKeys]containsObject:@"longpress"]) {
                    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressEvents:)];
                    longPressGesture.delegate = self;
                    longPressGesture.minimumPressDuration = 0.3f;
                    [self.viewGesturesDictionary setObject:longPressGesture forKey:@"longpress"];
                    [self addGestureRecognizer:longPressGesture];
                }
         }
    }
}
    
-(void)delayRecordVideoWithManner:(TX_WKG_VideoManner)manner{
    self.pause = YES;
    if (self.videoRecordType == TX_WKG_VideoManner_LongPress) {
        self.delayRecordVideo = @"YES";
        UILongPressGestureRecognizer * longpress = self.viewGesturesDictionary[@"longpress"];
        [self removeGestureRecognizer:longpress];
        [self.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removeGestureRecognizer:obj];
        }];
        [self.viewGesturesDictionary removeObjectForKey:@"longpress"];
        UITapGestureRecognizer * singletap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singtapEvents:)];
        singletap.delegate = self;
        singletap.numberOfTapsRequired = 1.f;
        [self addGestureRecognizer:singletap];
        [self.viewGesturesDictionary setObject:singletap forKey:@"singletap"];
         self.backgroundColor = [UIColor clearColor];
    }else{
        self.delayRecordVideo = @"NO";
    }
    
    if ([self.subviews containsObject:self.imageView]) {
        [self.imageView removeFromSuperview];
    }
    [self exchangeVideoMannerLayers];
    [self creatLongpressEventsViewLayers:[UIColorFromRGB(0x07eccc) colorWithAlphaComponent:0.5]];
    [self creatSingTapEvnetsViewLayers];
}

-(void)singtapEvents:(UITapGestureRecognizer*)singleTapGesture{
    //移除点击拍摄视图图层
     self.pause  = !self.pause;
    [self exchangeVideoMannerLayers];
    if (!self.pause) {
        [self removeEventsViewLayers];
        [self layerRemoveFromSuperLayer];
        [self singleMannerRecordVideoDrawView];
        [self.superViewLayers removeAllObjects];
        _superContainerLayer = nil;
        if (singleTapGesture.state == UIGestureRecognizerStateEnded) {
            if (![self.delayRecordVideo isEqualToString:@"YES"]) {
                self.backgroundColor = [UIColor clearColor];
                [self singleMannerRecordVideoDrawView];
            }else{
                 [self exchangeVideoMannerLayers];
                 self.backgroundColor = [UIColor clearColor];
                 if (![self.subviews containsObject:self.imageView]){
                    [self addSubview:self.imageView];
                    if ([[self.viewGesturesDictionary allKeys]containsObject:@"singletap"]) {
                        UITapGestureRecognizer * singletap = self.viewGesturesDictionary[@"singletap"];
                        [self removeGestureRecognizer:singletap];
                    }
                    if (![[self.viewGesturesDictionary allKeys]containsObject:@"longpress"]) {
                        UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressEvents:)];
                        longPressGesture.delegate = self;
                        longPressGesture.minimumPressDuration = 0.3f;
                        [self.viewGesturesDictionary setObject:longPressGesture forKey:@"longpress"];
                        [self addGestureRecognizer:longPressGesture];
                    }
                }
            }
        }
        if (self.cancelCallback){
            self.cancelCallback(TX_WKG_VideoManner_SingleTip,YES);
        }
    }else{
        if (singleTapGesture.state == UIGestureRecognizerStateEnded) {
            [self creatLongpressEventsViewLayers:[UIColorFromRGB(0x07eccc) colorWithAlphaComponent:0.5]];
            [self creatSingTapEvnetsViewLayers];
            if (self.cancelCallback) {
                self.cancelCallback(TX_WKG_VideoManner_SingleTip,NO);
                }
           }
      }
}

//点击下一步结束视频录制
-(void)finishRecordVideoEvents{
    [self removeEventsViewLayers];
    [self layerRemoveFromSuperLayer];
    [self singleMannerRecordVideoDrawView];
    [self.superViewLayers removeAllObjects];
    _superContainerLayer = nil;
}

#pragma mark - getter methods
-(CAShapeLayer *)superContainerLayer{
    _superContainerLayer = ({
        if (!_superContainerLayer) {
            _superContainerLayer = [CAShapeLayer layer];
            _superContainerLayer.backgroundColor = [UIColor clearColor].CGColor;
            _superContainerLayer.anchorPoint = CGPointMake(0.5, 0.5);
            _superContainerLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame)*2.f,CGRectGetHeight(self.frame)*2.f);
        }
        _superContainerLayer;
    });
    return _superContainerLayer;
}


-(NSMutableArray *)superViewLayers{
    _superViewLayers = ({
        if (!_superViewLayers) {
            _superViewLayers = [NSMutableArray array];
        }
        _superViewLayers;
    });
    return _superViewLayers;
}

-(NSMutableArray<CAShapeLayer *> *)singleDrawShapeLayers{
    _singleDrawShapeLayers = ({
        if (!_singleDrawShapeLayers) {
            _singleDrawShapeLayers  = [NSMutableArray array];
        }
        _singleDrawShapeLayers;
    });
    return _singleDrawShapeLayers;
}

-(NSMutableDictionary *)viewGesturesDictionary{
    _viewGesturesDictionary = ({
        if (!_viewGesturesDictionary) {
            _viewGesturesDictionary = [NSMutableDictionary dictionary];
        }
        _viewGesturesDictionary;
    });
    return _viewGesturesDictionary;
}

-(UIImageView *)imageView{
    _imageView = ({
        if (!_imageView) {
            _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            _imageView.layer.masksToBounds = YES;
            _imageView.image = [UIImage imageNamed:@"tx_qmx_paishe_changanpai"];
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        _imageView;
    });
    return _imageView;
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
    self.backgroundColor = [UIColor clearColor];
    self.videoRecordType = TX_WKG_VideoManner_LongPress;
    self.pause = NO;
    self.userInteractionEnabled = YES;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = CGRectGetHeight(self.frame)/2.f;
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressEvents:)];
    longPressGesture.minimumPressDuration = 2.0;
    longPressGesture.delegate = self;
    [self addGestureRecognizer:longPressGesture];
    [self.viewGesturesDictionary setObject:longPressGesture forKey:@"longpress"];
    self.imageView.center = CGPointMake(CGRectGetWidth(self.frame)/2.f, CGRectGetHeight(self.frame)/2.f);
    self.imageView.size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self addSubview:self.imageView];
}

#pragma mark -setter methods
-(void)setPeripheryCircleColor:(UIColor *)peripheryCircleColor{
    _peripheryCircleColor = peripheryCircleColor;
    _peripheryCircleColor = _peripheryCircleColor ? [UIColor clearColor]: _peripheryCircleColor;
}

-(void)setInternalCircleColor:(UIColor *)internalCircleColor{
    _internalCircleColor = internalCircleColor;
    _internalCircleColor = _internalCircleColor ? [UIColor clearColor]: _internalCircleColor;
}

-(void)setCompleted:(BOOL)completed{
    _completed = completed;
    if (_completed) {
        if (_videoRecordType == TX_WKG_VideoManner_LongPress) {
            [self removeEventsViewLayers];
            [self layerRemoveFromSuperLayer];
            [self.singleDrawShapeLayers removeAllObjects];
            [self.superViewLayers removeAllObjects];
            self.backgroundColor = [UIColor clearColor];
            _superContainerLayer = nil;
            if (![self.subviews containsObject:self.imageView]) {
                [self addSubview:self.imageView];
            }
        }else{
            [self exchangeVideoMannerLayers];
            [self removeEventsViewLayers];
            [self layerRemoveFromSuperLayer];
            [self singleMannerRecordVideoDrawView];
            [self.superViewLayers removeAllObjects];
            _superContainerLayer = nil;
        }
    }
}

-(void)setVideoRecordType:(TX_WKG_VideoManner)videoRecordType{
    _videoRecordType = videoRecordType;
    self.delayRecordVideo = @"NO";
    if (_videoRecordType == TX_WKG_VideoManner_LongPress) {
        //手势处理
        if ([[self.viewGesturesDictionary allKeys]containsObject:@"singletap"]) {
            UITapGestureRecognizer * singletap = self.viewGesturesDictionary[@"singletap"];
            [self removeGestureRecognizer:singletap];
        }
        if (![[self.viewGesturesDictionary allKeys]containsObject:@"longpress"]) {
            UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressEvents:)];
            longPressGesture.delegate = self;
            longPressGesture.minimumPressDuration = 0.3f;
            [self.viewGesturesDictionary setObject:longPressGesture forKey:@"longpress"];
            [self addGestureRecognizer:longPressGesture];
        }
        //视图展示
        /*
         * 1,添加 title_label control
         * 2,移除 点击手势所有的视图或者layer
         */
        //移除点击拍摄视图图层
        [self exchangeVideoMannerLayers];
        self.backgroundColor = [UIColor clearColor];
        if (![self.subviews containsObject:self.imageView]){
            self.imageView.center = CGPointMake(CGRectGetWidth(self.frame)/2.f,CGRectGetHeight(self.frame)/2.f);
            self.imageView.size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
            [self addSubview:self.imageView];
        }
    }else if(_videoRecordType == TX_WKG_VideoManner_SingleTip){
        UILongPressGestureRecognizer * longpress = self.viewGesturesDictionary[@"longpress"];
        [self removeGestureRecognizer:longpress];
        [self.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self removeGestureRecognizer:obj];
        }];
        [self.viewGesturesDictionary removeObjectForKey:@"longpress"];
        UITapGestureRecognizer * singletap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singtapEvents:)];
        singletap.delegate = self;
        singletap.numberOfTapsRequired = 1.f;
        [self addGestureRecognizer:singletap];
        [self.viewGesturesDictionary setObject:singletap forKey:@"singletap"];
        [self.imageView removeFromSuperview];
        [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        } completion:^(BOOL finished) {
             self.backgroundColor = [UIColor clearColor];
            [self singleMannerRecordVideoDrawView];
        }];
    }
}

-(void)singleMannerRecordVideoDrawView{
    CAShapeLayer * peripheryLayer = [CAShapeLayer layer];
    peripheryLayer.fillColor = [UIColor clearColor].CGColor;
    peripheryLayer.strokeColor = [UIColorFromRGB(0x07eccc)colorWithAlphaComponent:0.5].CGColor;
    peripheryLayer.lineWidth = widthEx(10.f);
    UIBezierPath *peripheryBezier = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.frame)/2.f, CGRectGetHeight(self.frame)/2.f) radius:CGRectGetWidth(self.frame)/2.f startAngle:0 endAngle:M_PI*2 clockwise:YES];
    peripheryLayer.path = peripheryBezier.CGPath;
    [self.layer addSublayer:peripheryLayer];
    [self.singleDrawShapeLayers addObject:peripheryLayer];
    CAShapeLayer * interiorLayer = [CAShapeLayer layer];
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0x00fbc5).CGColor,(__bridge id)UIColorFromRGB(0x011d8d5).CGColor];
    gradientLayer.locations = @[@0.2];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.f);
    CGFloat width = (CGRectGetWidth(self.frame)/2.f - widthEx(10.f))*2.f;
    gradientLayer.bounds = CGRectMake(0, 0,width, width);
    gradientLayer.position = CGPointMake(CGRectGetWidth(self.frame)/2.f,CGRectGetHeight(self.frame)/2.f);
    gradientLayer.cornerRadius = width/2.f;
    UIBezierPath *interiorBezier = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.frame)/2.f, CGRectGetHeight(self.frame)/2.f) radius:(CGRectGetWidth(self.frame)/2.f - widthEx(10.f))startAngle:0 endAngle:M_PI*2 clockwise:YES];
    interiorLayer.path =interiorBezier.CGPath;
    [interiorLayer addSublayer:gradientLayer];
    [self.layer addSublayer:interiorLayer];
    [self.singleDrawShapeLayers addObject:interiorLayer];
}

@end
