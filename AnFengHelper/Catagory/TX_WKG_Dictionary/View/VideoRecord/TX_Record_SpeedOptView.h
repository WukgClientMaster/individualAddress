//
//  TX_Record_SpeedOptView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/9.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TX_Record_SpeedOptCallBack)(NSString*title);

@interface TX_Record_SpeedOptView : UIView
@property (strong,readonly,nonatomic) UIButton * selectButton;
@property (copy, nonatomic) TX_Record_SpeedOptCallBack  callback;
@end
