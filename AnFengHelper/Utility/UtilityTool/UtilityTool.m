//
//  UtilityTool.m
//  IpadApp
//  Created by 吴可高 on 15/7/15.
//  Copyright (c) 2015年 吴可高. All rights reserved.
#import "UtilityTool.h"
#import "NSString+FilterException.h"
@implementation UtilityTool

//根据颜色生成图片
+(UIImage *)createImageByColor:(UIColor *)color rect:(CGRect)frame
{
    CGRect rect = frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
// 对图片压缩处理
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage*)image
{
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0,0,targetSize.width,targetSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//根据View返回VC
+ (UIViewController*)matchingViewController:(UIView *)view
{
    for (UIView* next = [view superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
//拿到目标字符串，在range范围内做一定处理
+(BOOL)matchingString:(NSString*)message subRange:(NSRange)range;
{
    BOOL isflag = YES;
    message=[message stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (message.length < range.location || message.length > range.length)
    {
        isflag  =NO;
    }
    return  isflag;
}
//身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}
//判断是否为手机号
+(bool)matchingPhone:(NSString*)strphone
{
        /**
         * 手机号码
         * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         * 联通：130,131,132,152,155,156,185,186
         * 电信：133,1349,153,180,189
         */
        NSString *MOBILE = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";

        /**
         10         * 中国移动：China Mobile
         11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         12         */
        NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
        /**
         15         * 中国联通：China Unicom
         16         * 130,131,132,152,155,156,185,186
         17         */
        NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
        /**
         20         * 中国电信：China Telecom
         21         * 133,1349,153,180,189
         22         */
        NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
        /**
         25         * 大陆地区固话及小灵通
         26         * 区号：010,020,021,022,023,024,025,027,028,029
         27         * 号码：七位或八位
         28         */
        // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
        
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
        NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
        NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
        
        if (([regextestmobile evaluateWithObject:strphone] == YES)
            || ([regextestcm evaluateWithObject:strphone] == YES)
            || ([regextestct evaluateWithObject:strphone] == YES)
            || ([regextestcu evaluateWithObject:strphone] == YES))
        {
            return YES;
        }
        else
        {
            return NO;
        }
}
//判断字符串是否为空,
+(BOOL)matchingIsEmpity:(NSString*)match;
{
    if (match && [match isKindOfClass:[NSString class]])
    {
       return [match matchingIsEmpty];
    }
    return YES;
}
//判断用户名是否合法 包含字母大小写，数字 字符串长度是：3- 15位
+(bool)matchingName:(NSString*)strphone
{
    strphone=[strphone stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *regex = @"^[a-zA-Z\\xa0-\\xff_][0-9a-zA-Z\\xa0-\\xff_]{3,15}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:strphone];
}
// 检查字符串是有效浮点数
+(BOOL)matchingIsValidFloat:(NSString*)matchString
{
    NSString *regex = @"([-+]?[0-9]*\\.?[0-9]*)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:matchString];
}
// 查看字符串是否是正确网址
+(BOOL)matchingIsValidUrl:(NSString*)matchString
{
    NSString *regex = @"(http|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?";

    return ([matchString rangeOfString:regex options:NSRegularExpressionSearch].location != NSNotFound);
}
//匹配是否是邮箱
+(BOOL)matchingEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(NSMutableAttributedString*)mactchingAttributedStr:(NSString *)titleShowsString
        startPoint:(NSInteger)point
            stringLength:(NSInteger)length attributeColor:(UIColor*)attributeColor
                  attributeFont:(UIFont*)font;
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:titleShowsString];
    [str addAttribute:NSForegroundColorAttributeName value:attributeColor range:NSMakeRange(point,length)];
    [str addAttribute:NSFontAttributeName value: font range:NSMakeRange(point, length)];
    return str;
}

//使用正则表达式处理一串字符串是否包含字母
+(BOOL)matchingIsContainCharacter:(NSString*)targetStr;
{
    NSString *regex = @"[A-Za-z].*[0-9]|[0-9].*[A-Za-z]";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:targetStr];
}
//
+(CGFloat)fatchTargetTitle:(NSString*)targetStr font:(UIFont*)targetFont targetWidth:(CGSize)size
{
    NSDictionary*attributeDict = @{NSAttachmentAttributeName :targetFont};
    CGFloat  finalHeight = [targetStr boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:attributeDict context:nil].size.height;
    return finalHeight;
}
#pragma mark -- 获取当前是周几
+ (NSString *)obtainWeekDay:(NSDate *)date
{
    NSString *weekday;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    switch ([dateComps weekday]) {
        case 1:
            weekday = @"星期日";
            break;
        case 2:
            weekday = @"星期一";
            break;
        case 3:
            weekday = @"星期二";
            break;
        case 4:
            weekday = @"星期三";
            break;
        case 5:
            weekday = @"星期四";
            break;
        case 6:
            weekday = @"星期五";
            break;
        case 7:
            weekday = @"星期六";
            break;
        default:
            weekday = @"星期日";
            break;
    }
    return weekday;
}
@end
