//
//  AssertDataManager.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "AssertDataManager.h"
#import <Photos/PHFetchOptions.h>
#import <Photos/PHAsset.h>
#import <Photos/PHCollection.h>
#import <Photos/PHFetchResult.h>
#import <Photos/PHAssetResource.h>

static AssertDataManager * _assertDataManager = nil;

@implementation AssertDataManager

+(instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_assertDataManager == nil) {
            _assertDataManager = [[AssertDataManager alloc]init];
        }
    });
    return _assertDataManager;
}

-(void)queryAuthorityData:(void(^)(BOOL isAuthority))callback{
    __weak typeof(self)weakSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSBundle hx_localizedStringForKey:@"无法访问相册"] message:[NSBundle hx_localizedStringForKey:@"请在设置-隐私-相册中允许访问相册"] preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:[NSBundle hx_localizedStringForKey:@"取消"] style:UIAlertActionStyleDefault handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:[NSBundle hx_localizedStringForKey:@"设置"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }]];
                if (strongSelf.containerViewController) {
                    [strongSelf.containerViewController presentViewController:alert animated:YES completion:nil];
                }
                if (callback) {
                    callback(NO);
                }
            }else{
                if (callback) {
                    callback(YES);
                }
            }
        });
    }];
}

-(void)queryAllPhotos:(void(^)(BOOL status, NSArray<DazzleAssetModel*> * datas))callback failure:(void(^)(NSString * msg))failure{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
    PHFetchResult *assets   = [PHAsset fetchAssetsWithOptions:options];
    if (assets.count == 0 || assets == nil) {
        if (failure) {
            failure(@"获取系统资源失败.");
        }
        return;
    }
	__block NSMutableArray * assetDatas = [NSMutableArray array];
	dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
	dispatch_async(queue, ^{
		[assets enumerateObjectsUsingBlock:^(PHAsset* asset, NSUInteger idx, BOOL * _Nonnull stop) {
			DazzleAssetModel * assetModel =  [[DazzleAssetModel alloc]init];
			assetModel.mediaType = asset.mediaType;
			if ([[asset valueForKey:@"isCloudPlaceholder"] boolValue]) {
				assetModel.clould = YES;
			}else{
				assetModel.clould = NO;
			}
			assetModel.pixelWidth = asset.pixelWidth;
			assetModel.pixelHeight = asset.pixelHeight;
			assetModel.modificationDate = asset.modificationDate;
			assetModel.favorite = asset.favorite;
			assetModel.phAsset = asset;
			assetModel.image = nil;
			if (assetModel.mediaType == PHAssetMediaTypeVideo) {
				NSString * duration = [self getTimeFormatterFromDurationSecond:asset.duration];
				assetModel.durationName = duration;
				assetModel.duration = asset.duration;
			}
			[assetDatas addObject:assetModel];
		}];
		dispatch_async(dispatch_get_main_queue(), ^{
			if (callback) {
				callback(YES,[assetDatas copy]);
			}
		});
	});
}

-(void)queryCollections:(void(^)(BOOL status, NSArray<DazzleAssetCollectionModel*> * datas))callback failure:(void(^)(NSString * msg))failure{
    PHFetchResult<PHAssetCollection *> *collections =  [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    if (collections.count == 0 || collections == nil) {
        if (failure) {
            failure(@"获取智能相册失败.");
            return;
        }
    }
    __block NSMutableArray * collectionDatas = [NSMutableArray array];
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        [collections enumerateObjectsUsingBlock:^(PHAssetCollection * collection, NSUInteger idx, BOOL * _Nonnull stop) {
            DazzleAssetCollectionModel * collectionModel = [DazzleAssetCollectionModel new];
            NSString * name = [self transFormPhotoTitle:collection.localizedTitle];
            collectionModel.collectionName = name;
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
			options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
            PHFetchResult <PHAsset*> *assets   = [PHAsset fetchAssetsInAssetCollection:collection options:options];
            collectionModel.assetCount = assets.count;
            collectionModel.dazzleAssets = assets;
            collectionModel.assetCollection = collection;
            if (assets.count !=0) {
                [collectionDatas addObject:collectionModel];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(YES,[collectionDatas copy]);
            }
        });
    });
}

-(void)queryAssetsWithCollection:(DazzleAssetCollectionModel *)collectionModel handel:(void(^)(BOOL status, NSArray<DazzleAssetModel*> * datas))callback failure:(void(^)(NSString * msg))failure{
    if (collectionModel == nil) return;
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:NO]];
    PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collectionModel.assetCollection options:options];
    if (assets.count == 0 || assets == nil) {
        if (failure) {
            failure(@"获取系统资源失败.");
        }
        return;
    }
	__block NSMutableArray * assetDatas = [NSMutableArray array];
	dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
	dispatch_async(queue, ^{
		[assets enumerateObjectsUsingBlock:^(PHAsset* asset, NSUInteger idx, BOOL * _Nonnull stop) {
			DazzleAssetModel * assetModel =  [[DazzleAssetModel alloc]init];
			if ([[asset valueForKey:@"isCloudPlaceholder"] boolValue]) {
				assetModel.clould = YES;
			}else{
				assetModel.clould = NO;
			}
			assetModel.mediaType = asset.mediaType;
			assetModel.pixelWidth = asset.pixelWidth;
			assetModel.pixelHeight = asset.pixelHeight;
			assetModel.modificationDate = asset.modificationDate;
			assetModel.favorite = asset.favorite;
			assetModel.phAsset = asset;
			assetModel.image = nil;
			if (assetModel.mediaType == PHAssetMediaTypeVideo) {
				NSString * duration = [self getTimeFormatterFromDurationSecond:asset.duration];
				assetModel.durationName = duration;
			}
			[assetDatas addObject:assetModel];
		}];
		dispatch_async(dispatch_get_main_queue(), ^{
			if (callback) {
				callback(YES,[assetDatas copy]);
			}
			
		});
	});	
}

- (NSString *)transFormPhotoTitle:(NSString *)englishName {
    NSString *photoName;
    if ([englishName isEqualToString:@"Bursts"]) {
        photoName = @"连拍快照";
    }else if([englishName isEqualToString:@"Recently Added"]){
        photoName = @"最近添加";
    }else if([englishName isEqualToString:@"Screenshots"]){
        photoName = @"屏幕快照";
    }else if([englishName isEqualToString:@"Camera Roll"]){
        photoName = @"相机胶卷";
    }else if([englishName isEqualToString:@"Selfies"]){
        photoName = @"自拍";
    }else if([englishName isEqualToString:@"My Photo Stream"]){
        photoName = @"我的照片流";
    }else if([englishName isEqualToString:@"Videos"]){
        photoName = @"视频";
    }else if([englishName isEqualToString:@"All Photos"]){
        photoName = @"所有照片";
    }else if([englishName isEqualToString:@"Slo-mo"]){
        photoName = @"慢动作";
    }else if([englishName isEqualToString:@"Recently Deleted"]){
        photoName = @"最近删除";
    }else if([englishName isEqualToString:@"Favorites"]){
        photoName = @"个人收藏";
    }else if([englishName isEqualToString:@"Panoramas"]){
        photoName = @"全景照片";
    }else {
        photoName = englishName;
    }
    return photoName;
}

- (NSString *)getTimeFormatterFromDurationSecond:(NSInteger)duration {
    NSString *newTime;
    if (duration < 10) {
        newTime = [NSString stringWithFormat:@"00:0%zd",duration];
    } else if (duration < 60) {
        newTime = [NSString stringWithFormat:@"00:%zd",duration];
    } else {
        NSInteger min = duration / 60;
        NSInteger sec = duration - (min * 60);
        if (sec < 10) {
            newTime = [NSString stringWithFormat:@"%zd:0%zd",min,sec];
        } else {
            newTime = [NSString stringWithFormat:@"%zd:%zd",min,sec];
        }
    }
    return newTime;
}

@end
