//
//  AnFengHelperController.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "AnFengHelperController.h"
#import "LoginViewController.h"
#import "RechargeViewController.h"
#import "AccountCenterViewController.h"
#import "GameHelperViewController.h"
#import "MoreViewController.h"

@interface AnFengHelperController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@end

@implementation AnFengHelperController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.navigationBar.translucent =  NO;
    self.navigationBar.barStyle  = UIBaselineAdjustmentNone;
    [[UINavigationBar appearance]setExclusiveTouch:YES];
    [[UINavigationBar appearance]setBarTintColor:AdapterColor(230, 230, 230)];
    NSShadow * shadow = [[NSShadow alloc]init];
    shadow.shadowColor =  AdapterColor(220, 220, 220);
    shadow.shadowOffset = CGSizeMake(1.0, 1.0);
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f],NSShadowAttributeName: shadow,NSForegroundColorAttributeName:[UIColor blackColor]}];
}

static bool pushConditionJudeMent(UIViewController * viewController);
static bool pushConditionJudeMent(UIViewController * viewController)
{
    if ([viewController isKindOfClass:[LoginViewController class]]
        ||[viewController isKindOfClass:[RechargeViewController class]]
        ||[viewController isKindOfClass:[AccountCenterViewController class]]
        ||[viewController isKindOfClass:[GameHelperViewController class]]
        ||[viewController isKindOfClass:[MoreViewController class]]) {
        return YES;
    }
    return NO;
}

#pragma mark -UINavigationControllerDelegate
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.navigationController.interactivePopGestureRecognizer.enabled = YES;
    viewController.navigationController.interactivePopGestureRecognizer.delegate = self;
    if (pushConditionJudeMent(viewController)) {
        viewController.hidesBottomBarWhenPushed = NO;
    }else viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{

}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{

}
- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController;
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController;
{
    return UIInterfaceOrientationPortrait;
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count ==1) {
        return NO;
    }
    else return YES;
}
@end
