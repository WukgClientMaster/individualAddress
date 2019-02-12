//
//  Request_dazzle_findAudioType.h
//  SmartCity
//
//  Created by 吴可高 on 2018/1/19.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Request_dazzle_findAudioType : JSONModel
@end

@interface Request_dazzle_findAudioFile : JSONModel
@property(nonatomic,copy) NSString * type;
@property(nonatomic,copy) NSString * name;
@property(nonatomic,copy) NSString * page;
@property(nonatomic,copy) NSString * row;

@end


