//
//  TX_WKG_Photo_Tool.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/23.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TX_WKG_Photo_Tool : NSObject

+(UIImage*)composeImageAssetCom1:(UIImage*)com1 com2:(UIImage*)com2;

+(UIImage*)renderGrphicsWithViews:(UIView*)renderView renderSize:(CGSize)size;

@end
