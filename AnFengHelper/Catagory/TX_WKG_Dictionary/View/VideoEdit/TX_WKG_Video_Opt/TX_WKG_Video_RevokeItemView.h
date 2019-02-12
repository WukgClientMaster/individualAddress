//
//  TX_WKG_Video_RevokeItemView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/19.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TX_WKG_Video_RevokeItemCallback)(UIControl* controll);

@interface TX_WKG_Video_RevokeItemView : UIControl
@property (strong, nonatomic) UIColor * bgroundColor;
@property (copy, nonatomic) TX_WKG_Video_RevokeItemCallback callback;

@end
