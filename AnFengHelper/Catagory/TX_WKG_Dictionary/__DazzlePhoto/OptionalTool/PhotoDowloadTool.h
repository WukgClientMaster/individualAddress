//
//  PhotoDowloadTool.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/29.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoDowloadTool : NSObject
/**  根据PHAsset获取中等质量的视频AVAsset对象  */
+ (PHImageRequestID)getMediumQualityAVAssetWithPHAsset:(PHAsset *)phAsset startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud progressHandler:(void (^)(double progress))progressHandler completion:(void(^)(AVAsset *asset))completion failed:(void(^)(NSDictionary *info))failed;

/**  根据PHAsset获取高等质量的视频AVAsset对象  */
+ (PHImageRequestID)getHighQualityAVAssetWithPHAsset:(PHAsset *)phAsset startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud progressHandler:(void (^)(double progress))progressHandler completion:(void(^)(AVAsset *asset))completion failed:(void(^)(NSDictionary *info))failed;


+ (PHImageRequestID)getHighQualityFormatPhoto:(PHAsset *)asset size:(CGSize)size startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud progressHandler:(void (^)(double progress))progressHandler completion:(void(^)(UIImage *image))completion failed:(void(^)(NSDictionary *info))failed;

/**
 根据PHAsset获取imageData
 @param asset PHAsset
 @param startRequestIcloud 开始请求iCloud上的资源
 @param progressHandler iCloud下载进度
 @param completion 完成后的block
 @param failed 失败后的block
 @return 请求id
 */
+ (PHImageRequestID)getImageData:(PHAsset *)asset startRequestIcloud:(void (^)(PHImageRequestID cloudRequestId))startRequestIcloud progressHandler:(void (^)(double progress))progressHandler completion:(void(^)(NSData *imageData, UIImageOrientation orientation))completion failed:(void(^)(NSDictionary *info))failed;
@end
