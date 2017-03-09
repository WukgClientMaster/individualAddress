//
//  UtilityTool.h
//
//  Created by 吴可高 on 15/7/15.
//  Copyright (c) 2015年 吴可高. All rights reserved.
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UtilityCalendarTool.h"
@interface UtilityTool : NSObject
//
+(UIImage *)createImageByColor:(UIColor *)color rect:(CGRect)frame;
//对图片压缩处理
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage*)image;
//根据View 获取VC
+ (UIViewController*)matchingViewController:(UIView *)view;
//匹配字符串是否在一个rang里面
+(BOOL)matchingString:(NSString*)stringMessage subRange:(NSRange)range;
// 检查字符串是有效浮点数
+(BOOL)matchingIsValidFloat:(NSString*)matchString;
//检查是否是正确的网址
+(BOOL)matchingIsValidUrl:(NSString*)matchString;
//判断用户名是否合法
+(bool)matchingName:(NSString*)strName;
//判断字符串是否为空,
+(BOOL)matchingIsEmpity:(NSString*)match;
//判断是否为手机号
+(bool)matchingPhone:(NSString*)strphone;
//邮箱验证
+(BOOL)matchingEmail:(NSString *)email;
//身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard;
// NSMutableAttributedString
+(NSMutableAttributedString*)mactchingAttributedStr:(NSString *)titleShowsString
            startPoint:(NSInteger)point
                  stringLength:(NSInteger)length attributeColor:(UIColor*)attributeColor
                    attributeFont:(UIFont*)font;

//使用正则表达式处理一串字符串是否包含字母
+(BOOL)matchingIsContainCharacter:(NSString*)targetStr;

//order By string  返回一个合适的高度
+(CGFloat)fatchTargetTitle:(NSString*)targetStr font:(UIFont*)targetFont targetWidth:(CGSize)size;
//
+ (NSString *)obtainWeekDay:(NSDate *)date;

@end
