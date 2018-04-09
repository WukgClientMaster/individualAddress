//
//  LoginViewController.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.

#import "LoginViewController.h"

@interface LoginViewController ()<CAAnimationDelegate>
@property (weak, nonatomic) UIView * masonryView;
@property (strong, nonatomic) NSMutableArray * layers;
@end

@implementation LoginViewController

-(NSMutableArray *)layers{
    _layers = ({
        if (!_layers) {
            _layers = [NSMutableArray array];
        }
        _layers;
    });
    return _layers;
}

-(void)initialzieCurvePath{
    CGFloat startX = 10;
    CGFloat startY = CGRectGetMidY(self.view.frame);
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath  moveToPoint:CGPointMake(startX, startY)];
    [bezierPath addQuadCurveToPoint:CGPointMake(startX + 100, startY - 10) controlPoint:CGPointMake(startX+50, startY -90)];
    
    [bezierPath addQuadCurveToPoint:CGPointMake(startX + 220, startY - 60) controlPoint:CGPointMake(startX + 130, startY - 150)];
    [bezierPath addQuadCurveToPoint:CGPointMake(startX + 300, startY-80) controlPoint:CGPointMake(startX + 270, startY - 200)];
    
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.lineWidth = 3.f;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor   = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:shapeLayer];
    [self.layers addObject:shapeLayer];
    CABasicAnimation *anmi = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anmi.fromValue = [NSNumber numberWithFloat:0];
    anmi.toValue = [NSNumber numberWithFloat:1.0f];
    anmi.duration = 5;
    anmi.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anmi.autoreverses = NO;
    [shapeLayer addAnimation:anmi forKey:@"stroke"];
    
    CAShapeLayer * indicatorShapeLayer =[CAShapeLayer layer];
    indicatorShapeLayer.lineWidth = 2.f;
    indicatorShapeLayer.position = CGPointMake(startX, startY);
    indicatorShapeLayer.bounds = CGRectMake(0, 0, 8, 8);
    indicatorShapeLayer.cornerRadius = 4;
    indicatorShapeLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:indicatorShapeLayer];
    [self.layers addObject:indicatorShapeLayer];

    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = 5.f;
    animation.timingFunctions=@[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    animation.calculationMode = kCAAnimationPaced;
    animation.path = bezierPath.CGPath;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.repeatCount = YES;
    [indicatorShapeLayer addAnimation:animation forKey:nil];
    
    UIBezierPath * bezier1 = [UIBezierPath bezierPath];
    //遮罩层
    [bezier1 appendPath:bezierPath];
    [bezier1 addLineToPoint:CGPointMake(startX+300, (startY+20))];
    [bezier1 addLineToPoint:CGPointMake(startX, startY+20)];
    [bezier1 addLineToPoint:CGPointMake(startX, startY)];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 0.5);
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:166/255.0 green:206/255.0 blue:247/255.0 alpha:0.7].CGColor,(__bridge id)[UIColor colorWithRed:237/255.0 green:246/255.0 blue:253/255.0 alpha:0.5].CGColor];
    gradientLayer.locations = @[@(0.5f)];
    
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = bezier1.CGPath;
    
    
    CAShapeLayer * maskBaseGroundLayer =[CAShapeLayer layer];
    gradientLayer.bounds = CGRectMake(0, 0, 0, 170);
    gradientLayer.position = CGPointMake(0, 275);
    [maskBaseGroundLayer setMask:shadeLayer];
    [maskBaseGroundLayer addSublayer:gradientLayer];
    [self.view.layer addSublayer:maskBaseGroundLayer];
    [self.layers addObject:maskBaseGroundLayer];

    
    CABasicAnimation *anmi1 = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
    anmi1.fromValue = [NSValue valueWithCGSize:CGSizeMake(0, 170)];;
    anmi1.toValue = [NSValue valueWithCGSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 70, 170)];
    
    CABasicAnimation * positionBasicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    CGFloat positionX = CGRectGetWidth(self.view.frame) - 70;
    CGFloat positionY = 275;
    positionBasicAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(positionX/2.f, positionY)];
    CAAnimationGroup * gradientLayerGroupAnimation = [CAAnimationGroup animation];
    gradientLayerGroupAnimation.duration = 5.f;
    gradientLayerGroupAnimation.animations = @[anmi1,positionBasicAnimation];
    gradientLayerGroupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    gradientLayerGroupAnimation.fillMode = kCAFillModeForwards;
    gradientLayerGroupAnimation.removedOnCompletion = NO;
    [gradientLayer addAnimation:gradientLayerGroupAnimation forKey:@""];
    
}


-(void)createCurveBezierPath{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor redColor];
    view.layer.cornerRadius = 20.f;
    view.layer.shadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.9].CGColor;
    view.layer.shadowRadius = 5.f;
    view.layer.shadowOpacity = 0.6f;
    view.layer.shadowOffset = CGSizeMake(0, 5);
    [view setUserInteractionEnabled:YES];
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureEvents)];
    gesture.numberOfTapsRequired = 1.f;
    [view addGestureRecognizer:gesture];
    [self.view addSubview:view];
    self.masonryView = view;
    __weak typeof(self)weakSelf = self;
    __block CGFloat padding = 20;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(padding);
        make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(84);
    }];
    CGFloat midX = CGRectGetMidX(self.view.frame);
    CGFloat midY = CGRectGetMidY(self.view.frame);
    CGFloat startCurvePointX = 84 + padding*2.5;
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(padding*2,84 + padding)];
    [bezierPath addLineToPoint:CGPointMake(100,84 + padding*2.5)];
    [bezierPath addQuadCurveToPoint:CGPointMake(midX+80, startCurvePointX + 150) controlPoint:CGPointMake(midX*2.2, startCurvePointX+60)];
    [bezierPath addQuadCurveToPoint:CGPointMake( midX - padding*2.f, midY+160) controlPoint:CGPointMake(0.f, midY +30)];
    [bezierPath addQuadCurveToPoint:CGPointMake(padding, midY* 2 - 84) controlPoint:CGPointMake(midX * 2 - 60, midY * 2 - 100)];
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = 4.f;
    animation.delegate = self;
    animation.path = bezierPath.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:@"position.y"];
    [self scaleLargeAnimation];
}

-(void)scaleLargeAnimation{
    CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.7f;
    scaleAnimation.fromValue = @(0.3);
    scaleAnimation.toValue = @(1.5);
    scaleAnimation.repeatCount = 1.f;
    scaleAnimation.delegate = self;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    [scaleAnimation setValue:@"transform.scale.large" forKey:@"KAnimationKey"];
    [self.masonryView.layer addAnimation:scaleAnimation forKey:@"transform.scale.large"];
}

-(void)scaleDiminishAnimation{
    CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 1.f;
    scaleAnimation.fromValue = @(1.5);
    scaleAnimation.toValue = @(0.3);
    scaleAnimation.repeatCount = 1.f;
    scaleAnimation.delegate = self;
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    [scaleAnimation setValue:@"transform.scale.diminish" forKey:@"KAnimationKey"];
    [self.masonryView.layer addAnimation:scaleAnimation forKey:@"transform.scale.diminish"];
    
}

-(void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        if ([anim.keyPath isEqualToString:@"transform.scale"]) {
            if ([[anim valueForKey:@"KAnimationKey"] isEqualToString:@"transform.scale.large"]) {
                [self scaleDiminishAnimation];
            }else if ([[anim valueForKey:@"KAnimationKey"] isEqualToString:@"transform.scale.diminish"]){
                [self scaleLargeAnimation];
            }
        }else{
            [self.masonryView.layer removeAllAnimations];
            __weak  typeof(self)weakSelf = self;
            __block CGFloat padding = 20.f;
            [self.masonryView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(40, 40));
                make.left.mas_equalTo(weakSelf.view.mas_left).with.offset(padding);
                make.bottom.mas_equalTo(weakSelf.view.mas_bottom).with.offset(-64);
            }];
        }
    }
}


-(void)gestureEvents{
    NSLog(@"gestureEvents - \n");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1f];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    for (int i = 0; i < self.layers.count; i++) {
        if (i==0) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        CAShapeLayer * layer = (CAShapeLayer*)self.layers[i];
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
        if (i == self.layers.count -1) {
            dispatch_semaphore_signal(semaphore);
        }
    }
    [self.masonryView removeFromSuperview];
    self.masonryView = nil;
    [self.layers removeAllObjects];
    [self initialzieCurvePath];
    [self createCurveBezierPath];
}

-(void)viewDidLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
