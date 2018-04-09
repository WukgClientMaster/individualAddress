//
//  AccountModel.m
//  AnFengHelper
//
//  Created by 智享城市iOS开发 on 2018/4/7.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel

+(instancetype)accountWithavatar:(NSString*)avatarurl
                           desc:(NSString*)desc
                          price:(NSString*)price
                          grade:(NSString*)grade
                        soldOut:(NSString*)soldout
                         labels:(NSArray*)labels
                         reduce:(NSString*)reduce
                     freeAdmiss:(NSString*)freeAdmiss{
    AccountModel * model = [AccountModel accountWithDesc:desc price:price grade:grade soldOut:soldout labels:labels reduce:reduce freeAdmiss:freeAdmiss];
    model.avatarurl = avatarurl;
    return model;
}

+(instancetype)accountWithDesc:(NSString*)desc
                         price:(NSString*)price
                         grade:(NSString*)grade
                       soldOut:(NSString*)soldout
                        labels:(NSArray*)labels
                        reduce:(NSString*)reduce
                    freeAdmiss:(NSString*)freeAdmiss{
    AccountModel * model = [AccountModel new];
    model.desc = desc;
    model.price = price;
    model.grade = grade;
    model.soldout = soldout;
    model.labels = labels;
    model.reduce = reduce;
    model.freeAdmission = freeAdmiss;
    return model;
}
@end
