//
//  APPItem.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface APPItem : NSObject

@property(nonatomic,copy) NSString * img;
@property(nonatomic,copy) NSString * title;
@property(nonatomic,copy) NSString * subtitle;

+(instancetype)initializeWithImg:(NSString*)img title:(NSString*)title subtitle:(NSString*)subtitle;

@end
