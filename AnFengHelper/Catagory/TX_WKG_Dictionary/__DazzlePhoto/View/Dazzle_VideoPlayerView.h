//
//  Dazzle_VideoPlayerView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DazzleAssetModel.h"
#import "AlbumVideoPreView.h"
@interface Dazzle_VideoPlayerView : UIView
@property (strong, nonatomic) DazzleAssetModel *assetModel;
@property (strong,readonly,nonatomic) AlbumVideoPreView * videoPreview;

-(void)stopVideo;

@end
