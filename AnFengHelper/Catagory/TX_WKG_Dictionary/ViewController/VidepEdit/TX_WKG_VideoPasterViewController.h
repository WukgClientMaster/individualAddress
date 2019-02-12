//
//  TX_WKG_VideoPasterViewController.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/23.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXLiteAVSDK_Professional/TXVideoEditer.h>
@class VideoPasterInfo;
@class VideoPreview;
@class VideoPasterView;

#ifndef TX_LITE_VIDEOPASTER_TYPE
#define TX_LITE_VIDEOPASTER_TYPE
typedef NS_ENUM(NSInteger,PasterInfoType){
    PasterInfoType_Animate,
    PasterInfoType_static,
};
#endif

@interface VideoPasterInfo: NSObject
@property (nonatomic, assign) PasterInfoType pasterInfoType;
@property (nonatomic, strong) VideoPasterView* pasterView;
@property (nonatomic, strong) UIImage  *iconImage;
@property (nonatomic, assign) CGFloat  startTime;    //s
@property (nonatomic, assign) CGFloat  endTime;      //s
//动态贴纸
@property (nonatomic, strong) NSString *path;        //动态贴纸需要文件路径 -> SDK
@property (nonatomic, assign) CGFloat  rotateAngle;  //动态贴纸需要传入旋转角度 -> SDK
//静态贴纸
@property (nonatomic, strong) UIImage  *image;       //静态贴纸需要贴纸Image -> SDK
@end

@protocol VideoPasterViewControllerDelegate <NSObject>
//返回
- (void)onSetVideoPasterInfosFinish:(NSArray<VideoPasterInfo*>*)videoPasterInfo;

@end

@interface TX_WKG_VideoPasterViewController : UIViewController

@property (nonatomic, weak) id<VideoPasterViewControllerDelegate> delegate;

- (instancetype)initWithVideoEditer:(TXVideoEditer*)videoEditer previewView:(VideoPreview*)previewView startTime:(CGFloat)startTime endTime:(CGFloat)endTime pasterInfos:(NSArray<VideoPasterInfo*>*)pasterInfos;

@end
