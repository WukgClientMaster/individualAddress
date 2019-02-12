//
//  TX_WKG_PhotoEditViewController.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/10.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TX_WKG_PhotoEditCompleteHander)(UIImage* image);

@interface TX_WKG_PhotoEditViewController : UIViewController
@property (nonatomic, copy)   void (^EditFinishBlock)(UIImage *image);

-(instancetype)initWithCameraPhoto:(UIImage*)photo selecttedImages:(NSArray<UIImage*>*)selectedImages;
-(instancetype)initWithCameraPhoto:(UIImage*)photo callback:(TX_WKG_PhotoEditCompleteHander)callback;
@end
