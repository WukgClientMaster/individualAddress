//
//  PhoneCall.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/6/17.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhoneCall : NSObject

/**
 *  直接拨打电话
 *  @param phoneNum 电话号码
 */
+ (void)directPhoneCallWithPhoneNum:(NSString *)phoneNum;

/**
 *  弹出对话框并询问是否拨打电话
 *
 *  @param phoneNum 电话号码
 *  @param view     contentView
 */
+ (void)phoneCallWithPhoneNum:(NSString *)phoneNum contentView:(UIView *)contentView;

@end
