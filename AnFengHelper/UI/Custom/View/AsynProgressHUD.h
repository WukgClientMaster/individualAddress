//
//  AsynProgressHUD.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/14.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsynProgressHUD : NSObject

+(instancetype)shareInstance;

- (void)showLoading;

- (void)dismissLoadingView;
@end
