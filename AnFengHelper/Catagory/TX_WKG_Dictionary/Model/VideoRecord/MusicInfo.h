//
//  MusicInfo.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/13.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicInfo : NSObject
@property (copy, nonatomic) NSString  * musicPath;
@property (assign, nonatomic) CGFloat  start;
@property (assign, nonatomic) CGFloat  duration;
@end
