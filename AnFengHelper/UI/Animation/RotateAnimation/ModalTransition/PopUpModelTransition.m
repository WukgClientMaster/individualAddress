//
//  PopUpModelTransition.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/19.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "PopUpModelTransition.h"
static const CGFloat  kDefaultAnimationDuration = .5f;

@interface PopUpModelTransition()
// Dimmed background
@property (nonatomic, strong) UIView *dimmedBackgroundView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation PopUpModelTransition


#pragma mark - Constructor
- (instancetype)init
{
    if (self = [super init])
    {
        // Add dimmed background
        self.dimmedBackgroundView = [[UIView alloc] init];
        self.dimmedBackgroundView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        self.dimmedBackgroundView.backgroundColor = [UIColor blackColor];
        // Tap gesture
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmedBackgroundTapped:)];
        [self.dimmedBackgroundView addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

#pragma mark - Transition methods
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kDefaultAnimationDuration;
}

- (void)presentViewControllerWithContext:(id <UIViewControllerContextTransitioning>)transitionContext animated:(BOOL)animated
{
    UIView *container = transitionContext.containerView;
    
    // Update dimmed background frame
    self.dimmedBackgroundView.frame = container.bounds;
    
    // Display centered
    self.presentedViewController.view.center = container.center;
    
    // Take orientation into account
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformRotate(transform, [ModalTransition rotationAngle]);
    self.presentedViewController.view.transform = transform;
    [self.presentedViewController.view setNeedsDisplay];
    
    // Animate
    if (animated)
    {
        NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
        // Prepare animation
        self.presentedViewController.view.transform = CGAffineTransformScale(transform, 0.0f, 0.0f);
        self.dimmedBackgroundView.alpha = 0.0f;
        // Add subviews to container
        [container addSubview:self.dimmedBackgroundView];
        
        NSLog(@"presentedViewController.view.frame = %@",NSStringFromCGRect(self.presentedViewController.view.frame));
        [container addSubview:self.presentedViewController.view];
        // Dimmed background fading
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             // Fade in
                             self.dimmedBackgroundView.alpha = 0.4f;
                         }];
        // The view will grow a bit bigger than its final size
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             // Scale to normal size
                             self.presentedViewController.view.transform = CGAffineTransformScale(transform, 1.f, 1.f);
                         }
                         completion:^(BOOL finished) {
                             // Complete transition
                             [transitionContext completeTransition:YES];
                         }];
    }
    else
    {
        // Prepare dimmed background
        self.dimmedBackgroundView.alpha = 0.4f;
        // Add subviews to container
        [container addSubview:self.dimmedBackgroundView];
        [container addSubview:self.presentedViewController.view];
        // Complete transition
        [transitionContext completeTransition:YES];
    }
}

- (void)dismissViewControllerWithContext:(id <UIViewControllerContextTransitioning>)transitionContext animated:(BOOL)animated
{
    // Dismiss view controller with or withour animation
    if (animated)
    {
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             // Scale to nothing
                             self.presentedViewController.view.transform = CGAffineTransformScale(self.presentedViewController.view.transform, 0.0f, 0.0f);
                             // Fade out
                             self.dimmedBackgroundView.alpha = 0.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             [self clearContext:transitionContext];
                         }];
    }
    else
    {
        [self clearContext:transitionContext];
    }
}

#pragma mark - Gestures
- (void)dimmedBackgroundTapped:(UIGestureRecognizer *)gesture
{
     __block ModalTransition *blockSelf = self;
    [blockSelf.presentedViewController dismissViewControllerAnimated:YES completion:^{
        blockSelf.presentedViewController = nil;
    }];
}

#pragma mark - Utils
- (void)clearContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    // Remove dimmed background
    [self.dimmedBackgroundView removeFromSuperview];
    // Remove presented view controller
    [self.presentedViewController.view removeFromSuperview];
    [transitionContext completeTransition:YES];
}
@end
