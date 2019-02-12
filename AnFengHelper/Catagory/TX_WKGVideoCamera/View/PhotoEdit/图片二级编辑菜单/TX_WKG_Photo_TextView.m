//
//  TX_WKG_Photo_TextView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/5.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Photo_TextView.h"
#import "TX_WKG_Photo_ScrawlViewCell.h"
#import "TX_WKG_Photo_EditConfig.h"

@interface TX_WKG_Photo_TextView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong,readwrite,nonatomic) TX_WKG_Scrawl_Node * selectedNode;
@property (strong, nonatomic) NSMutableArray * collects;
@end

@implementation TX_WKG_Photo_TextView
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
            [_collectionView registerClass:[TX_WKG_Photo_ScrawlViewCell class] forCellWithReuseIdentifier:@"ReuseIdentifier"];
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

-(void)loadDatas{
    NSArray * colors = @[UIColorFromRGB(0x000000),UIColorFromRGB(0xffffff),
                         UIColorFromRGB(0x999999),UIColorFromRGB(0x703800),
                         UIColorFromRGB(0xf3382c),UIColorFromRGB(0xff852b),
                         UIColorFromRGB(0xffbf00),UIColorFromRGB(0xfff52f),
                         UIColorFromRGB(0x95ed31),UIColorFromRGB(0x2cc542),
                         UIColorFromRGB(0x3fddc1),UIColorFromRGB(0x00b4fe),
                         UIColorFromRGB(0x436cff),UIColorFromRGB(0x7c19c9)
                         ];
    for (int i = 0; i < colors.count; i++) {
        TX_WKG_Scrawl_Node * node = [[TX_WKG_Scrawl_Node alloc]initWithColor:colors[i] lineWidth:2.f isSelected:(i == 0 ? YES : NO)];
        if (i == 0) {
            self.selectedNode = node;
        }
        [self.collects addObject:node];
    }
}

-(void)setup{
    __weak typeof(self)weakSelf = self;
    __block CGFloat left_padding = widthEx(20.f);
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.mas_centerY);
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(left_padding);
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-left_padding);
        make.height.mas_equalTo(heightEx(42.f));
    }];
}
-(void)resetPhotoTextStatus{
    if (self.collects.count == 0 || self.collects ==nil)return;
    self.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    TX_WKG_Scrawl_Node * node = self.collects[self.selectIndexPath.row];
    node.selected = YES;
    self.selectedNode = node;
    dispatch_async(dispatch_queue_create("com.wkg.cn", DISPATCH_QUEUE_CONCURRENT), ^{
        [self.collects enumerateObjectsUsingBlock:^(TX_WKG_Scrawl_Node *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

#pragma mark - collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TX_WKG_Photo_ScrawlViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReuseIdentifier" forIndexPath:indexPath];
    cell.scrawlNode = self.collects[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath != self.selectIndexPath) {
        self.selectIndexPath = indexPath;
        __block TX_WKG_Scrawl_Node * node = self.collects[indexPath.row];
        self.selectedNode = node;
        self.selectedNode.color  = node.color;
        self.selectedNode.drawType = TX_WKG_PhotoScrawlContentWrite;
        [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_PHOTO_INSERT_TEXTWORD_NOTIFICATION_DEFINER  object:self.selectedNode.color];
        dispatch_queue_t queue = dispatch_queue_create("com.wkg.cn", NULL);
        dispatch_async(queue, ^{
            [self.collects enumerateObjectsUsingBlock:^(TX_WKG_Scrawl_Node *  _Nonnull enumNode, NSUInteger idx, BOOL * _Nonnull stop) {
                [enumNode setSelected:NO];
                if ([node isEqual:enumNode]) {
                    [node setSelected:YES];
                }
            }];
            dispatch_barrier_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        });
    }
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return widthEx(0.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    TX_WKG_Scrawl_Node * node = self.collects[indexPath.row];
    CGFloat width = 0.f;
    width = node.selected ? widthEx(30 *1.4) : widthEx(30);
    return CGSizeMake(width, collectionView.frame.size.height);
}

@end
