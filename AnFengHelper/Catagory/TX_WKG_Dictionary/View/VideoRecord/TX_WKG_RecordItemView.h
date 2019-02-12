//
//  TX_WKG_RecordItemView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/3/27.
//  Copyright © 2018年 NRH. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface TX_WKG_RecordItemView : UIView

#ifndef TX_WKG_VIDEOMANNER_ENUM
#define TX_WKG_VIDEOMANNER_ENUM
typedef NS_ENUM(NSInteger, TX_WKG_VideoManner){
    TX_WKG_VideoManner_LongPress,
    TX_WKG_VideoManner_SingleTip,
};
#endif

typedef void (^TX_WKG_RecordCancelCallback)(TX_WKG_VideoManner videoType,BOOL isVideoRecordEnded);

@property (assign,nonatomic) BOOL completed;
@property (assign, nonatomic) TX_WKG_VideoManner videoRecordType;
@property (copy, nonatomic) TX_WKG_RecordCancelCallback cancelCallback;
@property (strong, nonatomic) UIColor * peripheryCircleColor;
@property (strong, nonatomic) UIColor * internalCircleColor;

-(void)delayRecordVideoWithManner:(TX_WKG_VideoManner)manner;

-(void)applicationDidBackGroundEvents;

@end
