//
//  TEST2ViewController.h
//  AnFengHelper
//
//  Created by 吴可高 on 2018/5/8.
//  Copyright © 2018年 AnFen. All rights reserved.
//
@class TEST1ViewController;

#import <UIKit/UIKit.h>
@interface TEST2ViewController : UIViewController

-(void)setCallback:(void(^)(BOOL success,id response))callback;
@property(nonatomic,strong) TEST1ViewController * previousVC;

@end
