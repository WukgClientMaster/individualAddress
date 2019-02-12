//
//  ViewMusicOptionalModel.h
//  SmartCity
//
//  Created by 吴可高 on 2018/1/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicCollectContainerView.h"
#import "MusicSegmentView.h"
@interface ViewMusicOptionalModel : NSObject<MusicCollectionContainerDidScrollViewDelegate,MusicSegmentViewDidSelectedDelegate>

@property(nonatomic,strong) MusicSegmentView * segmentView;
@property(nonatomic,strong) MusicCollectContainerView * collectionContainerView;


@end
