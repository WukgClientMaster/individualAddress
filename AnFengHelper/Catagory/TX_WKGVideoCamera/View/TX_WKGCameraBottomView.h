//
//  TX_WKGCameraBottomView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TX_WKG_VidoeCamera_CallBack)(NSString* title);
@interface TX_WKGCameraBottomView : UIView
@property (copy, nonatomic) TX_WKG_VidoeCamera_CallBack callback;

//type:YES 控件颜色是深色 NO：白色
-(void)settingCameraBottomControllsColor:(NSString*)type;
@end
