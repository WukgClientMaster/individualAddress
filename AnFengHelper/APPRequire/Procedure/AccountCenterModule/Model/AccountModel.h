//
//  AccountModel.h
//  AnFengHelper
//
//  Created by 智享城市iOS开发 on 2018/4/7.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AccountModel : NSObject

@property(nonatomic,copy) NSString * avatarurl;
@property(nonatomic,copy) NSString * desc;
@property(nonatomic,copy) NSString * price;
@property(nonatomic,copy) NSString * grade;//评分
@property(nonatomic,copy) NSString * soldout;//已经售出
@property(nonatomic,strong) NSArray * labels;//拥有的标签
@property(nonatomic,copy) NSString * reduce;//是否立减
@property(nonatomic,copy) NSString * freeAdmission;//返送

+(instancetype)accountWithavatar:(NSString*)avatarurl
                            desc:(NSString*)desc
                           price:(NSString*)price
                           grade:(NSString*)grade
                         soldOut:(NSString*)soldout
                          labels:(NSArray*)labels
                          reduce:(NSString*)reduce
                      freeAdmiss:(NSString*)freeAdmiss;


@end
