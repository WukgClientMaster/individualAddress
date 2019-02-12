//
//  CategoryCell.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/28.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DazzleAssetCollectionModel.h"

@interface CategoryCell : UITableViewCell
@property (strong, nonatomic) DazzleAssetCollectionModel * model;

+(CategoryCell *) cellWithTableView:(UITableView*)tableView;

@end
