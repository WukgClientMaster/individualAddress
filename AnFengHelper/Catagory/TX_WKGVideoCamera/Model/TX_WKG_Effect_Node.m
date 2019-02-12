//
//  TX_WKG_Effect_Node.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Effect_Node.h"

@implementation TX_WKG_Effect_Node
+(instancetype)effectNodeWithImageString:(NSString*)imageString text:(NSString*)text selected:(BOOL)selected optionalImage:(UIImage*)optionalImage{
   TX_WKG_Effect_Node * node = [self  effectNodeWithImageString:imageString selected:selected optionalImage:optionalImage];
    node.text = text;
    return node;
}

+(instancetype)effectNodeWithImageString:(NSString*)imageString selected:(BOOL)selected optionalImage:(UIImage*)optionalImage{
    TX_WKG_Effect_Node * node = [TX_WKG_Effect_Node new];
    node.imageString = imageString;
    node.selected = selected;
    node.optionalImage = optionalImage;
    return node;
}

@end
