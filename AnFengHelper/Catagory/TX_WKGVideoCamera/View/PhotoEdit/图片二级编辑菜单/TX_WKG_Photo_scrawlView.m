//
//  TX_WKG_Photo_scrawlView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/18.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_Photo_scrawlView.h"
#import "TX_WKG_Photo_ScrawlViewCell.h"
#import "TX_WKG_Photo_EditConfig.h"


#define  TX_WKG_Scrawl_PencilFont_ItemTagValue  1000
@interface TX_WKG_Photo_scrawlView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) NSMutableArray * collects;
@property (strong, nonatomic) NSMutableArray * pencils;

@property (strong, nonatomic) UIButton * eraser_item;
@property (strong, nonatomic) UIButton * selectedPencilItem;
@property (strong,readwrite,nonatomic) TX_WKG_Scrawl_Node * selectedNode;

@end

@implementation TX_WKG_Photo_scrawlView
#pragma mark - IBOutlet Events
-(void)eraserEvents:(UIButton*)args{
    args.selected = !args.selected;
    if (args.selected) {
        self.selectedNode.drawType = TX_WKG_PhotoScrawlContentClear;
    }else{
        self.selectedNode.drawType = TX_WKG_PhotoScrawlContentWrite;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_SCRAWL_DEFINIER object:self.selectedNode];
}

-(void)pencilEvnets:(UIButton*)args{
    if (![args isEqual:self.selectedPencilItem]) {
        args.selected = YES;
        self.selectedPencilItem.selected = NO;
        self.selectedPencilItem = args;
        NSDictionary * json = self.pencils[args.tag - TX_WKG_Scrawl_PencilFont_ItemTagValue];
        NSInteger lineWidth = [json[@"title"]integerValue];
        self.selectedNode.lineWidth = lineWidth;
        self.selectedNode.drawType = TX_WKG_PhotoScrawlContentWrite;
        [self.eraser_item setSelected:NO];
        [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_SCRAWL_DEFINIER  object:self.selectedNode];
    }
}

#pragma mark - getter methods
-(NSMutableArray *)pencils{
    _pencils = ({
        if (!_pencils) {
            _pencils = [NSMutableArray array];
        }
        _pencils;
    });
    return _pencils;
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

-(UIButton *)eraser_item{
    _eraser_item = ({
        if (!_eraser_item) {
            _eraser_item = [UIButton buttonWithType:UIButtonTypeCustom];
            [_eraser_item setImage:[UIImage imageNamed:@"tx_wkg_eraser_normal"] forState:UIControlStateNormal];
            [_eraser_item setImage:[UIImage imageNamed:@"tx_wkg_eraser_selected"] forState:UIControlStateSelected];
            _eraser_item.imageView.contentMode = UIViewContentModeCenter;
            [_eraser_item addTarget:self action:@selector(eraserEvents:) forControlEvents:UIControlEventTouchUpInside];
        }
        _eraser_item;
    });
    return _eraser_item;
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
                    UIColorFromRGB(0x95ed31),UIColorFromRGB(0x2cc542),UIColorFromRGB(0x3fddc1),
                         UIColorFromRGB(0x00b4fe),UIColorFromRGB(0x436cff),
                         UIColorFromRGB(0x7c19c9)
                         ];
    for (int i = 0; i < colors.count; i++) {
        TX_WKG_Scrawl_Node * node = [[TX_WKG_Scrawl_Node alloc]initWithColor:colors[i] lineWidth:2.f isSelected:(i == 0 ? YES : NO)];
        if (i == 0) {
            self.selectedNode = node;
        }
        [self.collects addObject:node];
    }
}

-(void)loadPencilSubViews{
    NSArray * items = @[@{@"title":@"2",@"normal":@"tx_wkg_num1_pencil_normal",@"selected":@"tx_wkg_num1_pencil_selected"},
                        @{@"title":@"4",@"normal":@"tx_wkg_num2_pencil_normal",@"selected":@"tx_wkg_num2_pencil_selected"},
                        @{@"title":@"6",@"normal":@"tx_wkg_num3_pencil_normal",@"selected":@"tx_wkg_num3_pencil_selected"},
                        @{@"title":@"8",@"normal":@"tx_wkg_num4_pencil_normal",@"selected":@"tx_wkg_num4_pencil_selected"}];
    [self.pencils addObjectsFromArray:items];
    NSMutableArray * containers = [NSMutableArray array];
    for (int i = 0; i< items.count; i++) {
        NSDictionary * json = items[i];
        UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
        [item setImage:[UIImage imageNamed:json[@"normal"]] forState:UIControlStateNormal];
        [item setImage:[UIImage imageNamed:json[@"selected"]] forState:UIControlStateSelected];
        [item addTarget:self action:@selector(pencilEvnets:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = TX_WKG_Scrawl_PencilFont_ItemTagValue + i;
        if (i == 0) {
            self.selectedPencilItem = item;
            [item setSelected:YES];
        }
        [self addSubview:item];
        [containers addObject:item];
    }
    __weak typeof(self)weakSelf = self;
    __block CGFloat padding = widthEx(25.f);
    CGFloat margin = padding * (0.5 + 0.75 + 1.f);
    __block CGFloat left_originX  = (kScreenWidth - margin -items.count *widthEx(35.f))/2.f;
    __block UIButton * anchor = nil;
    [containers enumerateObjectsUsingBlock:^(UIButton *  obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(widthEx(35.f) ,widthEx(35.f)));
        make.top.mas_equalTo(weakSelf.collectionView.mas_bottom).with.offset(heightEx(4.f));
            if (anchor == nil) {
           make.left.mas_equalTo(weakSelf.mas_left).with.offset(left_originX);
            }else{
                make.left.mas_equalTo(anchor.mas_right).with.offset(padding);
            }
        }];
        anchor = obj;
    }];
}

-(void)setup{
    __weak typeof(self)weakSelf = self;
    [self addSubview:self.eraser_item];
    __block CGFloat left_padding = widthEx(20.f);
    [self.eraser_item mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(left_padding);
        make.top.mas_equalTo(weakSelf.mas_top).with.offset(left_padding*0.75);
        make.size.mas_equalTo(CGSizeMake(widthEx(35), heightEx(40.f)));
    }];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.eraser_item.mas_centerY);
        make.left.mas_equalTo(weakSelf.eraser_item.mas_right).with.offset(widthEx(18.f));
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-widthEx(8.f));
        make.height.mas_equalTo(heightEx(42.f));
    }];
    [self loadPencilSubViews];
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
        CGFloat lineWidth = self.selectedNode.lineWidth;
        self.selectedNode = node;
        self.selectedNode.lineWidth = lineWidth;
        self.selectedNode.color     = node.color;
        self.selectedNode.drawType  = TX_WKG_PhotoScrawlContentWrite;
        [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_SCRAWL_DEFINIER  object:self.selectedNode];
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
    [self.eraser_item setSelected:NO];
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
