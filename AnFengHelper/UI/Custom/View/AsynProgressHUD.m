//
//  AsynProgressHUD.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/14.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "AsynProgressHUD.h"
#import "AsynProgressLoadingView.h"
#import "AsynProgressHUDConfigure.h"

static AsynProgressHUD *_indicatorInstance;

typedef enum : NSUInteger {
    SMProgressHUDStateStatic,
    SMProgressHUDStateLoading,
}SMProgressHUDState;

@interface AsynProgressHUD ()
{
    NSInteger loadingCount;
    SMProgressHUDState state;
    UIWindow *_window;
    UIView *maskLayer;
    NSOperationQueue *queue;
}
@property (strong, nonatomic) AsynProgressLoadingView *loadingView;
@end
@implementation AsynProgressHUD
+(instancetype)shareInstance
{
    if (nil == _indicatorInstance) {
        _indicatorInstance = [[super allocWithZone:NULL] init];
    }
    return  _indicatorInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _indicatorInstance = [super allocWithZone:zone];
    });
    return _indicatorInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        state = SMProgressHUDStateStatic;
        
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_window setBackgroundColor:[UIColor clearColor]];
        [_window setWindowLevel:UIWindowLevelAlert+100];
        [_window makeKeyAndVisible];
        [_window setHidden:YES];
        
         maskLayer = [[UIView alloc] initWithFrame:_window.bounds];
        [maskLayer setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        [maskLayer setAlpha:0];
        [_window addSubview:maskLayer];
        queue = [[NSOperationQueue alloc] init];
    }
    return self;
}
#pragma mark 获取loadingview
- (AsynProgressLoadingView *)loadingView
{
    if (!_loadingView)
    {
        _loadingView = [[AsynProgressLoadingView alloc] initWithFrame:CGRectMake(0, 0, kSMProgressHUDContentWidth, kSMProgressHUDContentHeight)];
        [_loadingView setCenter:CGPointMake(kSMProgressWindowWidth/2, kSMProgressWindowHeight/2)];
    }
    [_loadingView setAlpha:0];
    return _loadingView;
}

- (void)showLoading
{
    return [self showLoadingWithTip:nil];
}

- (void)showLoadingWithTip:(NSString *)tip
{
    [_window setHidden:NO];
    [_window addSubview:self.loadingView];
    [_window setFrame:CGRectMake(0, 0, kSMProgressWindowWidth, kSMProgressWindowHeight)];
    state = SMProgressHUDStateLoading;
    [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
        [maskLayer setAlpha:1];
        [_loadingView setAlpha:1];
    } completion:^(BOOL finished) {
        if (finished)
        {
        }
    }];
}

- (void)dismissLoadingView
{
    state = SMProgressHUDStateStatic;
    [_window setHidden:YES];
    [UIView animateWithDuration:kSMProgressHUDAnimationDuration animations:^{
        [maskLayer setAlpha:0];
    } completion:^(BOOL finished) {
        [_window setHidden:YES];
        [_loadingView removeFromSuperview];
    }];
    
}
@end
