//
//  ProjectAppConfiguration.h
//  Learn_ObjectiveC
//  Created by 吴可高 on 16/3/21.
//  Copyright (c) 2016年 吴可高. All rights reserved.
#ifndef Learn_ObjectiveC_ProjectAppConfiguration_h
#define Learn_ObjectiveC_ProjectAppConfiguration_h

//获取rgb颜色
#define UIColorFromRGB(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
    blue:((float)(rgbValue & 0xFF))/255.0 \
    alpha:(float)1.0]

#define KColor(r,g,b)  [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0]

//Custom Debug
#ifdef  DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

// 数据请求网络基地址
#define ServletConfigPath   @"http://120.76.165.119:8080"

//视图frame
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width  [UIScreen mainScreen].bounds.size.width
#define kNavigationBarHeight   64
//
#define kWindow  [UIApplication sharedApplication].keyWindow

//设备判断
#define kDevice_Is_iPhone4  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define kDevice_Is_iPhone5  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define kDevice_Is_iPhone6  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//
#define kScaleWidth(iphone6Width) [[UIScreen mainScreen] bounds].size.width / 375.f * iphone6Width

#define kScaleHeight(iphone6Height) [[UIScreen mainScreen] bounds].size.height / 667.f * iphone6Height

//单例模式
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}
#define XS_INITCLASS( __class ) [[__class alloc] init];

#endif
