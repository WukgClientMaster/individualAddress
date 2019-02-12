//
//  TX_WKG_Photo_Node.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TX_WKG_Photo_Node : NSObject
@property (copy, nonatomic) NSString * node;
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (strong, nonatomic) UIBezierPath * bezierPath;
@end
