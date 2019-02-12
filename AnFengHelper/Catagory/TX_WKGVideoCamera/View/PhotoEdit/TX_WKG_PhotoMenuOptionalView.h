//
//  TX_WKG_PhotoMenuOptionalView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/15.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef TX_WKG_PhotoMenuOptionalContentViewKey
#define TX_WKG_PhotoMenuOptionalContentViewKey
typedef NS_ENUM(NSInteger,TX_WKG_PhotoMenuEditType){
    TX_WKG_PhotoMenuEdit_Global_Optional_Type, // 全局操作
    TX_WKG_PhotoMenuEdit_Clips_Optional_Type,  // 图片裁剪
    TX_WKG_PhotoMenuEdit_Normal_Optional_Type, // 图片正常操作
    TX_WKG_PhotoMenuEdit_Middle_Paster_Optional_Event_Type,//视图中间添加贴纸
};
#endif

@interface TX_WKG_PhotoMenuOptionalView : UIView
typedef void (^TX_WKG_PhotoMenuOptional_CallBack)(NSString* title);
@property (copy, nonatomic) TX_WKG_PhotoMenuOptional_CallBack callback;
@property (assign, nonatomic) TX_WKG_PhotoMenuEditType  photoMenuType; //对图片操作type
@end
