//
//  TX_WKG_VideoRecord_AuthorizateManager.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/24.
//  Copyright © 2018年 NRH. All rights reserved.
//


#ifndef  TX_WKG_VideoRecord_AuthorizateContentKey
#define  TX_WKG_VideoRecord_AuthorizateContentKey
typedef NS_ENUM(NSInteger,TX_WKGVideoRecoredAuthType){
    TX_WKGVideoRecoredAuthVideo,
    TX_WKGVideoRecoredAuthAudio,
    TX_WKGVideoRecoredAuthPhotoLibrary
};
#endif

typedef void (^TX_WKG_VideoRecordAuthorizateCallback)(BOOL auth,TX_WKGVideoRecoredAuthType authType);

#import <Foundation/Foundation.h>

@interface TX_WKG_VideoRecord_AuthorizateManager : NSObject

+(instancetype)shareInstance;

-(void)obtainAccountAuthorizateWithAuthType:(TX_WKGVideoRecoredAuthType)authType callback:(TX_WKG_VideoRecordAuthorizateCallback)callback;

@end
