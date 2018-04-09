//
//  AnFengTabBarController.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "AnFengTabBarController.h"
#import "LoginViewController.h"
#import "RechargeViewController.h"
#import "AccountCenterViewController.h"
#import "GameHelperViewController.h"
#import "MoreViewController.h"
#import "AnFengHelperController.h"

static AnFengTabBarController * _anFengTabBarController = nil;
static dispatch_once_t once;
@interface AnFengTabBarController ()<UITabBarControllerDelegate>
@end

@implementation AnFengTabBarController

+(instancetype)shareInstance;
{
    @synchronized(self) {
            dispatch_once(&once, ^{
             if (!_anFengTabBarController) {
                 _anFengTabBarController  = [[AnFengTabBarController alloc]init];
                 _anFengTabBarController.delegate = (id)self;
             }
         });
    }
    return _anFengTabBarController;
}
-(void)initSubControllers
{
    NSArray * selectedImgs =@[@"couponSelected",@"discoverSelected",@"homePageSeleced",@"myCenterSelected",@"shoppingSelected",@"shoppingSelected"];
    NSArray * unSelectedImgs = @[@"couponUnSelected",@"discoverUnSelected",@"homePageUnSeleced",@"myCenterUnSelected",@"shoppingUnSelected",@"couponUnSelected"];
    LoginViewController * loginViewController = [[LoginViewController alloc]init];
    loginViewController.title = @"登录";
    loginViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"登录" image:[UIImage imageNamed:unSelectedImgs[0]] selectedImage:[UIImage imageNamed:selectedImgs[0]]];
    AnFengHelperController * loginNavigationController = [[AnFengHelperController alloc]initWithRootViewController:loginViewController];
    //
    RechargeViewController * rechargeViewController = [[RechargeViewController alloc]init];
    rechargeViewController.title = @"点卡充值";
    rechargeViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"点卡充值" image:[UIImage imageNamed:unSelectedImgs[1]] selectedImage:[UIImage imageNamed:selectedImgs[1]]];
    AnFengHelperController * rechargeNavigationControlller = [[AnFengHelperController alloc]initWithRootViewController:rechargeViewController];
    //
    AccountCenterViewController * accountCenterController = [[AccountCenterViewController alloc]init];
    accountCenterController.title = @"账号中心";
    accountCenterController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"账号中心" image:[UIImage imageNamed:unSelectedImgs[2]] selectedImage:[UIImage imageNamed:selectedImgs[2]]];
    AnFengHelperController * accountNavigationController =[[AnFengHelperController alloc]initWithRootViewController:accountCenterController];
    //
    GameHelperViewController * gameHlepViewController = [[GameHelperViewController alloc]init];
    gameHlepViewController.title = @"游戏助手";
    gameHlepViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"游戏助手" image:[UIImage imageNamed:unSelectedImgs[3]] selectedImage:[UIImage imageNamed:selectedImgs[3]]];
    AnFengHelperController * gameHelpNavigationController = [[AnFengHelperController alloc]initWithRootViewController:gameHlepViewController];
    //
    MoreViewController * moreViewController = [[MoreViewController alloc]init];
    moreViewController.title = @"个性化设置";
    moreViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"更多" image:[UIImage imageNamed:unSelectedImgs[4]] selectedImage:[UIImage imageNamed:selectedImgs[4]]];
    AnFengHelperController * moreNavigationController = [[AnFengHelperController alloc]initWithRootViewController:moreViewController];
    NSArray * items = @[loginNavigationController,rechargeNavigationControlller,accountNavigationController,gameHelpNavigationController,moreNavigationController];
    self.viewControllers = items;
    self.selectedIndex = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubControllers];
     self.tabBar.barStyle = UIBarStyleBlack;
     self.tabBar.barTintColor = AdapterColor(230, 230, 230);
}

#pragma mark - UITabBarViewController Delegate 
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return  YES;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
   
}
- (UIInterfaceOrientationMask)tabBarControllerSupportedInterfaceOrientations:(UITabBarController *)tabBarController
{
    return  UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
