//
//  TX_WKG_Photo_Tool.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/23.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Photo_Tool.h"

@implementation TX_WKG_Photo_Tool

+(UIImage*)composeImageAssetCom1:(UIImage*)com1 com2:(UIImage*)com2{
    CGImageRef imgRef = com1.CGImage;
    CGFloat w = CGImageGetWidth(imgRef);
    CGFloat h = CGImageGetHeight(imgRef);
    
    //以1.png的图大小为底图
    CGImageRef imgRef1 = com2.CGImage;
    CGFloat w1 = CGImageGetWidth(imgRef1);
    CGFloat h1 = CGImageGetHeight(imgRef1);
    
    CGSize renderSize = CGSizeZero;
    if (w1 > w) {
        renderSize = CGSizeMake(w1, h1);
    }else{
        renderSize = CGSizeMake(w, h);
    }
    //以1.png的图大小为画布创建上下文
    UIGraphicsBeginImageContext(renderSize);
    [com1 drawInRect:CGRectMake(0, 0, w1, h1)];//先把1.png 画到上下文中
    [com2 drawInRect:CGRectMake((w1-w)/2.f,(h1- h)/2.f, w, h)];//再把小图放在上下文中
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
    CGImageRelease(imgRef);
    CGImageRelease(imgRef1);
    return resultImg;
}

+(UIImage*)renderGrphicsWithViews:(UIView*)renderView renderSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, 0, 1.f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [renderView.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
