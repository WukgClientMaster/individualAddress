//
//  TX_WKG_Photo_PasterMenu_View.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Photo_PasterMenu_View.h"
#import "PasterImageViewCell.h"
#import "TX_WKG_Paster_Node.h"
#import "TX_WKG_Photo_EditConfig.h"

@interface TX_WKG_Photo_PasterMenu_View()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) NSIndexPath * selectedIndexPath;
@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) NSMutableArray * items;
@end
@implementation TX_WKG_Photo_PasterMenu_View

-(NSMutableArray *)items{
    _items = ({
        if (!_items) {
            _items = [NSMutableArray array];
        }
        _items;
    });
    return _items;
}

-(UICollectionView *)collectionView{
    _collectionView = ({
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0.f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        if (_collectionView == nil) {
            _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
            _collectionView.showsHorizontalScrollIndicator = NO;
            _collectionView.backgroundColor = [UIColor clearColor];
            _collectionView.delegate   = self;
            _collectionView.dataSource = self;
            [_collectionView registerClass:[PasterImageViewCell class] forCellWithReuseIdentifier:@"ReuseIdentifier"];
        }
        _collectionView;
    });
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self loadDatas];
    }
    return self;
}

-(void)loadDatas{
    dispatch_async(dispatch_queue_create("com.wkg.cn", DISPATCH_QUEUE_CONCURRENT), ^{
        for (int i = 0 ; i < 7; i++) {
            BOOL selected = NO;
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            NSString * imageString  = [NSString stringWithFormat:@"decal_%d",i];
            TX_WKG_Paster_Node * node = [TX_WKG_Paster_Node pasterNodeWithImageString:imageString indexPath:indexPath selected:selected];
            [self.items addObject:node];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
}

-(void)resetSelectedStatus{
    self.selectedIndexPath = nil;
    dispatch_async(dispatch_queue_create("com.wkg.cn", DISPATCH_QUEUE_CONCURRENT), ^{
        [self.items enumerateObjectsUsingBlock:^(TX_WKG_Paster_Node *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
        }];
    });
    dispatch_barrier_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
    });
}

-(void)setSelectedPasterItemWithIndexPath:(NSIndexPath*)indexPath status:(BOOL)status{
    if (self.items.count == 0 || self.items ==nil)return;
    if (indexPath == nil)return;
    if (indexPath.row >= self.items.count)return;
    self.selectedIndexPath = indexPath;
    __block TX_WKG_Paster_Node * node = self.items[indexPath.row];
    dispatch_async(dispatch_queue_create("com.wkg.cn", DISPATCH_QUEUE_CONCURRENT), ^{
        [self.items enumerateObjectsUsingBlock:^(TX_WKG_Paster_Node *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
            if ([obj isEqual:node]) {
                obj.selected = status;
            }
        }];
    });
    dispatch_barrier_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
    });
}

-(void)setup{
    __weak typeof(self)weakSelf = self;
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf).insets(UIEdgeInsetsZero);
    }];
}
#pragma mark - collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PasterImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReuseIdentifier" forIndexPath:indexPath];
    TX_WKG_Paster_Node * node = self.items[indexPath.row];
    cell.pasterNode = node;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row != self.selectedIndexPath.row || self.selectedIndexPath == nil){
        self.selectedIndexPath = indexPath;
        __block TX_WKG_Paster_Node * node = self.items[indexPath.row];
        [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_PHOTO_ADD_PASTER_EFFECTIVE_NOTIFICATION_DEFINER  object:node];
        dispatch_async(dispatch_queue_create("com.wkg.cn", DISPATCH_QUEUE_CONCURRENT), ^{
            [self.items enumerateObjectsUsingBlock:^(TX_WKG_Paster_Node *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.selected = NO;
                if ([obj isEqual:node]) {
                    obj.selected = YES;
                }
            }];
        });
        dispatch_barrier_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return widthEx(12.5f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(widthEx(90), collectionView.frame.size.height);
}

@end
