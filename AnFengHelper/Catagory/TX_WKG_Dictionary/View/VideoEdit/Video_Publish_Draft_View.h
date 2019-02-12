//
//  Video_Publish_Draft_View.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Video_publish_Draft_CallBack)(NSString*title);

@interface Video_Publish_Draft_View : UIView

@property (copy, nonatomic) Video_publish_Draft_CallBack publish_callback;

@end
