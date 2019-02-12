//
//  TX_WKG_Scrawl_Node.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/18.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef TX_WKG_PhotoScrawlContentViewType
#define TX_WKG_PhotoScrawlContentViewType
typedef NS_ENUM(NSInteger, TX_WKG_PhotoScrawlContentDrawType){
    TX_WKG_PhotoScrawlContentClear,
    TX_WKG_PhotoScrawlContentWrite
};
#endif

@interface TX_WKG_Scrawl_Node : NSObject
@property (strong, nonatomic) UIColor * color;
@property (assign, nonatomic) CGFloat  lineWidth;
@property (assign, nonatomic) BOOL  selected;
@property (assign, nonatomic) TX_WKG_PhotoScrawlContentDrawType drawType;

-(instancetype)initWithColor:(UIColor*)color lineWidth:(CGFloat)lineWidth isSelected:(BOOL)selected;

@end
