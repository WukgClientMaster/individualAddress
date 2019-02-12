//
//  PhotoDowloadTool.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/29.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "PhotoDowloadTool.h"

@implementation PhotoDowloadTool

+ (PHImageRequestID)getMediumQualityAVAssetWithPHAsset:(PHAsset *)phAsset startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud progressHandler:(void (^)(double progress))progressHandler completion:(void(^)(AVAsset *asset))completion failed:(void(^)(NSDictionary *info))failed{
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeMediumQualityFormat;
    options.networkAccessAllowed = NO;
    return [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && asset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(asset);
                }
            });
        }else {
            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                PHImageRequestID cloudRequestId = 0;
                PHVideoRequestOptions *cloudOptions = [[PHVideoRequestOptions alloc] init];
                cloudOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeMediumQualityFormat;
                cloudOptions.networkAccessAllowed = YES;
                cloudOptions.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressHandler) {
                            progressHandler(progress);
                        }
                    });
                };
                cloudRequestId = [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:cloudOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    if (downloadFinined && asset) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) {
                                completion(asset);
                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failed) {
                                failed(info);
                            }
                        });
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (startRequestIcloud) {
                        startRequestIcloud(cloudRequestId);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failed) {
                        failed(info);
                    }
                });
            }
        }
    }];
}

+ (PHImageRequestID)getHighQualityAVAssetWithPHAsset:(PHAsset *)phAsset startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud progressHandler:(void (^)(double progress))progressHandler completion:(void(^)(AVAsset *asset))completion failed:(void(^)(NSDictionary *info))failed{
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = NO;
    return [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && asset) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(asset);
                }
            });
        }else {
            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue]) {
                PHImageRequestID cloudRequestId = 0;
                PHVideoRequestOptions *cloudOptions = [[PHVideoRequestOptions alloc] init];
                cloudOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
                cloudOptions.networkAccessAllowed = YES;
                cloudOptions.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressHandler) {
                            progressHandler(progress);
                        }
                    });
                };
                cloudRequestId = [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset options:cloudOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    if (downloadFinined && asset) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) {
                                completion(asset);
                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failed) {
                                failed(info);
                            }
                        });
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (startRequestIcloud) {
                        startRequestIcloud(cloudRequestId);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failed) {
                        failed(info);
                    }
                });
            }
        }
    }];
}

+ (PHImageRequestID)getHighQualityFormatPhoto:(PHAsset *)asset size:(CGSize)size startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud progressHandler:(void (^)(double progress))progressHandler completion:(void(^)(UIImage *image))completion failed:(void(^)(NSDictionary *info))failed {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.networkAccessAllowed = NO;
    
    PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(result);
                }
            });
        }else {
            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue] && ![[info objectForKey:PHImageCancelledKey] boolValue]) {
                PHImageRequestID cloudRequestId = 0;
                PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
                option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                option.resizeMode = PHImageRequestOptionsResizeModeFast;
                option.networkAccessAllowed = YES;
                option.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressHandler) {
                            progressHandler(progress);
                        }
                    });
                };
                cloudRequestId = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    if (downloadFinined && result) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) {
                                completion(result);
                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failed) {
                                failed(info);
                            }
                        });
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (startRequestIcloud) {
                        startRequestIcloud(cloudRequestId);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failed) {
                        failed(info);
                    }
                });
            }
        }
    }];
    return requestID;
}

+ (PHImageRequestID)getImageData:(PHAsset *)asset startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud progressHandler:(void (^)(double progress))progressHandler completion:(void(^)(NSData *imageData, UIImageOrientation orientation))completion failed:(void(^)(NSDictionary *info))failed {
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.networkAccessAllowed = NO;
    option.synchronous = NO;
    
    PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        if (downloadFinined && imageData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(imageData, orientation);
                }
            });
        }else {
            if ([[info objectForKey:PHImageResultIsInCloudKey] boolValue] && ![[info objectForKey:PHImageCancelledKey] boolValue]) {
                PHImageRequestID cloudRequestId = 0;
                PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
                option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                option.resizeMode = PHImageRequestOptionsResizeModeFast;
                option.networkAccessAllowed = YES;
                option.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressHandler) {
                            progressHandler(progress);
                        }
                    });
                };
                cloudRequestId = [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                    if (downloadFinined && imageData) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (completion) {
                                completion(imageData, orientation);
                            }
                        });
                    }else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (failed) {
                                failed(info);
                            }
                        });
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (startRequestIcloud) {
                        startRequestIcloud(cloudRequestId);
                    }
                });
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failed) {
                        failed(info);
                    }
                });
            }
        }
    }];
    return requestID;
}

@end
