//
//  RangeConfig.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/23.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RangeConfig : NSObject
@property (assign, nonatomic) NSInteger pinWidth;
@property (assign, nonatomic) NSInteger thumbHeight;
@property (assign, nonatomic) NSInteger borderHeight;
@property (strong, nonatomic) UIImage * leftPinImage;
@property (strong, nonatomic) UIImage * leftCorverImage;
@property (strong, nonatomic) UIImage * centerPinImage;
@property (strong, nonatomic) UIImage * rightPigImage;
@property (strong, nonatomic) UIImage * rightCoverImage;

@end
