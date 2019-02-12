//
//  MusicCollectionViewCell.h
//  SmartCity
//
//  Created by 吴可高 on 2018/1/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseTableView;
@interface MusicCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong,readonly) BaseTableView * tableView;
@property(nonatomic,strong) NSMutableArray * items;
@end
