//
//  TX_WKG_Camera_EffectView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/11.
//  Copyright © 2018年 NRH. All rights reserved.
//

@protocol TX_WKG_Camera_Effect_Delegate <NSObject>
- (void)onSetFilter:(UIImage*)filterImage;
@end

#import <UIKit/UIKit.h>

@interface TX_WKG_Camera_EffectView : UIView
@property (strong,readwrite,nonatomic) UICollectionView * effectCollectionView;
@property (nonatomic,readwrite,strong) NSIndexPath *selectEffectIndexPath;
@property (nonatomic,readwrite,strong) NSIndexPath *selectedIndexPath;
@property (weak, nonatomic)id <TX_WKG_Camera_Effect_Delegate> delegate;
@end
