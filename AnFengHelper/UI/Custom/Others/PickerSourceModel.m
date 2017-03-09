//
//  PickerSourceModel.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/5/11.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "PickerSourceModel.h"
#import "MunicipalModel.h"
@implementation PickerSourceModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"idx":@"id"};
}

@end
