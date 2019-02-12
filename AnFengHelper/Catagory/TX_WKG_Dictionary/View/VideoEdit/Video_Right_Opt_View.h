//
//  Video_Right_Opt_View.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/17.
//  Copyright © 2018年 NRH. All rights reserved.

#import <UIKit/UIKit.h>

typedef void (^Video_Right_Opt_CallBack)(NSString* title);

@interface Video_Right_Opt_View : UIView
@property (copy, nonatomic) Video_Right_Opt_CallBack opt_callback;
-(void)setHidden:(BOOL)hidden opt:(NSString*)title;

@end
