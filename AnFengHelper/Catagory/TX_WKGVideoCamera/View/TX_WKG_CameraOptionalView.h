//
//  TX_WKG_CameraOptionalView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^VideoCamera_Top_Opt_CallBack)(UIButton* item,NSString* title);
@interface TX_WKG_CameraOptionalView : UIView
@property (copy, nonatomic) VideoCamera_Top_Opt_CallBack opt_callback;
@property (copy,readonly,nonatomic) NSString * optionalBeautyisClosed;//美颜是否关闭
@property (copy,readonly,nonatomic) NSString * optionalCurrentControlColor;//当前视图控件是颜色 YES 深色: NO:白色

//type:YES 控件颜色是深色 NO：白色
-(void)settingCameraOptionalControllsColor:(NSString*)type;
-(void)setSelectedStatus:(BOOL)selected opt:(NSString*)title;

@end
