//
//  PHAlbumCategoryView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "PHAlbumCategoryView.h"
#import "DazlleAlbumCell.h"

@interface PHAlbumCategoryView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    //正在拖拽的indexpath
    NSIndexPath *_dragingIndexPath;
    //目标位置
    NSIndexPath *_targetIndexPath;
}
@property (strong, nonatomic) UICollectionView * collectionView;
@end
@implementation PHAlbumCategoryView

#pragma mark - getter methods

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumInteritemSpacing = 1.f;
        layout.minimumLineSpacing = 1.f;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, kScreen_Width - 30,80) collectionViewLayout:layout];
        _collectionView.delegate   = self;
        _collectionView.dataSource = self;
        if (@available(ios 11.0,*)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[DazlleAlbumCell class] forCellWithReuseIdentifier:NSStringFromClass([DazlleAlbumCell class])];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
        longPress.minimumPressDuration = 0.3f;
        [_collectionView setUserInteractionEnabled:YES];
        [_collectionView addGestureRecognizer:longPress];
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup{
    [self addSubview:self.collectionView];
}

-(void)setItems:(NSMutableArray *)items{
    _items = items;
    if (_items.count == 0 || _items == nil)return;
    [_items enumerateObjectsUsingBlock:^(DazzleAssetModel * model, NSUInteger idx, BOOL * _Nonnull stop) {
        model.sortNum = [NSString stringWithFormat:@" %zd ",(idx+1)];
    }];
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:(self.items.count -1) inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionRight) animated:YES];
    });
}

-(void)setData:(NSMutableDictionary *)data{
    _data = data;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).with.offset(15.f);
        make.top.mas_equalTo(self.mas_top).with.offset(10.f);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(-10.f);
        make.right.mas_equalTo(self.mas_right).with.offset(-15.f);
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DazlleAlbumCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DazlleAlbumCell class]) forIndexPath:indexPath];
    if (!cell) {
        cell = [[DazlleAlbumCell alloc]initWithFrame:CGRectZero];
    }
    cell.model = self.items[indexPath.row];
    __weak typeof(self)weakSelf = self;
    cell.callback = ^(DazzleAssetModel *model) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.items removeObject:model];
        [strongSelf.collectionView reloadData];
        [strongSelf didRemoveDataResponder:model];
    };
    return cell;
}

-(void)didRemoveDataResponder:(DazzleAssetModel*)model{
    if (model == nil)return;
    NSMutableDictionary * json  = self.data[model.groupKey];
    NSMutableArray * data = json[@"data"];
    [data removeObject:model];
    NSString * shouldRemovegroup = (data.count==0) ?@"YES" : @"NO";
    if (self.delegate && [self.delegate respondsToSelector:@selector(albumCategoryDidDelete:shouldRemovegroup:)]) {
        [self.delegate albumCategoryDidDelete:model shouldRemovegroup:shouldRemovegroup];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemSize = 80.f;
    return CGSizeMake(itemSize, itemSize);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DazzleAssetModel * model = self.items[indexPath.row];
    [self.items removeObject:model];
    [self.collectionView reloadData];
    [self didRemoveDataResponder:model];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.f;
}
#pragma mark - iOS9 之前的方法
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    DazzleAssetModel * model = self.items[sourceIndexPath.row];
    [self.items removeObject:model];
    [self.items insertObject:model atIndex:destinationIndexPath.row];
}

- (void)longPressMethod:(UILongPressGestureRecognizer *)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
            if (indexPath == nil) {
                break;
            }
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
        { // 手势改变
            [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:self.collectionView]];
        }
            break;
        case UIGestureRecognizerStateEnded:
        { // 手势结束
            [self.collectionView endInteractiveMovement];
        }
            break;
        default: //手势其他状态
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

@end
