//
//  TX_WKG_Paster_Node.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TX_WKG_Paster_Node : NSObject
@property (copy, nonatomic) NSString * imageString;
@property (assign, nonatomic) BOOL   selected;
@property (strong, nonatomic) NSIndexPath * indexPath;

+(instancetype)pasterNodeWithImageString:(NSString*)imageString indexPath:(NSIndexPath*)indexPath selected:(BOOL)selected;

@end
