//
//  SegmentSelectedModel.m
//  SmartCity
//
//  Created by 吴可高 on 2018/1/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "SegmentSelectedModel.h"

@implementation SegmentSelectedModel


+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"catgoryID":@"id",@"title":@"name"};
}

+(instancetype)segmentWithTitle:(NSString*)title normal:(UIColor*)noramlColor selected:(UIColor*)selectColor isSelected:(BOOL)selected{
    SegmentSelectedModel * model = [[SegmentSelectedModel alloc]init];
    model.title = title;
    model.normalStateColor   = noramlColor;
    model.selectedStateColor = selectColor;
    model.selected = selected;
    return model;
}
@end
