//
//  OOBaseViewContrlManager.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/5/6.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OOBaseTabBarController;
@interface OOBaseViewContrlManager : NSObject

@property (strong, nonatomic) OOBaseTabBarController * tabBarController;

AS_SINGLETON(OOBaseViewContrlManager);

-(OOBaseTabBarController*)loadControllerWithType;

@end
