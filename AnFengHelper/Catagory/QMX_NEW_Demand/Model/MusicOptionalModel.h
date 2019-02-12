//
//  MusicOptionalModel.h
//  SmartCity
//
//  Created by 吴可高 on 2018/1/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicPauseOrPlayOptModel.h"

@interface MusicOptionalModel : NSObject
@property(nonatomic,copy) NSString * authorName;
@property(nonatomic,copy) NSString * coverUrl;
@property(nonatomic,copy) NSString * createTime;
@property(nonatomic,copy) NSString * delFlag;
@property(nonatomic,copy) NSString * musicID;
@property(nonatomic,copy) NSString * modifyTime;
@property(nonatomic,copy) NSString * name;
@property(nonatomic,copy) NSString * type;
@property(nonatomic,copy) NSString * typeName;
@property(nonatomic,copy) NSString * url;
@property(nonatomic,copy) NSString * videoTimeSize;
@property (assign, nonatomic,getter=isDidSelected) BOOL  didSelected;

@property(nonatomic,strong) MusicPauseOrPlayOptModel * pauseOrPlayModel;
@end
