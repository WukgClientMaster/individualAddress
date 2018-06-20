//
//  TEST2ViewController.m
//  AnFengHelper
//
//  Created by 吴可高 on 2018/5/8.
//  Copyright © 2018年 AnFen. All rights reserved.
//



#import "TEST1ViewController.h"
#import "TEST2ViewController.h"

@interface AAObject :NSObject
@property(nonatomic,strong) TEST2ViewController * vc;
-(void)setcallback:(void(^)(BOOL falge,id response))callback;

@end

@implementation AAObject
-(void)setcallback:(void(^)(BOOL falge,id response))callback{
    if (callback) {
        callback(YES,@{});
    }
}
@end


typedef void(^TEST2VCCallback)(BOOL success,id response);
@interface TEST2ViewController ()
@property(nonatomic,strong) AAObject *  aaObject;
@property(nonatomic,strong) NSTimer * timer;
@property(nonatomic,copy) TEST2VCCallback callback;

@end

@implementation TEST2ViewController
-(AAObject *)aaObject{
    _aaObject = ({
        if (!_aaObject) {
            _aaObject = [AAObject new];
        }
        _aaObject;
    });
    return _aaObject;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[SDImageCache sharedImageCache]clearMemory];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
}
-(void)setCallback:(void(^)(BOOL success,id response))callback{
    _callback = callback;

}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    __weak typeof(self)weakSelf= self;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    if (self.callback) {
        self.callback(YES,@{@"class":@"TEST2ViewController"});
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.aaObject setcallback:^(BOOL falge, id response) {
        [self printfDataWithResponse:response];
    }];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)timerAction{
    
    
}

-(void)printfDataWithResponse:(id)response{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
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
