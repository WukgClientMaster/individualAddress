//
//  AsynProgressHUDConfigure.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/14.
//  Copyright © 2016年 吴可高. All rights reserved.

#ifndef AsynProgressHUDConfigure_h
#define AsynProgressHUDConfigure_h

#define kSMProgressWindowWidth [UIScreen mainScreen].bounds.size.width
#define kSMProgressWindowHeight [UIScreen mainScreen].bounds.size.height
static const NSTimeInterval kSMProgressHUDLoadingDelay = 3.f;
static const NSTimeInterval kSMProgressHUDAnimationDuration = 0.3f;
static const CGFloat  kSMProgressHUDCornerRadius  = 5.f;
static const CGFloat  kSMProgressHUDLoadingIconWH = 30.f;
static const CGFloat  kSMProgressHUDContentWidth  = 200.f;
static const CGFloat  kSMProgressHUDContentHeight = 100.f;
static NSString *SMProgressHUDLoadingTip = @"正在加载中...";
#define SMGaryColor [UIColor colorWithRed:220/255.f green:220/255.f blue:220/255.f alpha:1]
#define SMTextColor [UIColor colorWithRed:83/255.f green:83/255.f blue:83/255.f alpha:1]
#endif /* AsynProgressHUDConfigure_h */
