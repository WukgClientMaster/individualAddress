//
//  DazzleAssetModel.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "DazzleAssetModel.h"

@implementation DazzleAssetModel
- (id)copyWithZone:(NSZone *)zone {
    DazzleAssetModel * model = [[[self class] allocWithZone:zone] init];
    model.mediaType   = self.mediaType;
    model.pixelWidth  = self.pixelWidth;
    model.pixelHeight = self.pixelHeight;
    model.modificationDate = self.modificationDate;
    model.durationName = self.durationName;
    model.favorite = self.favorite;
    model.phAsset = self.phAsset;
	model.videoSize = self.videoSize;
    model.avAsset = self.avAsset;
    model.videoUrlString = self.videoUrlString;
    model.image = self.image;
	model.clould = self.clould;
	model.duration = self.duration;
    model.originImage = self.originImage;
    model.selected = self.selected;
    model.groupKey = self.groupKey;
    return model;
}

@end
