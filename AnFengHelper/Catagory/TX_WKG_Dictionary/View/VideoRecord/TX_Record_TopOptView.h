//
//  TX_Record_TopOptView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/3/27.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TX_WKG_Record_TopOptCallBack)(UIButton * optButton,NSString* title);
@interface TX_Record_TopOptView : UIView
@property (copy, nonatomic) TX_WKG_Record_TopOptCallBack callback;
@property (strong,readonly,nonatomic) UIButton * musicOpt_btn;
-(void)setSelectedStatus:(BOOL)selected opt:(NSString*)title;
-(void)setStatusImageWithEnable:(BOOL)enable;

@end
