//
//  WKG_VideoCoverView.h
//  SmartCity
//
//  Created by 吴可高 on 2018/1/25.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MediaClipsCallBack)(UIImage * cover,NSString * optString);
@interface WKG_VideoCoverView : UIView
@property(nonatomic,strong) NSMutableArray * items;
@property(nonatomic,strong,readonly) UICollectionView * collectionView;
@property(nonatomic,copy) MediaClipsCallBack callback;
@property(nonatomic,copy) NSString * videoUrl;

@end

