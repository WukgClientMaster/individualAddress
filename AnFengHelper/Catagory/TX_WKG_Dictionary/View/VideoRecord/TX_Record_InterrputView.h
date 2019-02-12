//
//  TX_Record_InterrputView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/10.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TX_Record_InterruptCallback)(NSString * title);

@interface TX_Record_InterrputView : UIView
@property (strong,nonatomic) UILabel * tips_label;
@property (copy, nonatomic) TX_Record_InterruptCallback callback;

-(void)setSubViewHidddenWithTitle:(NSString *)title hidden:(BOOL)hidden;

@end
