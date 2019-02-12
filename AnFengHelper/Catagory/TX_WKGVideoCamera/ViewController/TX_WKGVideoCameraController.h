//
//  TX_WKGVideoCameraController.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TX_LiveCameraParentViewController.h"
#import "TX_WKG_CameraOptionalView.h"

@interface TX_WKGVideoCameraController : UIViewController
@property (nonatomic ,copy) void (^FinishSelectBlock)(NSArray <UIImage *>* images);
@property (nonatomic ,assign) NSInteger  selectedIndex;
@property (weak,nonatomic) TX_LiveCameraParentViewController * parentViewController;
@property (strong,readonly,nonatomic) TX_WKG_CameraOptionalView * cameraOptionalView;
@end
