//
//  TX_WKG_PhotoTool.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_PhotoTool.h"

@implementation TX_WKG_PhotoTool
+ (UIImage *)tx_wkg_photoImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
