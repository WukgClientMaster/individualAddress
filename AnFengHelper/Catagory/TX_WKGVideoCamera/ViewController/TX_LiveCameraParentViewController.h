//
//  TX_LiveCameraParentViewController.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/25.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXLivePush.h>
#import <TXLiveBase.h>

@interface TX_LiveCameraParentViewController : UIViewController
@property (strong,readonly,nonatomic) UIView * live_renderView;
@property (strong,readonly,nonatomic) UIView * camera_renderView;
@property (strong,readonly,nonatomic) TXLivePush * txLivePush;
@property (copy,nonatomic) NSString * renderRatio; // 9-16,3-4,1-1
@end
