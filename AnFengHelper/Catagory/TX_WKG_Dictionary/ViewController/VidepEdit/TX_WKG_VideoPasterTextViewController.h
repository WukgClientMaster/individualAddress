//
//  TX_WKG_VideoPasterTextViewController.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/18.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXLiteAVSDK_Professional/TXVideoEditer.h>
@class VideoPreview;
@class VideoTextFiled;


@interface VideoTextInfo : NSObject
@property (nonatomic, strong) VideoTextFiled* textField;
@property (nonatomic, assign) CGFloat startTime; //in seconds
@property (nonatomic, assign) CGFloat endTime;
@end

@protocol VideoTextViewControllerDelegate <NSObject>
//返回
- (void)onSetVideoTextInfosFinish:(NSArray<VideoTextInfo*>*)videoTextInfos;

@end

@interface TX_WKG_VideoPasterTextViewController : UIViewController

@property (nonatomic, weak) id<VideoTextViewControllerDelegate> delegate;

- (id)initWithVideoEditer:(TXVideoEditer*)videoEditer previewView:(VideoPreview*)previewView startTime:(CGFloat)startTime endTime:(CGFloat)endTime videoTextInfos:(NSArray<VideoTextInfo*>*)videoTextInfos;

@end
