//
//  TX_WKG_Video_OptSuperItem.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/3/27.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TX_WKG_Video_OptSuperItem;
// imgView
typedef void(^TX_WKG_Video_OptSuperControlCallBack)(id item);
@interface TX_WKG_Video_OptSuperItem : UIControl
@property (strong,readonly,nonatomic) UIImageView * imageView;
@property (copy,readonly,nonatomic) NSString * indefiner;
@property (copy, nonatomic) TX_WKG_Video_OptSuperControlCallBack callback;
-(void)setup;
-(void)configParamImgString:(NSString*)imgString;
-(void)configParamImgString:(NSString*)imgString highlight:(NSString*)highlight indefiner:(NSString*)indefiner;
-(void)configParamImgString:(NSString *)imgString indefiner:(NSString *)indefiner;
-(void)optEvents:(UIControl*)control;
-(void)touchUpOutsideEvents:(UIControl*)control;

@end
