//
//  HorizontalLayOut.m
//  AnFengHelper
//
//  Created by 吴可高 on 2018/5/20.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "HorizontalLayOut.h"

@implementation HorizontalLayOut

-(void)prepareLayout{
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(85, 100);
    self.minimumLineSpacing = 1.f;
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
- (NSArray *)deepCopyWithArray:(NSArray *)arr {
    NSMutableArray *arrM = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attr in arr) {
        [arrM addObject:[attr copy]];
    }
    return arrM;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attrs = [self deepCopyWithArray:[super layoutAttributesForElementsInRect:rect]];
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    CGFloat collectionViewCenterX = self.collectionView.frame.size.width * 0.5;
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        CGFloat scale = 1 - fabs(attr.center.x - contentOffsetX - collectionViewCenterX) /self.collectionView.bounds.size.width;
        attr.transform = CGAffineTransformMakeScale(scale, scale);
        attr.transform3D = CATransform3DScale(attr.transform3D, scale, scale,1);
    }
    return attrs;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGRect rect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width,self.collectionView.bounds.size.height);
    NSArray *attrs = [super layoutAttributesForElementsInRect:rect];
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    CGFloat collectionViewCenterX = self.collectionView.frame.size.width * 0.5;
    CGFloat minDistance = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        CGFloat distance = attr.center.x - contentOffsetX - collectionViewCenterX;
        if (fabs(distance) < fabs(minDistance)) {
            minDistance = distance;
        }
    }
    proposedContentOffset.x += minDistance;
    return proposedContentOffset;
}

@end
