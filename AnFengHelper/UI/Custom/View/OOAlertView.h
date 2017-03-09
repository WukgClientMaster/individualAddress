//
//  OOAlertView.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/3/29.
//  Copyright © 2016年 吴可高. All rights reserved.
//  OOAlertView 

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger,DialogueType)
{
    kDialogueErrorType,
    kDialogueWarningType
};
@interface OOAlertView : UIView

+(instancetype)shareInstance;

#pragma mark -Asyn Request Totast Message
-(void)showInContainerView:(UIView*)containerView;
-(void)hideMsgInContainerView;

#pragma mark - 界面数据逻辑操作时，不满足一定条件的话 showInView message
-(void)pushDialogueType:(DialogueType)type dialogueText:(NSString*)text;
-(void)popDialogue;
// 本地网络连接失败
-(void)showNetWorkConnectFailure;

@end
