//
//  DazlleAlbumCell.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DazzleAssetModel.h"

typedef void (^DazlleAlbumDidSelectedCallback)(DazzleAssetModel * model);
@interface DazlleAlbumCell : UICollectionViewCell
@property (strong, nonatomic) DazzleAssetModel * model;
@property (copy, nonatomic) DazlleAlbumDidSelectedCallback callback;
@end
