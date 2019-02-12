//
//  Dazzle_PhotoPresentContainerView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DazzleAssetCollectionModel;
typedef void (^Dazzle_PhotoPresentDidSelectedCallback)(DazzleAssetCollectionModel * model);

@interface Dazzle_PhotoPresentContainerView : UIView
@property (strong, nonatomic) NSArray * datas;
@property (copy, nonatomic) Dazzle_PhotoPresentDidSelectedCallback callback;

@end
