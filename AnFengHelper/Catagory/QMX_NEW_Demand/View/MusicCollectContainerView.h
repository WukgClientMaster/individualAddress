//
//  MusicCollectContainerView.h
//  SmartCity
//
//  Created by 吴可高 on 2018/1/18.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MusicCollectionContainerDidScrollViewDelegate
@optional
-(void)musicCollectionContainerDidScrollViewFromIdx:(NSUInteger)fromIdx toIndex:(NSUInteger)toIdx flage:(BOOL)flage;

@end

@interface MusicCollectContainerView : UIView
@property(nonatomic,strong) NSArray * segments;
@property(nonatomic,strong,readonly) UICollectionView * collectionView;
@property(nonatomic,strong) NSMutableDictionary * cacheDataDictionary;
@property(nonatomic,copy) NSString * visibleCurrentIndex;
@property(nonatomic,weak) id<MusicCollectionContainerDidScrollViewDelegate> delegate;
-(void)collectionScrollViewToIndex:(NSInteger)index flage:(BOOL)flage;
//音乐独占模式
-(void)musicSoloCatgoryMonopolize;
@end

