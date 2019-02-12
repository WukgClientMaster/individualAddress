//
//  TX_WKG_PhotoOptionalModel.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/15.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_PhotoOptionalModel.h"

@implementation TX_WKG_PhotoOptionalModel

-(instancetype)initOptionalModelWithImgString:(NSString*)imgString title:(NSString*)title{
    TX_WKG_PhotoOptionalModel   * optionalModel =  [[TX_WKG_PhotoOptionalModel alloc]init];
    optionalModel.imageString = imgString;
    optionalModel.title = title;
    return optionalModel;
}

@end
