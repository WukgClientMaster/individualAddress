//
//  DazzleAssetCollectionModel.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DazzleAssetModel.h"

@interface DazzleAssetCollectionModel : NSObject
@property (strong, nonatomic) NSString* collectionName;
@property (strong, nonatomic) UIImage * coverImage;
@property (assign, nonatomic) NSInteger assetCount;
@property (strong, nonatomic) PHAssetCollection * assetCollection;
@property (strong, nonatomic) PHFetchResult <PHAsset*> * dazzleAssets;
@end
