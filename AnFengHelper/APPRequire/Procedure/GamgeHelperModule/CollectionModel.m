//
//  CollectionModel.m
//  AnFengHelper
//
//  Created by 吴可高 on 2018/5/20.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "CollectionModel.h"

@implementation CollectionModel
+(instancetype)collectionModelWithImageString:(NSString*)urlString{
    CollectionModel * model = [CollectionModel new];
    model.urlString = urlString;
    return model;
}

@end
