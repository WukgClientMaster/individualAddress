//
//  OOBaseSplashController.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/5/6.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "OOBaseSplashController.h"
#import "OOGuideViewController.h"
#import "OOBaseViewContrlManager.h"
#import "AppDelegate.h"
#import "NSUserDefaults+NSKeyedArchiver.h"

@interface  OOBaseSplashController()
@property (strong, nonatomic) OOGuideViewController * guideController;
@property (strong, nonatomic) OOBaseViewContrlManager * ooBaseViewControllerManager;

@end
@implementation OOBaseSplashController
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
#pragma mark ViewController LifeCycle
-(void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    id  launch = [[NSUserDefaults standardUserDefaults]unarchiveAnyObjectForKey:@"launch"];
    if (!launch)
    {
        [[[UIApplication sharedApplication]delegate]window].rootViewController = self.guideController;
        [[NSUserDefaults standardUserDefaults]archiveAnyObject:@"launch" forKey:@"launch"];
    }
    else
    {
        [[[UIApplication sharedApplication]delegate]window].rootViewController = (id)[[OOBaseViewContrlManager sharedInstance]loadControllerWithType];
    }
}
#pragma mark ViewController AsynRequestData

#pragma mark ViewController Algorithm Processor

#pragma mark ViewController Initialize SubObjectView
#pragma mark --viewController getter methods
-(OOGuideViewController *)guideController
{
    _guideController = ({
        if (!_guideController) {
            _guideController  = [[OOGuideViewController alloc]init];
        }
        _guideController;
    });
    return _guideController;
}
#pragma mark Possess  Delegate ViewController（委托代理者）
#pragma mark IBOutlet Action ViewController
#pragma mark Other Method
@end
