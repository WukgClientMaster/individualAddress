//
//  TX_WKG_Clips_Node.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/24.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Clips_Node.h"

@implementation TX_WKG_Clips_Node
+(instancetype)clipsNodeWithTitle:(NSString*)title
                  normalImgString:(NSString*)normalImgString
                selectedImgString:(NSString*)selectedImgString
                        seleceted:(BOOL)selected{
    TX_WKG_Clips_Node * node = [[TX_WKG_Clips_Node alloc]init];
    node.title = title;
    node.selected = selected;
    node.normalImgString = normalImgString;
    node.selectedImgString = selectedImgString;
    return node;
}

@end
