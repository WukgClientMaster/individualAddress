//
//  TX_WKG_PhotoMenuEditView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/15.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_PhotoMenuEditView.h"
#import "TX_WKG_PhotoOptionalModel.h"
#import "TX_WKG_PhotoCollectionViewCell.h"
#import "TX_WKG_Photo_MosaicView.h"
#import "TX_WKG_Photo_scrawlView.h"
#import "TX_WKG_Photo_TextView.h"
#import "TX_WKG_Photo_PasterMenu_View.h"
#import "TX_WKG_Photo_EffectView.h"
#import "TX_WKG_Paster_Node.h"
#import "TX_WKG_Effect_Node.h"
#import "TX_WKG_Photo_EditConfig.h"
@interface TX_WKG_PhotoMenuEditView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) NSMutableArray * items;
@property (strong,readwrite,nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) TX_WKG_Photo_MosaicView * mosaicView;
@property (strong, nonatomic) TX_WKG_Photo_scrawlView * scrawlView;
@property (strong, nonatomic) TX_WKG_Photo_TextView * textView;
@property (strong, nonatomic) TX_WKG_Photo_PasterMenu_View * pasterMenuView;
@property (strong, nonatomic) TX_WKG_Photo_EffectView * effectView;
@property (strong, nonatomic) NSMutableArray * removeSubViews;
@property (copy, nonatomic) NSString * menuFormat;

@end
@implementation TX_WKG_PhotoMenuEditView
#pragma mark - getter methods
-(TX_WKG_Photo_EffectView *)effectView{
    _effectView = ({
        if (!_effectView) {
            _effectView  = [[TX_WKG_Photo_EffectView alloc]initWithFrame:CGRectZero];
        }
        _effectView;
    });
    return _effectView;
}
-(TX_WKG_Photo_AdpaterView *)adaperView{
    _adaperView = ({
        if (!_adaperView) {
            _adaperView = [[TX_WKG_Photo_AdpaterView alloc]initWithFrame:CGRectZero];
        }
        _adaperView;
    });
    return _adaperView;
}

-(TX_WKG_Photo_PasterMenu_View *)pasterMenuView{
    _pasterMenuView = ({
        if (!_pasterMenuView) {
            _pasterMenuView = [[TX_WKG_Photo_PasterMenu_View alloc]initWithFrame:CGRectZero];
        }
        _pasterMenuView;
    });
    return _pasterMenuView;
}

-(TX_WKG_PhotoMenuOptionalView *)optionalView{
    _optionalView = ({
        if (!_optionalView) {
            _optionalView  = [[TX_WKG_PhotoMenuOptionalView alloc]initWithFrame:CGRectZero];
            __weak typeof(self)weakSelf = self;
            _optionalView.callback = ^(NSString *title) {
                if (weakSelf.optionalAssetsCallback) {
                    NSString * string = weakSelf.optionalView.photoMenuType ==  TX_WKG_PhotoMenuEdit_Global_Optional_Type ? @"全局撤销": weakSelf.menuFormat;
                    weakSelf.optionalAssetsCallback(string,title);
                }
            };
        }
        _optionalView;
    });
    return _optionalView;
}

-(NSMutableArray *)removeSubViews{
    _removeSubViews = ({
        if (!_removeSubViews) {
            _removeSubViews = [NSMutableArray array];
        }
        _removeSubViews;
    });
    return _removeSubViews;
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
            [_collectionView registerClass:[TX_WKG_PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"ReuseIdentifier"];
        }
        _collectionView;
    });
    return _collectionView;
}
-(TX_WKG_Photo_TextView *)textView{
    _textView = ({
        if (!_textView) {
            _textView = [[TX_WKG_Photo_TextView alloc]init];
            _textView.backgroundColor = [UIColor whiteColor];
        }
        _textView;
    });
    return _textView;
}
-(TX_WKG_Photo_ClipsView *)clipsView{
    _clipsView = ({
        if (!_clipsView) {
            __weak typeof(self)weakSelf = self;
            _clipsView = [[TX_WKG_Photo_ClipsView alloc]initWithFrame:CGRectZero];
            _clipsView.backgroundColor = [UIColor whiteColor];
            _clipsView.clipsCallback = ^(NSString *title) {
                if (weakSelf.optionalAssetsCallback) {
                    weakSelf.optionalAssetsCallback(@"裁剪旋转",title);
                }
            };
        }
        _clipsView;
    });
    return _clipsView;
}

-(TX_WKG_Photo_scrawlView *)scrawlView{
    _scrawlView = ({
        if (!_scrawlView) {
            _scrawlView = [[TX_WKG_Photo_scrawlView alloc]initWithFrame:CGRectZero];
            _scrawlView.backgroundColor = [UIColor whiteColor];
        }
        _scrawlView;
    });
    return _scrawlView;
}

-(TX_WKG_Photo_MosaicView *)mosaicView{
    _mosaicView = ({
        if (!_mosaicView) {
            _mosaicView = [[TX_WKG_Photo_MosaicView alloc]initWithFrame:CGRectZero];
            __weak typeof(self)weakSelf = self;
            _mosaicView.backgroundColor = [UIColor whiteColor];
            _mosaicView.mosaicCallback = ^(NSString *title) {
                if (weakSelf.optionalAssetsCallback) {
                    weakSelf.optionalAssetsCallback(weakSelf.menuFormat,title);
                }
            };
        }
        _mosaicView;
    });
    return _mosaicView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  setup];
    }
    return self;
}

-(NSMutableArray *)items{
    _items = ({
        if (!_items) {
            _items = [NSMutableArray array];
        }
        _items;
    });
    return _items;
}

-(void)loadData{
    NSArray *  datas = @[
                         @{@"image":@"tx_wkg_photo_beauty",@"title":@"滤镜"},
                         @{@"image":@"tx_wkg_photo_clipsRotate",@"title":@"裁剪旋转"},
                         @{@"image":@"tx_wkg_photo_charlet",@"title":@"贴图"},
                         @{@"image":@"tx_wkg_photo_text",@"title":@"文本"},
                         @{@"image":@"tx_wkg_photo_adaptor",@"title":@"调节"},
                         @{@"image":@"tx_wkg_photo_scrawl",@"title":@"涂鸦"},
                         @{@"image":@"tx_wkg_photo_ mosaic",@"title":@"马赛克"},
                         ];
    for (int i = 0; i < datas.count; i++) {
        NSDictionary *json =  datas[i];
        TX_WKG_PhotoOptionalModel * optionalModel = [[TX_WKG_PhotoOptionalModel alloc]initOptionalModelWithImgString:json[@"image"] title:json[@"title"]];
        [self.items addObject:optionalModel];
    }
}

-(void)setup{
    __weak typeof(self)weakSelf = self;
    [self loadData];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.mas_top);
        make.height.mas_equalTo(@(heightEx(100)));
    }];
}

-(void)settingPhotoOptionViewHidden:(BOOL)hidden{
    [self.optionalView setHidden:hidden];
}

-(void)closeMenuView{
    [self.removeSubViews enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        obj = nil;
    }];
    dispatch_barrier_async(dispatch_get_main_queue(), ^{
        [self.removeSubViews removeAllObjects];
    });
}

-(void)loadPhotoScrawlView{
    __weak typeof(self)weakSelf = self;
    self.menuFormat = @"涂鸦";
    self.backgroundColor = [UIColor whiteColor];
    if (![[self subviews]containsObject:self.scrawlView]) {
        self.scrawlView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.scrawlView];
        if (weakSelf.optionalAssetsCallback) {
            weakSelf.optionalAssetsCallback(self.menuFormat,@"涂鸦");
        }
    }
    if (![self.removeSubViews containsObject:self.scrawlView]) {
        [self.removeSubViews  addObject:self.scrawlView];
    }
    if (![[self subviews]containsObject:self.optionalView]) {
        self.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Normal_Optional_Type;
        [self addSubview:self.optionalView];
        [self.optionalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf.mas_bottom);
            make.height.mas_equalTo(heightEx(45.f));
        }];
    }else{
        self.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Normal_Optional_Type;
    }
    [self.scrawlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.mas_top);
        make.height.mas_equalTo(@(heightEx(100)));
    }];
    [self bringSubviewToFront:self.scrawlView];
}

-(void)loadPhotoPasterView{
    self.menuFormat = @"贴图";
    self.backgroundColor = [UIColor whiteColor];
    __weak typeof(self)weakSelf = self;
    if (![[self subviews]containsObject:self.pasterMenuView]) {
        self.pasterMenuView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.pasterMenuView];
    }
    if (![self.removeSubViews containsObject:self.pasterMenuView]) {
        [self.removeSubViews  addObject:self.pasterMenuView];
    }
    if (![[self subviews]containsObject:self.optionalView]) {
        self.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Middle_Paster_Optional_Event_Type;
        [self addSubview:self.optionalView];
        [self.optionalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf.mas_bottom);
            make.height.mas_equalTo(heightEx(45.f));
        }];
    }else{
        self.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Middle_Paster_Optional_Event_Type;
    }
    [self.pasterMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.mas_top);
        make.height.mas_equalTo(@(heightEx(100)));
    }];
    [self bringSubviewToFront:self.pasterMenuView];
}

-(void)loadPhotoEffectView{
    self.menuFormat = @"滤镜";
    self.backgroundColor = [UIColor whiteColor];
    __weak typeof(self)weakSelf = self;
    if (![[self subviews]containsObject:self.effectView]) {
        self.effectView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.effectView];
        if (weakSelf.optionalAssetsCallback) {
            TX_WKG_Effect_Node * node = [TX_WKG_Effect_Node effectNodeWithImageString:@"" text:@"默认" selected:NO optionalImage:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_PHOTO_ADD_PASTER_EFFECTIVE_NOTIFICATION_DEFINER  object:node];
            weakSelf.optionalAssetsCallback(self.menuFormat,@"滤镜");
        }
    }
    if (![self.removeSubViews containsObject:self.effectView]) {
        [self.removeSubViews  addObject:self.effectView];
    }
    if (![[self subviews]containsObject:self.optionalView]) {
        self.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Clips_Optional_Type;
        [self addSubview:self.optionalView];
        [self.optionalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf.mas_bottom);
            make.height.mas_equalTo(heightEx(45.f));
        }];
    }else{
        self.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Clips_Optional_Type;
    }
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.mas_top);
        make.height.mas_equalTo(@(heightEx(100)));
    }];
    [self bringSubviewToFront:self.effectView];
}

-(void)loadPhotoClpisView{
    self.menuFormat = @"裁剪旋转";
    self.backgroundColor = [UIColor whiteColor];
    __weak typeof(self)weakSelf = self;
    if (![[self subviews]containsObject:self.clipsView]) {
        self.clipsView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.clipsView];
        if (weakSelf.optionalAssetsCallback) {
            weakSelf.optionalAssetsCallback(self.menuFormat,@"裁剪");
        }
    }
    if (![self.removeSubViews containsObject:self.clipsView]) {
        [self.removeSubViews  addObject:self.clipsView];
    }
    if (![[self subviews]containsObject:self.optionalView]) {
        self.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Clips_Optional_Type;
        [self addSubview:self.optionalView];
        [self.optionalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf.mas_bottom);
            make.height.mas_equalTo(heightEx(45.f));
        }];
    }else{
        self.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Clips_Optional_Type;
    }
    [self.clipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.mas_top);
        make.height.mas_equalTo(@(heightEx(100)));
    }];
    [self bringSubviewToFront:self.clipsView];
}

-(void)loadPhotoAdapterView{
    self.menuFormat = @"调节";
    self.backgroundColor = [UIColor clearColor];
    __weak typeof(self)weakSelf = self;
    if (![[self subviews]containsObject:self.adaperView]) {
        [self addSubview:self.adaperView];
    }
    if (![self.removeSubViews containsObject:self.adaperView]) {
        [self.removeSubViews  addObject:self.adaperView];
    }
    if (![[self subviews]containsObject:self.optionalView]) {
        self.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Clips_Optional_Type;
        [self addSubview:self.optionalView];
        [self.optionalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf.mas_bottom);
            make.height.mas_equalTo(heightEx(45.f));
        }];
    }else{
        self.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Clips_Optional_Type;
    }
    [self.adaperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.mas_top);
        make.height.mas_equalTo(@(heightEx(100)));
    }];
    [self bringSubviewToFront:self.adaperView];
}

-(void)loadPhotoRotateView{
    self.menuFormat = @"旋转";
}

-(void)loadPhotoTextView{
    self.menuFormat = @"文本";
    self.backgroundColor = [UIColor whiteColor];
    __weak typeof(self)weakSelf = self;
    if (![[self subviews]containsObject:self.textView]) {
        self.textView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.textView];
        if (weakSelf.optionalAssetsCallback) {
            weakSelf.optionalAssetsCallback(self.menuFormat,@"文本");
        }
    }
    if (![self.removeSubViews containsObject:self.textView]) {
        [self.removeSubViews  addObject:self.textView];
    }
    if (![[self subviews]containsObject:self.optionalView]) {
        self.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Clips_Optional_Type;
        [self addSubview:self.optionalView];
        [self.optionalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf.mas_bottom);
            make.height.mas_equalTo(heightEx(45.f));
        }];
    }else{
        self.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Clips_Optional_Type;
    }
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.mas_top);
        make.height.mas_equalTo(@(heightEx(100)));
    }];
    [self bringSubviewToFront:self.textView];
}

-(void)loadPhotoMosaicView{
    self.menuFormat = @"马赛克";
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.mosaicView];
    __weak typeof(self)weakSelf = self;
    if (![self.removeSubViews containsObject:self.mosaicView]) {
        [self.removeSubViews  addObject:self.mosaicView];
        if (weakSelf.optionalAssetsCallback) {
            weakSelf.optionalAssetsCallback(self.menuFormat,@"马赛克");
        }
    }
    if (![[self subviews]containsObject:self.optionalView]) {
        self.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Normal_Optional_Type;
        [self addSubview:self.optionalView];
        [self.optionalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf.mas_bottom);
            make.height.mas_equalTo(heightEx(45.f));
        }];
    }else{
        self.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Normal_Optional_Type;
    }
    [self.mosaicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.mas_top);
        make.height.mas_equalTo(@(heightEx(100)));
    }];
    [self bringSubviewToFront:self.mosaicView];
}

-(void)replaceMianMenuViewWithTitle:(NSString*)title{
    [self.collectionView setHidden:YES];
    [self.optionalView setHidden:NO];
    [self.removeSubViews makeObjectsPerformSelector:@selector(setHidden:)withObject:@(YES)];
    NSArray * methods = @[@{@"title":@"涂鸦",@"method":@"loadPhotoScrawlView"},
                          @{@"title":@"贴图",@"method":@"loadPhotoPasterView"},
                          @{@"title":@"滤镜",@"method":@"loadPhotoEffectView"},
                          @{@"title":@"裁剪旋转",@"method":@"loadPhotoClpisView"},
                          @{@"title":@"旋转",@"method":@"loadPhotoRotateView"},
                          @{@"title":@"调节",@"method":@"loadPhotoAdapterView"},
                          @{@"title":@"文本",@"method":@"loadPhotoTextView"},
                          @{@"title":@"马赛克",@"method":@"loadPhotoMosaicView"},
                          ];
    NSDictionary * json = nil;
    for (int i = 0 ; i < methods.count; i++) {
        json = methods[i];
        NSString * opt = json[@"title"];
        if ([opt isEqualToString:title]) {
            break;
        }
    }
    if (json == nil) return;
    NSString * selector = json[@"method"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    SEL sel = NSSelectorFromString(selector);
    [self performSelector:sel];
#pragma clang diagnostic pop
}



#pragma mark - collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TX_WKG_PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReuseIdentifier" forIndexPath:indexPath];
    cell.photoOptionalModel = self.items[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath != self.selectIndexPath) {
        self.selectIndexPath = indexPath;
        if (self.mainMenuDelegate && [self.mainMenuDelegate respondsToSelector:@selector(tx_Wkg_photoDidSelectedMainMenu:)]) {
            TX_WKG_PhotoOptionalModel * model = self.items[indexPath.row];
            [self.mainMenuDelegate tx_Wkg_photoDidSelectedMainMenu:model.title];
        }
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return widthEx(12.5f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(widthEx(90), collectionView.frame.size.height);
}


@end
