//
//  TX_WKG_Photo_MosaicView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/15.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TX_WKG_Photo_Mosaic_CallBack)(NSString* title);

@interface TX_WKG_Photo_MosaicView : UIView
@property (copy, nonatomic) TX_WKG_Photo_Mosaic_CallBack mosaicCallback;
@end
