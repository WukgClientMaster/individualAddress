//
//  TESTingViewController.m
//  AnFengHelper
//
//  Created by 智享城市iOS开发 on 2018/4/7.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "TESTingViewController.h"

@interface TESTingViewController ()

@end

@implementation TESTingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = AdapterColor(247, 247, 247);
    // Do any additional setup after loading the view.
}

-(void)setConfigTitle:(NSString *)configTitle{
    NSAssert(configTitle, @"title is not nil");
    _configTitle = configTitle;
    self.title = _configTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
