//
//  TX_WKG_Clips_Node.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/24.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TX_WKG_Clips_Node : NSObject
@property (assign, nonatomic) BOOL  selected;
@property (copy,nonatomic) NSString * normalImgString;
@property (copy,nonatomic) NSString * selectedImgString;
@property (copy,nonatomic) NSString * title;

+(instancetype)clipsNodeWithTitle:(NSString*)title
                  normalImgString:(NSString*)normalImgString
                selectedImgString:(NSString*)selectedImgString
                        seleceted:(BOOL)selected;

@end
