//
//  TX_WKG_Photo_PasterContentView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Photo_PasterContentView.h"
#import <GLKit/GLKit.h>

#define kDragCloseBtnTag        1
#define kDragFlipBtnTag         2
#define kDragScaleBtnTag        3
#define kDragRotationBtnTag     4

#define kDefaultDragViewWidth   80
#define kDefaultDragIconSize    30

@interface TX_WKG_Photo_PasterContentView ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) float ratio;
@property (nonatomic, assign) BOOL currentTooBarHidden;
@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, assign) CGPoint imageOffset;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *rotationBtn;
@property (nonatomic, strong) UIButton *scaleBtn;

@end

@implementation TX_WKG_Photo_PasterContentView
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    size_t width = CGImageGetWidth(image.CGImage);
    size_t height = CGImageGetHeight(image.CGImage);
    _ratio = ((float)width)/((float)height);
    width = kDefaultDragViewWidth;
    height = width / _ratio;
    if (self = [self initWithFrame:frame]) {
        _image = image;
        [self setupUIWithSize:CGSizeMake(width, height)];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)setupUIWithSize:(CGSize)size
{
    // 边框
    _borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _borderView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _borderView.layer.borderColor = [UIColor whiteColor].CGColor;
    _borderView.userInteractionEnabled = NO;
    [self addSubview:_borderView];
    _borderView.layer.borderColor = [UIColor whiteColor].CGColor;
    _borderView.layer.borderWidth = 1.0f;
    
    // 图片
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _imageView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGestureImageView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onImageDrag:)];
    [_imageView setImage:_image];
    [_imageView addGestureRecognizer:panGestureImageView];
    [self addSubview:_imageView];
    
    // 关闭
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_imageView.center.x-_imageView.frame.size.width/2 - kDefaultDragIconSize/2, _imageView.center.y-_imageView.frame.size.height/2-kDefaultDragIconSize/2, kDefaultDragIconSize, kDefaultDragIconSize)];
    [_closeBtn setImage:[UIImage imageNamed:@"tx_wkg_photo_text_cancel"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_closeBtn setTag:kDragCloseBtnTag];
    [self addSubview:_closeBtn];
    // 旋转
    _rotationBtn = [[UIButton alloc] initWithFrame:CGRectMake(_imageView.frame.size.width/2+ _imageView.center.x -kDefaultDragIconSize/2 , _imageView.center.y-_imageView.frame.size.height/2 -kDefaultDragIconSize/2, kDefaultDragIconSize, kDefaultDragIconSize)];
    UIPanGestureRecognizer *panGestureRotate = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onButtonRotate:)];
    [_rotationBtn setImage:[UIImage imageNamed:@"tx_wkg_photo_text_rotate"] forState:UIControlStateNormal];
    [_rotationBtn setTag:kDragRotationBtnTag];
    [_rotationBtn addGestureRecognizer:panGestureRotate];
    [self addSubview:_rotationBtn];
    // 缩放
    _scaleBtn = [[UIButton alloc] initWithFrame:CGRectMake(_imageView.frame.size.width/2+_imageView.center.x - kDefaultDragIconSize/2, _imageView.frame.size.height/2+_imageView.center.y - kDefaultDragIconSize/2, kDefaultDragIconSize, kDefaultDragIconSize)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onButtonScale:)];
    [_scaleBtn setImage:[UIImage imageNamed:@"tx_wkg_photo_text_scale"] forState:UIControlStateNormal];
    [_scaleBtn setTag:kDragScaleBtnTag];
    [_scaleBtn addGestureRecognizer:panGesture];
    [self addSubview:_scaleBtn];
}
-(void)setPasterNode:(TX_WKG_Paster_Node *)pasterNode{
    _pasterNode = pasterNode;
}
#pragma mark - Events
- (void)buttonTapped:(UIButton *)sender{
    switch (sender.tag) {
        case kDragCloseBtnTag:
            [self removeFromSuperview];
            if (self.pasterContentClickCallback) {
                self.pasterContentClickCallback(@"关闭");
            }
            break;
        case kDragScaleBtnTag:
            break;
        case kDragFlipBtnTag:
            break;
        case kDragRotationBtnTag:
            break;
        default:
            break;
    }
}

- (void)onImageDrag:(UIPanGestureRecognizer *)gesture{
    CGPoint gestureOrigin = [gesture locationInView:self.superview];
    if (!CGRectContainsPoint(self.superview.frame, CGPointMake(gestureOrigin.x, gestureOrigin.y+ CGRectGetMinY(self.superview.frame))))return;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            _currentTooBarHidden = [self isToolBarHidden];
            _imageOffset = CGPointMake(gestureOrigin.x-self.center.x, gestureOrigin.y-self.center.y);
            break;
        case UIGestureRecognizerStateChanged:
            [self hideToolBar];
            self.center = CGPointMake(gestureOrigin.x-_imageOffset.x, gestureOrigin.y-_imageOffset.y);
            break;
        case UIGestureRecognizerStateEnded:
            if (!_currentTooBarHidden) [self showToolBar];
            _imageOffset = CGPointZero;
            break;
            
        default:
            _imageOffset = CGPointZero;
            break;
    }
}

- (void)onButtonScale:(UIPanGestureRecognizer *)gesture
{
    CGPoint gestureOrigin = [gesture locationInView:self];
    
    // 修正位置
    gestureOrigin.x = gestureOrigin.x - kDefaultDragIconSize/2;
    gestureOrigin.y = gestureOrigin.y - kDefaultDragIconSize/2;
    
    CGFloat deltaX = gestureOrigin.x - _imageView.center.x;
    CGFloat deltaY = gestureOrigin.y - _imageView.center.y;
    
    CGFloat scaleX = deltaX/(_imageView.frame.size.width/2);
    CGFloat scaleY = deltaY/(_imageView.frame.size.height/2);
    scaleX = MAX(scaleX, 0);
    scaleY = MAX(scaleY, 0);
    
    if (scaleX < 1.0f && _imageView.frame.size.width*scaleX <= kDefaultDragIconSize) {
        scaleX = kDefaultDragIconSize/_imageView.frame.size.width;
    }
    
    if (scaleY < 1.0f && _imageView.frame.size.height*scaleY <= kDefaultDragIconSize) {
        scaleY = kDefaultDragIconSize/_imageView.frame.size.height;
    }
    
    // 等比缩放
    //CGFloat scale = MAX(MIN(scaleX, scaleY), 0.0);
    
    // imageView
    _imageView.transform = CGAffineTransformScale(_imageView.transform, scaleX, scaleY);
    // closeBtn frame
    _closeBtn.frame = CGRectMake(_imageView.center.x-_imageView.frame.size.width/2 - kDefaultDragIconSize/2, _imageView.center.y-_imageView.frame.size.height/2-kDefaultDragIconSize/2, kDefaultDragIconSize, kDefaultDragIconSize);
    
    // rotationBtn frame
    _rotationBtn.frame = CGRectMake(_imageView.frame.size.width/2+ _imageView.center.x -kDefaultDragIconSize/2 , _imageView.center.y-_imageView.frame.size.height/2 -kDefaultDragIconSize/2, kDefaultDragIconSize, kDefaultDragIconSize);
    // scaleBtn frame
    _scaleBtn.frame = CGRectMake(_imageView.frame.size.width/2+_imageView.center.x - kDefaultDragIconSize/2, _imageView.frame.size.height/2+_imageView.center.y - kDefaultDragIconSize/2, kDefaultDragIconSize, kDefaultDragIconSize);
    // borderView
    _borderView.frame = _imageView.frame;
}

- (void)onButtonRotate:(UIPanGestureRecognizer *)gesture
{
    CGPoint gestureOrigin = [gesture locationInView:self];
    CGPoint center = _imageView.center;
    
    GLKVector2 originVec = GLKVector2Normalize(GLKVector2Make(_rotationBtn.center.x - center.x, _rotationBtn.center.y - center.y));
    GLKVector2 newVec = GLKVector2Normalize(GLKVector2Make(gestureOrigin.x - center.x, gestureOrigin.y - center.y));
    
    CGFloat cos = GLKVector2DotProduct(originVec, newVec);
    CGFloat rad = MAX(MIN(acos(cos), 2*M_PI), 0);
    
    if (newVec.x > originVec.x) {
        rad = rad;
    }else {
        rad = -rad;
    }
    self.transform = CGAffineTransformRotate(self.transform, rad);
    
    //    NSLog(@"%f", rad);
}

#pragma mark - Override
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    NSArray *subviews = [[self.subviews reverseObjectEnumerator] allObjects];
    for (UIView *view in subviews) {
        if (view.userInteractionEnabled && CGRectContainsPoint(view.frame, point)) {
            return view;
        }
    }
    return nil;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event{
    return YES;
}

#pragma mark - PublicMethod
- (BOOL)isToolBarHidden{
    return _scaleBtn.hidden && _rotationBtn.hidden && _closeBtn.hidden;
}

- (void)showToolBar{
    _rotationBtn.hidden = NO;
    _closeBtn.hidden = NO;
    _scaleBtn.hidden = NO;
    _borderView.layer.borderWidth = 1.0f;
}

- (void)hideToolBar{
    _rotationBtn.hidden = YES;
    _closeBtn.hidden = YES;
    _scaleBtn.hidden = YES;
    _borderView.layer.borderWidth = 0.0f;
}

- (instancetype)copyWithScaleFactor:(CGFloat)factor relativedView:(UIView *)imageView{
    TX_WKG_Photo_PasterContentView *drag = [[[self class] alloc] initWithFrame:[UIScreen mainScreen].bounds image:self.image];
    // 旋转
    drag.transform = self.transform;
    // 缩放
    drag.imageView.transform = CGAffineTransformScale(self.imageView.transform, 1.0f/factor, 1.0f/factor);
    // 平移 1、进行坐标系转换 2、设置坐标
    CGFloat centerX = self.center.x - imageView.frame.origin.x;
    CGFloat centerY = self.center.y - imageView.frame.origin.y + heightEx(45.f);
    drag.center = CGPointMake(centerX/factor, centerY/factor);
    return drag;
}

@end
