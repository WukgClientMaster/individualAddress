//
//  ViewMusicOptionalModel.m
//  SmartCity
//
//  Created by 吴可高 on 2018/1/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "ViewMusicOptionalModel.h"
@implementation ViewMusicOptionalModel
-(void)musicCollectionContainerDidScrollViewFromIdx:(NSUInteger)fromIdx toIndex:(NSUInteger)toIdx flage:(BOOL)flage{
    if (self.segmentView) {
        [self.segmentView  selectCollViewDidScrollViewFromIdx:fromIdx toIdx:toIdx flage:flage];
    }
}


-(void)musicSegmentViewDidSelected:(NSUInteger)index flage:(BOOL)flage;
{
    if (self.collectionContainerView) {
        [self.collectionContainerView collectionScrollViewToIndex:index flage:flage];
    }
}

@end
