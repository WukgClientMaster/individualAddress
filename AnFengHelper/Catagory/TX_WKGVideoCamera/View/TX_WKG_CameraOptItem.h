//
//  TX_WKG_CameraOptItem.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Video_OptSuperItem.h"

@interface TX_WKG_CameraOptItem : TX_WKG_Video_OptSuperItem
@property (strong,readonly,nonatomic) UILabel * title_label;
@property (copy,readonly,nonatomic) NSString * optType;

-(void)configParamImgString:(NSString*)imgString title:(NSString*) title indefiner:(NSString*)indefiner optType:(NSString*)optType;
@end
