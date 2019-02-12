//
//  MusicCollectContainerView.m
//  SmartCity
//
//  Created by 吴可高 on 2018/1/18.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "MusicCollectContainerView.h"
#import "MusicCollectionViewCell.h"
#import "SegmentSelectedModel.h"
#import "HttpPage.h"
#import "Request_dazzle_findAudioType.h"
#import "MusicCollectionViewObserver.h"
#import "MusicOptionalModel.h"
#import "MusicPauseOrPlayOptModel.h"
#import "BaseTableView.h"
#import "QMX_VideoMusicEditCell.h"
#import "QMX_MusicTool.h"

static NSString * MusicCollectionItemCellDefiner = @"MusicCollectionViewCell";
@interface MusicCollectContainerView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong,readwrite) UICollectionView * collectionView;
@property(nonatomic,strong) MusicCollectionViewObserver * collectionViewObserver;
@property(nonatomic,strong) UICollectionViewFlowLayout * flowlayout;
@property (assign, nonatomic) CGFloat  startOffsetX;
@property (copy, nonatomic) NSString * fromSegmentControllerOffSex;
@property (copy, nonatomic) NSString * previousVisibleIndexFormat;

@end

@implementation MusicCollectContainerView

-(MusicCollectionViewObserver *)collectionViewObserver{
    _collectionViewObserver = ({
        if (!_collectionViewObserver) {
            _collectionViewObserver = [MusicCollectionViewObserver shareInstance];
        }
        _collectionViewObserver;
    });
    return _collectionViewObserver;
}
#pragma mark getter methods
-(UICollectionView *)collectionView{
    _collectionView = ({
        if (!_collectionView) {
            UICollectionViewFlowLayout * layOut = [[UICollectionViewFlowLayout alloc] init];
            layOut.sectionInset = UIEdgeInsetsZero;
            layOut.minimumInteritemSpacing = 0.f;
            layOut.minimumLineSpacing = 0.f;
            layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            CGFloat height = kScreenHeight - (heightEx(47.5f)+ SC_StatusBarAndNavigationBarHeight + heightEx(65));
            layOut.itemSize = CGSizeMake(kScreenWidth, height);
            _flowlayout = layOut;
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowlayout];
            if (@available(ios 11.0,*)) {
                _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
            _collectionView.dataSource = self;
            _collectionView.delegate = self;
            _collectionView.pagingEnabled = YES;
            _collectionView.backgroundColor = [Tools colorWithHexString:@"191b2a"];
            [_collectionView registerClass:[MusicCollectionViewCell class] forCellWithReuseIdentifier:MusicCollectionItemCellDefiner];
            return _collectionView;
        }
        _collectionView;
    });
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if ([self.collectionView respondsToSelector:@selector(setLayoutMargins:)])  {
            [self.collectionView setLayoutMargins:UIEdgeInsetsZero];
        }
        [self setUpViews];
        self.visibleCurrentIndex = @"0";
        self.previousVisibleIndexFormat = @"0";
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)setSegments:(NSArray *)segments
{
    _segments = segments;
    __weak  typeof(self)weakSelf = self;
    [_segments enumerateObjectsUsingBlock:^(SegmentSelectedModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong  typeof(weakSelf)strongSelf  = weakSelf;
        if ([obj isSelected]) {
            strongSelf.visibleCurrentIndex = [@(idx)stringValue];
            * stop = YES;
        }
        else if(idx == (_segments.count -1)){
            self.visibleCurrentIndex = @"0";
        }
    }];
    [self.collectionView reloadData];
}

-(void)setCacheDataDictionary:(NSMutableDictionary *)cacheDataDictionary
{
    _cacheDataDictionary = cacheDataDictionary;
    if ([self.previousVisibleIndexFormat isEqualToString:self.visibleCurrentIndex]) {
        NSArray * visibleCells = [self.collectionView visibleCells];
        [visibleCells enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[MusicCollectionViewCell class]]) {
                MusicCollectionViewCell * cell = (MusicCollectionViewCell*)obj;
                cell.items = _cacheDataDictionary[self.visibleCurrentIndex];
            }
        }];
    }else{
        self.previousVisibleIndexFormat = self.visibleCurrentIndex;
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.visibleCurrentIndex integerValue] inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

#pragma mark - setUpViews
-(void)setUpViews{
    __weak  typeof(self)weakSelf = self;
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsZero);
    }];
}
#pragma mark
-(void)collectionScrollViewToIndex:(NSInteger)index flage:(BOOL)flage;
{
    if (index >=0 || index <= self.segments.count) {
        //是来自segmentController
        self.fromSegmentControllerOffSex = @"YES";
        self.visibleCurrentIndex = [@(index)stringValue];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        });
    }
}

#pragma mark
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[MusicCollectionViewCell class]]) {
        MusicCollectionViewCell * musicCell = (MusicCollectionViewCell *) cell;
        NSMutableArray * items;
        if ([[_cacheDataDictionary allKeys]containsObject:@"1000"]) {
            items =[_cacheDataDictionary objectForKey:@"1000"];
        }
        else{
            items =[_cacheDataDictionary objectForKey:_visibleCurrentIndex];
        }
        musicCell.items = items;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.segments.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MusicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:MusicCollectionItemCellDefiner forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    [self musicSoloCatgoryMonopolize];
    NSString * key = [NSString stringWithFormat:@"%zd",indexPath.row];
    NSArray * items = self.collectionViewObserver.cacheMutableDictionary[key];
    if (items!=nil) {
        [items enumerateObjectsUsingBlock:^(MusicOptionalModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            [model.pauseOrPlayModel setPause:YES];
        }];
    }
    if ([cell isKindOfClass:[MusicCollectionViewCell class]]) {
        MusicCollectionViewCell * musicCell = (MusicCollectionViewCell*)cell;
        for (int i = 0; i  < [musicCell.contentView subviews].count; i++) {
            UIView * contentView = [musicCell.contentView subviews][i];
            if ([contentView isKindOfClass:[BaseTableView class]]) {
                BaseTableView * tableView = (BaseTableView*)contentView;
                NSArray <QMX_VideoMusicEditCell *>* visibleCells = [tableView visibleCells];
                [visibleCells enumerateObjectsUsingBlock:^(QMX_VideoMusicEditCell  * musicCell, NSUInteger idx, BOOL * _Nonnull stop) {
                    [musicCell.player stop];
                }];
            }
        }
    }
}
//音乐独占模式
-(void)musicSoloCatgoryMonopolize{
    [[QMX_MusicTool shareInstance]cancel];
    [[QMX_MusicTool shareInstance]cancelDownloadAllTasks];
    NSArray * items = self.collectionViewObserver.cacheMutableDictionary[self.visibleCurrentIndex];
    if (items!=nil) {
        [items enumerateObjectsUsingBlock:^(MusicOptionalModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            [model.pauseOrPlayModel setPause:YES];
        }];
    }
    [[self.collectionView visibleCells]enumerateObjectsUsingBlock:^(__kindof MusicCollectionViewCell * _Nonnull musicCell, NSUInteger idx, BOOL * _Nonnull stop) {
        for (int i = 0; i  < [musicCell.contentView subviews].count; i++) {
            UIView * contentView = [musicCell.contentView subviews][i];
            if ([contentView isKindOfClass:[BaseTableView class]]) {
                BaseTableView * tableView = (BaseTableView*)contentView;
                NSArray <QMX_VideoMusicEditCell *>* visibleCells = [tableView visibleCells];
                [visibleCells enumerateObjectsUsingBlock:^(QMX_VideoMusicEditCell  * musicCell, NSUInteger idx, BOOL * _Nonnull stop) {
                    [musicCell.player stop];
                    [musicCell.play_Item_Btn setSelected:NO];
                }];
            }
        }
    }];
}

#pragma mark - UIScrollView Delegate
#pragma mark - - - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.startOffsetX = scrollView.contentOffset.x;
    self.fromSegmentControllerOffSex = @"NO";
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    /*
     CGFloat offSetX = scrollView.contentOffset.x < 0 ? 0: scrollView.contentOffset.x;
     NSUInteger index =  abs((int)(offSetX / kScreenWidth));
     if (self.delegate) {
     self.visibleCurrentIndex = [@(index)stringValue];
     [self.delegate musicCollectionContainerDidScrollView:index flage:1];
     }
     */
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.fromSegmentControllerOffSex isEqualToString:@"YES"]) {
        return;
    }
    // 1、定义获取需要的数据
    CGFloat progress = 0;
    NSInteger originalIndex = 0;
    NSInteger targetIndex = 0;
    // 2、判断是左滑还是右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x < 0 ? 0: scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    if (currentOffsetX > self.startOffsetX) { // 左滑
        // 1、计算 progress
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        // 2、计算 originalIndex
        originalIndex = currentOffsetX / scrollViewW;
        // 3、计算 targetIndex
        targetIndex = originalIndex + 1;
        if (targetIndex >= self.segments.count) {
            progress = 1;
            targetIndex = originalIndex;
        }
        // 4、如果完全划过去
        if (currentOffsetX - self.startOffsetX == scrollViewW) {
            progress = 1;
            targetIndex = originalIndex;
        }
    } else { // 右滑
        // 1、计算 progress
        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        // 2、计算 targetIndex
        targetIndex = currentOffsetX / scrollViewW;
        // 3、计算 originalIndex
        originalIndex = targetIndex + 1;
        if (originalIndex >= self.segments.count) {
            originalIndex = self.segments.count - 1;
        }
    }
    if (self.delegate && originalIndex != targetIndex) {
        self.visibleCurrentIndex = [@(targetIndex)stringValue];
        [self.delegate musicCollectionContainerDidScrollViewFromIdx:originalIndex toIndex:targetIndex flage:1];
    }
}

@end


