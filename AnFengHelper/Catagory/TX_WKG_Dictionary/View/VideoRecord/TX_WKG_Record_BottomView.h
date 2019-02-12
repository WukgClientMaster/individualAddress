//
//  TX_WKG_Record_BottomView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/3/27.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TX_WKG_Record_Bottom_EventCallBack)(NSString* title);
@interface TX_WKG_Record_BottomView : UIView
@property (copy, nonatomic) TX_WKG_Record_Bottom_EventCallBack eventCallback;

//视频回删功能
-(void)loadbackDeleteVideoView:(BOOL)isbackDelete;
@end
