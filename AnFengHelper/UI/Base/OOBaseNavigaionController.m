//
//  OOBaseNavigaionController.m
//  Learn_ObjectiveC
//  Created by 吴可高 on 16/3/21.
//  Copyright (c) 2016年 吴可高. All rights reserved.
#import "OOBaseNavigaionController.h"
@interface OOBaseNavigaionController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@end
@implementation OOBaseNavigaionController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.delegate = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}
+(void)initialize
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    //改变导航条的背景颜色。
    [appearance setBarTintColor:UIColorFromRGB(0xf8c301)];
    //改变导航条上的标题的颜色和字体。
    [appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x373c40), NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic" size:18], NSFontAttributeName,nil]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    [viewController.navigationController setNavigationBarHidden:YES animated:YES];
    self.interactivePopGestureRecognizer.enabled = YES;
    [super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark UINavigationControllerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.childViewControllers count] == 1) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}
@end
