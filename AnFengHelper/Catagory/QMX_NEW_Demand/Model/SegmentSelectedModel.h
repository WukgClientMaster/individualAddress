//
//  SegmentSelectedModel.h
//  SmartCity
//
//  Created by 吴可高 on 2018/1/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SegmentSelectedModel : NSObject
@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) UIColor * normalStateColor;
@property(nonatomic,strong) UIColor * selectedStateColor;
@property(nonatomic,assign,getter =isSelected) BOOL selected;
@property(nonatomic,assign) CGFloat fontSize;

//response attribute
@property(nonatomic,copy) NSString * createTime;
@property(nonatomic,copy) NSString * catgoryID;
@property(nonatomic,copy) NSString * modifyTime;

+(instancetype)segmentWithTitle:(NSString*)title normal:(UIColor*)noramlColor selected:(UIColor*)selectColor isSelected:(BOOL)selected;

@end
