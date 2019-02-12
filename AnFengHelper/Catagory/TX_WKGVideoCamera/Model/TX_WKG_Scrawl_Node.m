//
//  TX_WKG_Scrawl_Node.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/18.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Scrawl_Node.h"

@implementation TX_WKG_Scrawl_Node

-(instancetype)initWithColor:(UIColor*)color lineWidth:(CGFloat)lineWidth isSelected:(BOOL)selected{
    TX_WKG_Scrawl_Node * node = [TX_WKG_Scrawl_Node new];
    node.color = color;
    node.lineWidth = lineWidth;
    node.selected = selected;
    return node;
}

@end
