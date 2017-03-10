//
//  RootViewController.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/9.
//  Copyright © 2017年 AnFen. All rights reserved.
//
#import "RootViewController.h"

@interface RootViewController ()
@property(nonatomic,strong) UILabel * label;
@end

@implementation RootViewController

- (void)viewDidLoad {
      [super viewDidLoad];
      self.view.backgroundColor = [UIColor brownColor];
    _label = [[UILabel alloc]init];
    _label.frame = CGRectMake(0, 10, 100, 65);
    _label.backgroundColor = [UIColor redColor];
    [self.view addSubview:_label];
    __NSLogRect(self.view.frame);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
