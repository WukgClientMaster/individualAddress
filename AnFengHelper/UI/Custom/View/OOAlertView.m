//
//  OOAlertView.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/3/29.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "OOAlertView.h"
#import "AsynProgressHUD.h"
#import "APPNoticeView.h"
#import "APPNotificationEvent.h"
@class OOAlertView;
static dispatch_once_t once;
static OOAlertView * shareOOAlertView = nil;
static APPNotificationEvent * appNotificationEvent = nil;


@interface OOAlertView ()
{
    APPNoticeView * _notice;
}

@end
@implementation OOAlertView

+(instancetype)shareInstance;
{
    @synchronized(self) {
    dispatch_once(&once, ^{
        shareOOAlertView  =  [[OOAlertView alloc]initWithFrame:CGRectZero];
        appNotificationEvent  = [[APPNotificationEvent alloc]init];
        });
    }
    return shareOOAlertView;
}

#pragma mark -Asyn Request Totast Message
-(void)showInContainerView:(UIView*)containerView;
{
    [[AsynProgressHUD shareInstance]showLoading];
}

-(void)hideMsgInContainerView;
{
    [[AsynProgressHUD shareInstance]dismissLoadingView];
}
#pragma mark - 界面数据逻辑操作时，不满足一定条件的话 showInView message
-(void)pushDialogueType:(DialogueType)type dialogueText:(NSString*)text;
{
    APPNoticeType  noticeType =  type == kDialogueErrorType ?     kAPPNoticeAsynRequestType : kAPPNoticeInterfaceOperationType;
     _notice = [[APPNoticeView shareInstance]initWithTitle:nil appNoticeType:noticeType andDesText:text];
    [_notice appNoticeShow];
}

-(void)popDialogue
{
    [_notice appNoticeRemove];
}
#pragma mark 本地网络连接失败
-(void)showNetWorkConnectFailure
{
    appNotificationEvent.titleText = @"Update available";
    appNotificationEvent.subtitleText  = @"Do you want to download the update of this file?";
    appNotificationEvent.image =  [UIImage imageNamed:@"network_error"];
    appNotificationEvent.topButtonText  = @"Accept";
    appNotificationEvent.bottomButtonText = @"Cancel";
    appNotificationEvent.dismissOnTap = YES;
    [appNotificationEvent presentInView:nil withGravityAnimation:YES];
}

@end
