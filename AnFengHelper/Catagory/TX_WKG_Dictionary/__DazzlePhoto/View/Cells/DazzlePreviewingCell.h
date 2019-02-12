//
//  DazzlePreviewingCell.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DazzlePreviewingCell;
#import "DazzleAssetModel.h"

typedef void (^DazzlePreviewingCellDidSelectedCallback)(DazzleAssetModel * model,NSString* selectedStatus,DazzlePreviewingCell * cell);
@interface DazzlePreviewingCell : UICollectionViewCell
@property (strong, nonatomic) DazzleAssetModel * model;
@property (strong, nonatomic) NSIndexPath * indexPath;
@property (copy, nonatomic) DazzlePreviewingCellDidSelectedCallback didSelectedCallback;

@end
