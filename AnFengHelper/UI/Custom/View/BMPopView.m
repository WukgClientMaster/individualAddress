//
//  PopoverView.m
//  Embark
//
//  Created by Oliver Rickard on 20/08/2012.
//
//

#import "BMPopView.h"
#import <QuartzCore/QuartzCore.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.height
#define kScreenHeight  [UIScreen mainScreen].bounds.size.width
@implementation BMPopView

+(BMPopView *)shareInstance
{
    static BMPopView *_sharedBMPopView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedBMPopView = [[BMPopView alloc]init];
    });
    return _sharedBMPopView;
}


- (id)init
{
    self = [super init];
    if (self) {
        //[UIColor colorWithWhite:0.0f alpha:0.5f]
        self.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:0.3f];
        self.bgColor =  self.backgroundColor;
        self.isFullScreen = NO;
        self.contentView = nil;
    }
    return self;
}

- (void)dealloc {
    
    self.contentView = nil;

}


+ (BMPopView *)showWithContentView:(UIView *)cView delegate:(id<BMPopViewDelegate>)delegate {
    BMPopView *popoverView = [BMPopView shareInstance];
    [popoverView showWithContentView:cView];
    popoverView.delegate = delegate;
    return popoverView;
}

- (void)showWithContentView:(UIView *)cView delegate:(id<BMPopViewDelegate>)delegate {

    BMPopView *popoverView = [BMPopView shareInstance];
    [popoverView showWithContentView:cView];
    popoverView.delegate = delegate;
}

- (void)showWithContentView:(UIView *)cView {
    
    self.contentView = cView;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if(!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    UIView *topView = [[window subviews] objectAtIndex:0];
    
    
    CGRect topViewBounds = topView.bounds;
    
    if (!_customFrame)
    {
        _contentView.center = topView.center;
    }
    else
    {
        //_contentView 自定义位置
    }
    [self addSubview:_contentView];
    
    self.frame = topViewBounds;
    
    [self setNeedsDisplay];
    
    [window addSubview:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
    
    self.alpha = 0.f;
    self.contentView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);

    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.f;
        self.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
        self.contentView.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformIdentity;
            self.contentView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}
#pragma mark -
#pragma mark 动画
+ (BMPopView *)showWithContentView:(UIView *)cView withAnimation:(BMPopViewAnimation)myAnimation delegate:(id<BMPopViewDelegate>)delegate
{ 
    BMPopView *popoverView = [BMPopView shareInstance];
    [popoverView showWithContentView:cView withAnimation:myAnimation];
    popoverView.delegate = delegate;
    return popoverView;
}

- (void)showWithContentView:(UIView *)cView withAnimation:(BMPopViewAnimation)myAnimation delegate:(id<BMPopViewDelegate>)delegate
{
    BMPopView *popoverView = [BMPopView shareInstance];
    [popoverView showWithContentView:cView withAnimation:myAnimation];
    popoverView.delegate = delegate;
}

- (void)showWithContentView:(UIView *)cView withAnimation:(BMPopViewAnimation)myAnimation
{
    _animation = myAnimation;
    self.contentView = cView;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if(!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    UIView *topView = [[window subviews] objectAtIndex:0];

    CGRect topViewBounds = topView.bounds;
    if (!_customFrame)
    {
        _contentView.center = topView.center;
    }
    else
    {
        _contentView.frame = _boxFrame;
    }
    
    NSLog(@"%@",NSStringFromCGRect(self.contentView.frame));
    self.frame = topViewBounds;
    [self addSubview:_contentView];
    
    
    [self setNeedsDisplay];
    
    [window addSubview:self];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tap];
    
    self.userInteractionEnabled = YES;
    
    self.alpha = 0.f;
    
    switch (myAnimation) {
        case BMPopViewAnimationTransForm:
        {
            self.alpha = 0.f;
            self.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alpha = 1.f;
                self.contentView.transform = CGAffineTransformMakeScale(1.05, 1.05);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.alpha = 1.f;
                    self.contentView.transform = CGAffineTransformMakeScale(1, 1);
                    
                } completion:^(BOOL finished) {
                }];

            }];

        }
            break;
        case BMPopViewAnimationShowFromBottom:
        {
            self.contentView.center = CGPointMake(kScreenWidth/2- _offset.left +_offset.right , kScreenHeight - _offset.bottom + _offset.top);
            [UIView animateWithDuration:0.1f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alpha = 1.f;
                self.contentView.center = CGPointMake(kScreenWidth/2- _offset.left +_offset.right , kScreenHeight - _contentView.frame.size.height/2 - _offset.bottom + _offset.top);
            } completion:^(BOOL finished) {
            }];

        }
            break;
        case BMPopViewAnimationShowFromRight:
        {
            self.contentView.center = CGPointMake(kScreenWidth - _offset.left +_offset.right ,kScreenHeight - _contentView.frame.size.height - _offset.bottom + _offset.top);
            [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alpha = 1.f;
                self.contentView.center = CGPointMake(kScreenWidth/2- _offset.left +_offset.right , kScreenHeight - _contentView.frame.size.height /2- _offset.bottom + _offset.top);
            } completion:^(BOOL finished) {
            }];
            
        }
            break;
        case BMPopViewAnimationShowBegainTop:
        {
            CGRect frame = self.contentView.frame;
            self.contentView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
            [UIView animateWithDuration:0.35f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alpha = 1.f;
                self.contentView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);

            } completion:^(BOOL finished) {
            }];
            
        }
            break;
        default:
        {
            self.alpha = 1.f;
        }
            break;
    }
   
}


#pragma mark - User Interaction

- (void)tapped:(UITapGestureRecognizer *)tap {
    
    CGPoint point = [tap locationInView:_contentView];
    
    BOOL found = NO;

    if(!found && CGRectContainsPoint(_contentView.bounds, point)) {
        found = YES;
    }
    
    if(!found && _canDisMiss) {
        [self dismiss];
    }
    
}

- (void)dismiss {
    [self.contentView endEditing:YES];
    switch (_animation) {
        case BMPopViewAnimationTransForm:
        {
            [UIView animateWithDuration:0.2f animations:^{
                self.alpha = 0.1f;
                self.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            } completion:^(BOOL finished) {
                [self.contentView removeFromSuperview];

                [self removeFromSuperview];
                
                if(self.delegate && [self.delegate respondsToSelector:@selector(popViewDidDismiss:)]) {
                    [_delegate popViewDidDismiss:self];
                }
                
            }];

        }
            break;
        case BMPopViewAnimationShowFromBottom:
        {
            [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alpha = 0.1f;
                self.contentView.center = CGPointMake(kScreenWidth/2- _offset.left +_offset.right , kScreenHeight + _contentView.frame.size.height/2);
            } completion:^(BOOL finished) {
                [self.contentView removeFromSuperview];

                [self removeFromSuperview];
                if(self.delegate && [self.delegate respondsToSelector:@selector(popViewDidDismiss:)]) {
                    [_delegate popViewDidDismiss:self];
                }
            }];
            
        }
            break;
        case BMPopViewAnimationShowFromRight:
        {
            [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alpha = 0.1f;
                self.contentView.center = CGPointMake(kScreenWidth/2- _offset.left +_offset.right , kScreenHeight - _contentView.frame.size.height /2- _offset.bottom + _offset.top);
            } completion:^(BOOL finished) {
                [self.contentView removeFromSuperview];

                [self removeFromSuperview];
                if(self.delegate && [self.delegate respondsToSelector:@selector(popViewDidDismiss:)]) {
                    [_delegate popViewDidDismiss:self];
                }
            }];
            
        }
            break;
        case BMPopViewAnimationShowBegainTop:
        {
            [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alpha = 0.1f;
                self.contentView.center = CGPointMake(kScreenWidth/2- _offset.left +_offset.right ,
                                                      kScreenHeight - _contentView.frame.size.height /2- _offset.bottom + _offset.top);
            } completion:^(BOOL finished) {
                [self.contentView removeFromSuperview];
                
                [self removeFromSuperview];
                if(self.delegate && [self.delegate respondsToSelector:@selector(popViewDidDismiss:)]) {
                    [_delegate popViewDidDismiss:self];
                }
            }];

            
        }
            break;
        default:
        {
            self.alpha = 0.1;
            [self.contentView removeFromSuperview];

            [self removeFromSuperview];
            if(self.delegate && [self.delegate respondsToSelector:@selector(popViewDidDismiss:)]) {
                [_delegate popViewDidDismiss:self];
            }
        }
            break;
    }
    _animation = BMPopViewAnimationNone;
    
    /**
     *  @author HYM, 15-02-26 19:02:35
     *
     *  重置
     */
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.customFrame = NO;
    self.offset = UIEdgeInsetsZero;
    self.isFullScreen = NO;
    self.canDisMiss = YES;
    self.boxFrame = CGRectZero;
    
}


- (void)drawRect:(CGRect)rect
{

    CGRect frame;
    if(_isFullScreen)
    {
        frame = self.frame;
    }
    else
    {
        frame = _boxFrame;
    }
    
    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame);
    
    float xMax = CGRectGetMaxX(frame);
    float yMax = CGRectGetMaxY(frame);
    
    float radius = 0; //Radius of the curvature.
    
    float cpOffset = 0; //Control Point Offset.  Modifies how "curved" the corners are.
    
    
    /*
     LT2            RT1
     LT1⌜⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⌝RT2
     |               |
     |    popover    |
     |               |
     LB2⌞_______________⌟RB1
     LB1           RB2
     
     Traverse rectangle in clockwise order, starting at LT1
     L = Left
     R = Right
     T = Top
     B = Bottom
     1,2 = order of traversal for any given corner
     
     */
    
    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
    [popoverPath moveToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + radius)];//LT1
    [popoverPath addCurveToPoint:CGPointMake(xMin + radius, yMin) controlPoint1:CGPointMake(xMin, yMin + radius - cpOffset) controlPoint2:CGPointMake(xMin + radius - cpOffset, yMin)];//LT2
    
    [popoverPath addLineToPoint:CGPointMake(xMax - radius, yMin)];//RT1
    [popoverPath addCurveToPoint:CGPointMake(xMax, yMin + radius) controlPoint1:CGPointMake(xMax - radius + cpOffset, yMin) controlPoint2:CGPointMake(xMax, yMin + radius - cpOffset)];//RT2
    [popoverPath addLineToPoint:CGPointMake(xMax, yMax - radius)];//RB1
    [popoverPath addCurveToPoint:CGPointMake(xMax - radius, yMax) controlPoint1:CGPointMake(xMax, yMax - radius + cpOffset) controlPoint2:CGPointMake(xMax - radius + cpOffset, yMax)];//RB2
    

    [popoverPath addLineToPoint:CGPointMake(xMin + radius, yMax)];//LB1
    [popoverPath addCurveToPoint:CGPointMake(xMin, yMax - radius) controlPoint1:CGPointMake(xMin + radius - cpOffset, yMax) controlPoint2:CGPointMake(xMin, yMax - radius + cpOffset)];//LB2
    [popoverPath closePath];
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Shadow Declarations
    UIColor* shadow = [UIColor colorWithWhite:0.f alpha:1.0];
    CGSize shadowOffset = CGSizeMake(0, 1);
    CGFloat shadowBlurRadius = 10;
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)_bgColor.CGColor,
                               (id)_bgColor.CGColor, nil];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientColors, gradientLocations);
    
    
    //These floats are the top and bottom offsets for the gradient drawing so the drawing includes the arrows.
    float bottomOffset = 0;
    float topOffset = 0;
    
    //Draw the actual gradient and shadow.
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    [popoverPath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame) - topOffset), CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) + bottomOffset), 0);
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
@end
