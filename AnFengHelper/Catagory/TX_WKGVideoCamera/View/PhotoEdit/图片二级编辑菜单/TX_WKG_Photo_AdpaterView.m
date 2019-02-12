//
//  TX_WKG_Photo_AdpaterView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/7/3.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Photo_AdpaterView.h"
#import "TX_WKG_Photo_AdapterCollectionCell.h"
#import "TX_WKG_Clips_Node.h"

@interface TX_WKG_Photo_AdpaterView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) NSMutableArray * collects;
@property (strong, nonatomic) NSIndexPath * selectIndexPath;

@end

@implementation TX_WKG_Photo_AdpaterView
-(TX_WKG_Photo_BothWay_Slider *)bothway_slider{
    _bothway_slider = ({
        if (!_bothway_slider) {
            CGFloat padding = widthEx(19.f);
            CGRect frame = CGRectMake(padding, widthEx(1.f), KScreenWidth - 2 * padding, widthEx(16.f));
            _bothway_slider = [[TX_WKG_Photo_BothWay_Slider alloc]initWithFrame:frame];
        }
        _bothway_slider;
    });
    return _bothway_slider;
}

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
            _collectionView.backgroundColor = [UIColor whiteColor];
            _collectionView.delegate   = self;
            _collectionView.dataSource = self;
            [_collectionView registerClass:[TX_WKG_Photo_AdapterCollectionCell class] forCellWithReuseIdentifier:@"ReuseIdentifier"];
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
    NSArray * items = @[@{@"title":@"亮度",@"normalImg":@"tx_wkg_adpator_slight_noraml",@"selectImg":@"tx_wkg_adpator_slight_selected",@"selected":@(YES)},
                        @{@"title":@"饱和度",@"normalImg":@"tx_wkg_adpator_stature_noraml",@"selectImg":@"tx_wkg_adpator_stature_selected",@"selected":@(NO)},
                        @{@"title":@"色温",@"normalImg":@"tx_wkg_adpator_colortemp_normal",@"selectImg":@"tx_wkg_adpator_colortemp_selected",@"selected":@(NO)},
                        @{@"title":@"锐化",@"normalImg":@"tx_wkg_adpator_sharpen_normal",@"selectImg":@"tx_wkg_adpator_sharpen_selected",@"selected":@(NO)},
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

-(void)setup{
    __weak typeof(self)weakSelf = self;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.mas_top).with.offset(widthEx(24.f));
    }];
    [self addSubview:self.bothway_slider];
}

-(void)resetPhotoAdaptorStatus{
    if (self.collects.count == 0 || self.collects ==nil)return;
    self.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
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

#pragma mark - collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TX_WKG_Photo_AdapterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReuseIdentifier" forIndexPath:indexPath];
    cell.adapterNode = self.collects[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath != self.selectIndexPath) {
        //重置滑动视图
        self.selectIndexPath = indexPath;
        __block TX_WKG_Clips_Node * node = self.collects[indexPath.row];
        NSString * title = node.title;
        if ([self.bothway_slider.jsonData[title]floatValue] == 0.f) {
            [self.bothway_slider initSetViewsWith:title];
        }else{
            [self.bothway_slider setSliderWithValue:[self.bothway_slider.jsonData[title]floatValue] cata:title];
        }
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
