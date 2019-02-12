//
//  TX_WKG_PhotoCollectionViewCell.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/15.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TX_WKG_PhotoOptionalModel.h"

@interface TX_WKG_PhotoCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) TX_WKG_PhotoOptionalModel * photoOptionalModel;
@property (strong,readonly,nonatomic) UILabel *label;
@property (strong,readonly,nonatomic) UIImageView * imageView;

@end
