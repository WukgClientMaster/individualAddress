//
//  APPCUSTextFieldViewItem.h
//  AnFengHelper
//
//  Created by 智享城市iOS开发 on 2018/4/7.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "APPItem.h"

@interface APPCUSTextFieldViewItem : APPItem
@property (strong, nonatomic) NSDictionary * configJson;
@property (copy, nonatomic) NSString * placeholder;
@property (copy, nonatomic) NSString * text;
/*
 */
+(instancetype)initializeWithImg:(NSString*)img title:(NSString*)title subtitle:(NSString*)subtitle placeholder:(NSString*)placeholder;
@end
