//
//  YYTextFieldManager.h
//  smarket
//
//  Created by client on 2017/6/23.
//  Copyright © 2017年 原研三品. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ComplateHander)(APPTextField * textField , NSString * vaild,NSString* msg);
@interface YYTextFieldManager : NSObject
+(instancetype)shareInstance;

-(void)textFieldObserverConditionMinimum:(NSInteger)minimumValue maximumValue:(NSInteger)maximum;
-(void)addobserverTextField:(APPTextField*)textField keypath:(NSString*)path complateHander:(ComplateHander)hander;

-(void)removeObserverTextField:(APPTextField*)textField keypath:(NSString*)path;

-(void)clearAllObservers;

@end
