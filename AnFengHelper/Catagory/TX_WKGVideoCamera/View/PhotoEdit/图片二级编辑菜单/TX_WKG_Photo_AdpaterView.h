//
//  TX_WKG_Photo_AdpaterView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/7/3.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TX_WKG_Photo_BothWay_Slider.h"

@interface TX_WKG_Photo_AdpaterView : UIView
@property (strong, nonatomic) TX_WKG_Photo_BothWay_Slider *bothway_slider;

-(void)resetPhotoAdaptorStatus;

@end
