//
//  OOBaseTabBarController.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/5/6.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "OOBaseTabBarController.h"

@interface OOBaseTabBarController()<UITabBarControllerDelegate>

@end
@implementation OOBaseTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        }
    return self;
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
{
    self.selectedViewController = viewController;
}

- (UIInterfaceOrientation)tabBarControllerPreferredInterfaceOrientationForPresentation:(UITabBarController *)tabBarController
{
    return tabBarController.interfaceOrientation;
}

@end
