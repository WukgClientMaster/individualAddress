//
//  TX_WKG_Paster_Node.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Paster_Node.h"

@implementation TX_WKG_Paster_Node

+(instancetype)pasterNodeWithImageString:(NSString*)imageString indexPath:(NSIndexPath*)indexPath selected:(BOOL)selected{
    TX_WKG_Paster_Node * node = [self pasterNodeWithImageString:imageString selected:selected];
    node.indexPath = indexPath;
    return node;
}

+(instancetype)pasterNodeWithImageString:(NSString*)imageString selected:(BOOL)selected{
    TX_WKG_Paster_Node * node = [TX_WKG_Paster_Node new];
    node.imageString = imageString;
    node.selected = selected;
    return node;
}

@end
