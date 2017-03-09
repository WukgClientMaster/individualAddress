//
//  OOBaseViewContrlManager.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/5/6.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "OOBaseViewContrlManager.h"
#import "OOBaseTabBarController.h"

@implementation OOBaseViewContrlManager
DEF_SINGLETON(OOBaseViewContrlManager)

-(OOBaseTabBarController*)loadControllerWithType;
{
    dispatch_once_t  once;
    dispatch_once(&once, ^{
        _tabBarController = [[OOBaseTabBarController alloc]init];
    });
    return _tabBarController;
}

@end
