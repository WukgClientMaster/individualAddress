//
//  PHAlbumCategoryView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DazzleAssetModel.h"

@protocol PHAlbumCategoryOptionalDelegate<NSObject>
-(void)albumCategoryDidDelete:(DazzleAssetModel*)assetModel shouldRemovegroup:(NSString*)removegroup;

@end

@interface PHAlbumCategoryView : UIView
@property (strong, nonatomic) NSMutableDictionary * data;
@property (strong, nonatomic) NSMutableArray * items;
@property (weak, nonatomic) id <PHAlbumCategoryOptionalDelegate> delegate;

@end
