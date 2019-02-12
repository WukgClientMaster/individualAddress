//
//  DazzleAssetModel.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DazzleAssetModel : NSObject
@property (nonatomic, assign) PHAssetMediaType mediaType;
@property (nonatomic, assign) NSUInteger pixelWidth;
@property (nonatomic, assign) NSUInteger pixelHeight;
@property (nonatomic, strong) NSDate * modificationDate;
@property (nonatomic, copy) NSString* durationName;
@property (nonatomic, assign) CGFloat videoSize;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) BOOL favorite;
@property (nonatomic, strong) PHAsset * phAsset;
@property (nonatomic, strong) AVAsset * avAsset;
@property (nonatomic, copy) NSString* videoUrlString;
@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) UIImage * originImage;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL clould;
@property (nonatomic, copy) NSString* groupKey;
@property (nonatomic, copy) NSString* sortNum;
@end
