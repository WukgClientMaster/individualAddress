//
//  PhotoInterruptView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/10.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PhotoInterrupt_Opt_CallBack)(UIButton* item,NSString* title);
@interface PhotoInterruptView : UIView
@property (copy, nonatomic) PhotoInterrupt_Opt_CallBack opt_callback;

-(void)setSubControllWithTitle:(NSString*)title hidden:(BOOL)hidden;

@end
