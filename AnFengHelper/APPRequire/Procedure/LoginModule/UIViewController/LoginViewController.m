//
//  LoginViewController.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "LoginViewController.h"
#import "RootViewController.h"

@interface LoginViewController ()
@property(nonatomic,strong)RootViewController * rootViewController;
@end

@implementation LoginViewController

-(RootViewController *)rootViewController
{
    _rootViewController = ({
        if (!_rootViewController) {
            _rootViewController  = [[RootViewController alloc]init];
        }
        _rootViewController;
    });
    return _rootViewController;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:self.rootViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
