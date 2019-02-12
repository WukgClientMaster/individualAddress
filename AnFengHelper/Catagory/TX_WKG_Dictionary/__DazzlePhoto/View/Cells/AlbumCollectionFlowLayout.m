//
//  AlbumCollectionFlowLayout.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
#import "AlbumCollectionFlowLayout.h"

@implementation AlbumCollectionFlowLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(UICollectionViewScrollDirection)scrollDirection{
    return UICollectionViewScrollDirectionVertical;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    UICollectionView *collectionView = [self collectionView];
    CGPoint offset = [collectionView contentOffset];
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    if (offset.y<0) {
        for (UICollectionViewLayoutAttributes *attrs in attributes ) {
            NSString *kind = [attrs representedElementKind];
            CGFloat deltaY = fabs(offset.y);
            if (kind == UICollectionElementKindSectionHeader) {
                CGSize headerSize = [self headerReferenceSize];
                CGRect headRect = [attrs frame];
                headRect.size.height = headerSize.height + deltaY;
                headRect.origin.y = headRect.origin.y - deltaY;
                [attrs setFrame:headRect];
                break;
            }
        }
    }
    return attributes;
}
@end
