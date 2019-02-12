//
//  TX_WKG_Photo_ClipsView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/24.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Photo_ClipsView.h"
#import "TX_WKG_Photo_Clips_ViewCell.h"
#import "TX_WKG_Clips_Node.h"

@interface TX_WKG_Photo_ClipsView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) NSMutableArray * collects;
@property (strong, nonatomic) NSIndexPath * selectIndexPath;

@end

@implementation TX_WKG_Photo_ClipsView

-(NSMutableArray *)collects{
    _collects = ({
        if (!_collects) {
            _collects = [NSMutableArray array];
        }
        _collects;
    });
    return _collects;
}

-(UICollectionView *)collectionView{
    _collectionView = ({
        if (!_collectionView) {
            UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.minimumLineSpacing = 0.f;
            _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
            _collectionView.showsHorizontalScrollIndicator = NO;
            _collectionView.backgroundColor = [UIColor clearColor];
            _collectionView.delegate   = self;
            _collectionView.dataSource = self;
            [_collectionView registerClass:[TX_WKG_Photo_Clips_ViewCell class] forCellWithReuseIdentifier:@"ReuseIdentifier"];
        }
        _collectionView;
    });
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadDatas];
        [self setup];
    }
    return self;
}
-(NSIndexPath *)selectIndexPath{
    _selectIndexPath = ({
        if (!_selectIndexPath) {
            _selectIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        }
        _selectIndexPath;
    });
    return _selectIndexPath;
}


-(void)loadDatas{
    NSArray * items = @[@{@"title":@"旋转",@"normalImg":@"tx_wkg_photo_clips_rortae_normal",@"selectImg":@"tx_wkg_photo_clips_rortae_selected",@"selected":@(NO)},
                        @{@"title":@"自由",@"normalImg":@"tx_wkg_photo_clips_freeSize_normal",@"selectImg":@"tx_wkg_photo_clips_freeSize_selected",@"selected":@(YES)},
                        @{@"title":@"原始",@"normalImg":@"tx_wkg_photo_clips_origin_normal",@"selectImg":@"tx_wkg_photo_clips_origin_selected",@"selected":@(NO)},
                        @{@"title":@"1-1",@"normalImg":@"tx_wkg_photo_clips_1:1_normal",@"selectImg":@"tx_wkg_photo_clips_1:1_selected",@"selected":@(NO)},
                        @{@"title":@"4-3",@"normalImg":@"tx_wkg_photo_clips_4:3_normal",@"selectImg":@"tx_wkg_photo_clips_4:3_selected",@"selected":@(NO)},
                        @{@"title":@"3-4",@"normalImg":@"tx_wkg_photo_clips_3:4_normal",@"selectImg":@"tx_wkg_photo_clips_3:4_selected",@"selected":@(NO)},
                        @{@"title":@"9-16",@"normalImg":@"tx_wkg_photo_clips_9:16_normal",@"selectImg":@"tx_wkg_photo_clips_9:16_selected",@"selected":@(NO)},
                        @{@"title":@"16-9",@"normalImg":@"tx_wkg_photo_clips_16:9_normal",@"selectImg":@"tx_wkg_photo_clips_16:9_selected",@"selected":@(NO)},
                        ];
    dispatch_async(dispatch_queue_create("com.wkg.cn", DISPATCH_QUEUE_CONCURRENT), ^{
        for (int i = 0; i < items.count; i++) {
            NSDictionary * json = items[i];
            TX_WKG_Clips_Node  * node = [TX_WKG_Clips_Node clipsNodeWithTitle:json[@"title"] normalImgString:json[@"normalImg"] selectedImgString:json[@"selectImg"] seleceted:[json[@"selected"]boolValue]];
            [self.collects addObject:node];
        }
        dispatch_barrier_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
   
}

-(void)resetPhotoClipsStatus{
    if (self.collects.count == 0 || self.collects ==nil)return;
    self.selectIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    TX_WKG_Clips_Node * node = self.collects[self.selectIndexPath.row];
    node.selected = YES;
    dispatch_async(dispatch_queue_create("com.wkg.cn", DISPATCH_QUEUE_CONCURRENT), ^{
        [self.collects enumerateObjectsUsingBlock:^(TX_WKG_Clips_Node *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
            if ([obj isEqual:node]) {
                obj.selected = YES;
            }
        }];
    });
    dispatch_barrier_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:self.selectIndexPath atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
    });
}

-(void)setup{
    __weak typeof(self)weakSelf = self;
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.and.right.mas_equalTo(weakSelf);
    make.left.mas_equalTo(weakSelf.mas_left).with.offset(widthEx(12.f));
    }];
}

#pragma mark - collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TX_WKG_Photo_Clips_ViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReuseIdentifier" forIndexPath:indexPath];
    cell.clips_node = self.collects[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath != self.selectIndexPath) {
        self.selectIndexPath = indexPath;
        __block TX_WKG_Clips_Node * node = self.collects[indexPath.row];
        dispatch_queue_t queue = dispatch_queue_create("com.wkg.cn", NULL);
        dispatch_async(queue, ^{
            [self.collects enumerateObjectsUsingBlock:^(TX_WKG_Clips_Node *  _Nonnull enumNode, NSUInteger idx, BOOL * _Nonnull stop) {
                [enumNode setSelected:NO];
                if ([node isEqual:enumNode]) {
                    [node setSelected:YES];
                }
            }];
            dispatch_barrier_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        });
        if (self.clipsCallback) {
            self.clipsCallback(node.title);
        }
    }else{
        if (indexPath.row == 0) {
            TX_WKG_Clips_Node * node = self.collects[indexPath.row];
            if (self.clipsCallback) {
                self.clipsCallback(node.title);
            }
        }
    }
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return widthEx(0.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(widthEx(65.f), collectionView.frame.size.height);
}
@end
