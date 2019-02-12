//
//  TX_WKG_Effect_Node.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TX_WKG_Effect_Node : NSObject

@property (copy, nonatomic) NSString * imageString;
@property (assign, nonatomic) BOOL   selected;
@property (copy, nonatomic) NSString * text;
@property (strong, nonatomic) UIImage * optionalImage;

+(instancetype)effectNodeWithImageString:(NSString*)imageString text:(NSString*)text selected:(BOOL)selected optionalImage:(UIImage*)optionalImage;

@end
