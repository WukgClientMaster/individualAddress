//
//  TX_WKG_VideoRecord_Item.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/3/27.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Video_OptSuperItem.h"
// title
@interface TX_WKG_VideoRecord_Item : TX_WKG_Video_OptSuperItem
@property (strong,readonly,nonatomic)UILabel * label;

-(void)configParams:(NSString*)title imgString:(NSString*)imgString;
@end
