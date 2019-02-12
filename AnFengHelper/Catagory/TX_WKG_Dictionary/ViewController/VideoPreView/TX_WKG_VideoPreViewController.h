//
//  TX_WKG_VideoPreViewController.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/13.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXLiteAVSDK_Professional/TXLivePlayer.h>
@class MusicInfo;
@interface TX_WKG_VideoPreViewController : UIViewController

- (instancetype)initWithCoverImage:(UIImage *)coverImage
                         videoPath:(NSString*)videoPath
                         musicpath:(MusicInfo*)musicInfo
                        renderMode:(TX_Enum_Type_RenderMode)renderMode
                      isFromRecord:(BOOL)isFromRecord;
@end
