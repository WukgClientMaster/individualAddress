//
//  APPNotificationEvent.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/18.
//  Copyright © 2016年 吴可高. All rights reserved.
//  APP数据请求失败｜或者  其他权限较高的操作
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@protocol APPLocalNotificationDelegate <NSObject>

-(void)dropDownNotifiationItemTapped:(id)parmaeter;

@end
typedef NS_ENUM(NSInteger, AFDropdownNotificationEvent) {
    
    AFDropdownNotificationEventTopButton,
    AFDropdownNotificationEventBottomButton,
    AFDropdownNotificationEventTap
};
typedef void (^APPLocalNotificationBlock)(AFDropdownNotificationEvent event);

@interface APPNotificationEvent : NSObject

@property (weak, nonatomic) id <APPLocalNotificationDelegate> delegate;

@property (nonatomic, strong) UIView *notificationView;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *subtitleText;
@property (nonatomic, strong) UIImage  *image;
@property (nonatomic, strong) NSString *topButtonText;
@property (nonatomic, strong) NSString *bottomButtonText;

@property (nonatomic) BOOL isBeingShown;

-(void)listenEventsWithBlock:(APPLocalNotificationBlock)block;

-(void)presentInView:(UIView *)view withGravityAnimation:(BOOL)animation;
-(void)dismissWithGravityAnimation:(BOOL)animation;

@property (nonatomic) BOOL dismissOnTap;


@end
