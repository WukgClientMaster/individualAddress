//
//  TX_WKG_VideoEffectSuperView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/19.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EffectSelectView.h"
#import "TimeSelectView.h"

typedef void (^TX_WKG_Video_EffectRevokeCallback)(NSString* title);
@interface TX_WKG_VideoEffectSuperView : UIView

@property (weak, nonatomic) id<VideoEffectViewDelegate>effectDelegate;
@property (weak, nonatomic) id<TimeSelectViewDelegate>timeDelegate;
@property (copy, nonatomic) TX_WKG_Video_EffectRevokeCallback callback;

@end
