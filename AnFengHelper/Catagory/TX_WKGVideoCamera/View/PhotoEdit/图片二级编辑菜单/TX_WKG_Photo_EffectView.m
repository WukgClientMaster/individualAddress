//
//  TX_WKG_Photo_EffectView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Photo_EffectView.h"
#import "TX_WKG_Photo_EffectCollectionViewCell.h"
#import "TX_WKG_Effect_Node.h"
#import "TX_WKG_Photo_EditConfig.h"
@interface TX_WKG_Photo_EffectView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) NSIndexPath * selectedIndexPath;
@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) NSMutableArray * items;
@end

@implementation TX_WKG_Photo_EffectView
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
        layout.minimumLineSpacing = widthEx(8.f);
        layout.minimumInteritemSpacing = widthEx(8.f);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        if (_collectionView == nil) {
            _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
            _collectionView.showsHorizontalScrollIndicator = NO;
            _collectionView.backgroundColor = [UIColor clearColor];
            _collectionView.delegate   = self;
            _collectionView.dataSource = self;
            [_collectionView registerClass:[TX_WKG_Photo_EffectCollectionViewCell class] forCellWithReuseIdentifier:@"ReuseIdentifier"];
        }
        _collectionView;
    });
    return _collectionView;
}

- (NSIndexPath *)selectEffectIndexPath{
    if(!_selectedIndexPath){
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _selectedIndexPath;
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
    NSArray * titles = @[@"默认",@"粉嫩",@"浪漫",@"清新",@"唯美",@"怀旧",@"蓝调",@"清凉",@"日系",@"冷淡",@"珊瑚"];
    NSArray * optionals = @[@"",@"fennen.png",@"langman.png",@"qingxin.png",@"weimei.png",@"huaijiu.png",@"landiao.png",@"qingliang.png",@"rixi.png",@"filter_cold.png",@"filter_coral.png"];
    dispatch_async(dispatch_queue_create("com.wkg.cn", DISPATCH_QUEUE_CONCURRENT), ^{
        for (int i = 0 ; i < titles.count; i++) {
            BOOL selected = (i==0) ? YES : NO;
            NSString * optionalName = optionals[i];
            NSString * path = [[NSBundle mainBundle] pathForResource:@"FilterResource" ofType:@"bundle"];
            if (path != nil) {
                path = [path stringByAppendingPathComponent:optionalName];
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                if (i == 0) {
                    image = nil;
                }
                TX_WKG_Effect_Node * node = [TX_WKG_Effect_Node effectNodeWithImageString:@"tx_wkg_photo_effect_default" text:titles[i] selected:selected optionalImage:image];
                [self.items addObject:node];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
}

-(void)resetPhotoEffectStatus{
    if (self.items.count == 0 || self.items ==nil)return;
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    TX_WKG_Effect_Node * node = self.items[self.selectedIndexPath.row];
    node.selected = YES;
    dispatch_async(dispatch_queue_create("com.wkg.cn", DISPATCH_QUEUE_CONCURRENT), ^{
        [self.items enumerateObjectsUsingBlock:^(TX_WKG_Effect_Node *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
            if ([obj isEqual:node]) {
                obj.selected = YES;
            }
        }];
    });
    dispatch_barrier_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
    });
}

-(void)setup{
    __weak typeof(self)weakSelf = self;
    [self addSubview:self.collectionView];
    __block CGFloat padding = widthEx(12.f);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(padding);
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-padding);
        make.bottom.and.top.mas_equalTo(weakSelf);
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
    TX_WKG_Photo_EffectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReuseIdentifier" forIndexPath:indexPath];
    TX_WKG_Effect_Node * node = self.items[indexPath.row];
    cell.effectNode = node;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row != self.selectedIndexPath.row){
        self.selectedIndexPath = indexPath;
        __block TX_WKG_Effect_Node * node = self.items[indexPath.row];
        [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_PHOTO_ADD_PASTER_EFFECTIVE_NOTIFICATION_DEFINER  object:node];
        dispatch_async(dispatch_queue_create("com.wkg.cn", DISPATCH_QUEUE_CONCURRENT), ^{
            [self.items enumerateObjectsUsingBlock:^(TX_WKG_Effect_Node *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    return CGSizeMake(widthEx(65), collectionView.frame.size.height);
}


@end
