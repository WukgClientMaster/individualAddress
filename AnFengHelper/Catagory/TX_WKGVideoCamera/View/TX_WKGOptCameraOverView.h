//
//  TX_WKGOptCameraOverView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TX_WKG_OptCameraOver_CallBack)(NSString* title);

@interface TX_WKGOptCameraOverView : UIView
@property (copy, nonatomic) TX_WKG_OptCameraOver_CallBack callback;

-(void)settingTX_WKG_CameraOverViewControlStatusWithOptType:(NSString*)optType;

@end
