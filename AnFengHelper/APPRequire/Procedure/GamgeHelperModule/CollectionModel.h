//
//  CollectionModel.h
//  AnFengHelper
//
//  Created by 吴可高 on 2018/5/20.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionModel : NSObject
@property(nonatomic,copy) NSString *  urlString;

+(instancetype)collectionModelWithImageString:(NSString*)urlString;

@end
