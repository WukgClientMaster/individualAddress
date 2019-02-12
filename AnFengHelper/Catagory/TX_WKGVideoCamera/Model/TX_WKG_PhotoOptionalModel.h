//
//  TX_WKG_PhotoOptionalModel.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/15.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TX_WKG_PhotoOptionalModel : NSObject
@property (strong, nonatomic) NSString * imageString;
@property (strong, nonatomic) NSString * title;

-(instancetype)initOptionalModelWithImgString:(NSString*)imgString title:(NSString*)title;

@end
