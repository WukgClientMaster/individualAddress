//
//  AssertDataManager.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DazzleAssetModel.h"
#import "DazzleAssetCollectionModel.h"
#import "Dazzle_Video_PreViewingController.h"

@interface AssertDataManager : NSObject
@property (weak, nonatomic) Dazzle_Video_PreViewingController * containerViewController;
+(instancetype)shared;

-(void)queryAuthorityData:(void(^)(BOOL isAuthority))callback;

-(void)queryAllPhotos:(void(^)(BOOL status, NSArray<DazzleAssetModel*> * datas))callback failure:(void(^)(NSString * msg))failure;

-(void)queryCollections:(void(^)(BOOL status, NSArray<DazzleAssetCollectionModel*> * datas))callback failure:(void(^)(NSString * msg))failure;

-(void)queryAssetsWithCollection:(DazzleAssetCollectionModel *)collectionModel handel:(void(^)(BOOL status, NSArray<DazzleAssetModel*> * datas))callback failure:(void(^)(NSString * msg))failure;


@end
