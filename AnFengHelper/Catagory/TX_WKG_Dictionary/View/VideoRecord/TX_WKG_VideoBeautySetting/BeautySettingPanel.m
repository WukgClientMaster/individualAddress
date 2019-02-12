//
//  BeautySettingPanel.m
//  RTMPiOSDemo
//
//  Created by rushanting on 2017/5/5.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "BeautySettingPanel.h"
#import "PituMotionAddress.h"
#import "TextCell.h"
#import "TextImageCell.h"
#import "AFNetworking.h"
#ifdef PITU
#import "ZipArchive.h"
#endif
#import "ColorMacro.h"

#define BeautyViewMargin 8
#define BeautyViewSliderHeight 30
#define BeautyViewCollectionHeight 50
#define BeautyViewTitleWidth 40

@interface BeautySettingPanel() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *functionCollectionView;
@property (nonatomic,readwrite, strong) UICollectionView *beautyCollectionView;
@property (nonatomic, strong) UICollectionView *effectCollectionView;

@property (nonatomic, strong) NSMutableDictionary *beautyValueMap;
@property (nonatomic, strong) UILabel *filterLabel;
@property (nonatomic, strong) UISlider *filterSlider;
@property (nonatomic, strong) NSIndexPath *selectFunctionIndexPath;
@property (nonatomic, strong) NSIndexPath *selectEffectIndexPath;
@property (nonatomic, strong) NSIndexPath *selectBeautyIndexPath;
@property (nonatomic, strong) NSIndexPath *selectBeautyTypeIndexPath;

@property (nonatomic, strong) UILabel *beautyLabel;
@property (nonatomic, strong) UISlider *beautySlider;

@property (nonatomic, strong) NSMutableArray *functionArray;
@property (nonatomic, strong) NSMutableArray *beautyArray;
@property (strong, nonatomic) NSMutableArray *effectArray;
@property (nonatomic, strong) NSMutableDictionary *cellCacheForWidth;
@property (nonatomic, strong) NSURLSessionDownloadTask *operation;
@property (nonatomic, assign) CGFloat beautyLevel;
@property (nonatomic, assign) CGFloat whiteLevel;
@property (nonatomic, assign) CGFloat ruddyLevel;
@property (nonatomic, copy) NSString * sourceType;
@end

@implementation BeautySettingPanel

- (id)init
{
    self = [super init];
    if(self){
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupView];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame beautyEffectType:(NSString*)sourceType{
    self = [super initWithFrame:frame];
    if(self){
         self.sourceType = sourceType;
        [self setupView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self onSetEffectWithIndex:1];
}
#pragma mark - collection
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(collectionView == _effectCollectionView){ //滤镜
        return self.effectArray.count;
    }
    else if(collectionView == _functionCollectionView){ // 滤镜 美颜
        return self.functionArray.count;
    }
    else if(collectionView == _beautyCollectionView){ //美颜功能
        return self.beautyArray.count;
    }
    else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _effectCollectionView){
        TextImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TextImageCell reuseIdentifier] forIndexPath:indexPath];
        cell.label.text = self.effectArray[indexPath.row];
        if(self.selectEffectIndexPath.row == indexPath.row){
            [cell setSelected:YES];
        }
        else{
            [cell setSelected:NO];
        }
        [self.filterSlider setValue:6.f];
        return cell;
    }
    else if(collectionView == _functionCollectionView){
        TextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TextCell reuseIdentifier] forIndexPath:indexPath];
        cell.label.text = self.functionArray[indexPath.row];
        if(self.selectFunctionIndexPath.row == indexPath.row){
            [cell setSelected:YES];
        }
        else{
            [cell setSelected:NO];
        }
        return cell;
    }
    else if(collectionView == _beautyCollectionView){
        TextImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TextImageCell reuseIdentifier] forIndexPath:indexPath];
        cell.label.text = self.beautyArray[indexPath.row];
        if(self.selectBeautyIndexPath.row == indexPath.row){
            [cell setSelected:YES];
        }
        else{
            [cell setSelected:NO];
        }
        float value = [[self.beautyValueMap objectForKey:[NSNumber numberWithInteger:self.selectBeautyIndexPath.row]] floatValue];
        self.beautyLabel.text = [NSString stringWithFormat:@"%d",(int)value];
        [self.beautySlider setValue:value];
        return cell;
    }
    else{
        return [collectionView dequeueReusableCellWithReuseIdentifier:[TextCell reuseIdentifier] forIndexPath:indexPath];;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _effectCollectionView){
        TextImageCell *cell = (TextImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if(indexPath.row != self.selectEffectIndexPath.row){
            [cell setSelected:YES];
            TextImageCell *selectCell = (TextImageCell *)[collectionView cellForItemAtIndexPath:self.selectEffectIndexPath];
            [selectCell setSelected:NO];
            self.selectEffectIndexPath = indexPath;
            [self onSetEffectWithIndex:indexPath.row];
        }
        self.filterLabel.text = [NSString stringWithFormat:@"6"];
        [self.filterSlider setValue:6.f];
    }
    else if(collectionView == _beautyCollectionView){
        TextImageCell *cell = (TextImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if(indexPath.row != self.selectBeautyIndexPath.row){
            [cell setSelected:YES];
            TextImageCell *selectCell = (TextImageCell *)[collectionView cellForItemAtIndexPath:self.selectBeautyIndexPath];
            [selectCell setSelected:NO];
            self.selectBeautyIndexPath = indexPath;
            if(self.selectBeautyIndexPath.row == 6){
                self.beautySlider.minimumValue = -10;
                self.beautySlider.maximumValue = 10;
            }
            else{
                self.beautySlider.minimumValue = 0;
                self.beautySlider.maximumValue = 10;
            }
        }
        float value = [[self.beautyValueMap objectForKey:[NSNumber numberWithInteger:self.selectBeautyIndexPath.row]] floatValue];
        self.beautyLabel.text = [NSString stringWithFormat:@"%d",(int)value];
        [self.beautySlider setValue:value];
    }
    else if(collectionView == _functionCollectionView){
        TextCell *cell = (TextCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if(indexPath.row != self.selectFunctionIndexPath.row){
            [cell setSelected:YES];
            TextCell *selectCell = (TextCell *)[collectionView cellForItemAtIndexPath:self.selectFunctionIndexPath];
            [selectCell setSelected:NO];
            self.selectFunctionIndexPath = indexPath;
            [self changeFunction:indexPath.row];
        }
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return widthEx(12.5f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = 0.f;
    if (collectionView == _functionCollectionView) {
        NSString *identifier = [TextCell reuseIdentifier];
        TextCell *cell = [self.cellCacheForWidth objectForKey:identifier];
        if(!cell){
            cell = [[TextCell alloc] init];
            [self.cellCacheForWidth setObject:cell forKey:identifier];
        }
        width = CGRectGetWidth(self.frame) / self.functionArray.count;
    }
    else if(collectionView == _effectCollectionView || collectionView == _beautyCollectionView){
        NSString *identifier = [TextImageCell reuseIdentifier];
        TextImageCell *cell = [self.cellCacheForWidth objectForKey:identifier];
        if(!cell){
            cell = [[TextImageCell alloc] init];
            [self.cellCacheForWidth setObject:cell forKey:identifier];
        }
        width = widthEx(90);
    }
    return CGSizeMake(width, collectionView.frame.size.height);
}

#pragma mark - layout
- (void)setupView{
    self.beautySlider.frame = CGRectMake(BeautyViewMargin * 4, BeautyViewMargin, self.frame.size.width - 10 * BeautyViewMargin - BeautyViewSliderHeight, BeautyViewSliderHeight);
    [self addSubview:self.beautySlider];
    
    self.beautyLabel.frame = CGRectMake(self.beautySlider.frame.size.width + self.beautySlider.frame.origin.x + BeautyViewMargin, BeautyViewMargin, BeautyViewSliderHeight, BeautyViewSliderHeight);
    self.beautyLabel.layer.cornerRadius = self.beautyLabel.frame.size.width / 2;
    self.beautyLabel.layer.masksToBounds = YES;
    [self addSubview:self.beautyLabel];
    CGFloat effectCollectionViewHeight = 0.f;
    if ([self.sourceType isEqualToString:@"photo"]) {
        effectCollectionViewHeight = CGRectGetHeight(self.frame) -(self.beautySlider.frame.size.height + self.beautySlider.frame.origin.y + BeautyViewMargin);
    }else{
        effectCollectionViewHeight = CGRectGetHeight(self.frame) -(self.beautySlider.frame.size.height + self.beautySlider.frame.origin.y + BeautyViewMargin + heightEx(50.f));
    }
    self.beautyCollectionView.frame = CGRectMake(0, self.beautySlider.frame.size.height + self.beautySlider.frame.origin.y + BeautyViewMargin, self.frame.size.width, effectCollectionViewHeight);
    [self addSubview:self.beautyCollectionView];
    if ([self.sourceType isEqualToString:@"photo"]){
        self.beautyCollectionView.backgroundColor = [UIColor clearColor];
        return;
    }
    self.beautyCollectionView.backgroundColor = [UIColorFromRGB(0x151724)colorWithAlphaComponent:0.8];
    self.filterSlider.frame = CGRectMake(BeautyViewMargin * 4, BeautyViewMargin, self.frame.size.width - 10 * BeautyViewMargin - BeautyViewSliderHeight, BeautyViewSliderHeight);
    self.filterSlider.hidden = YES;
    [self addSubview:self.filterSlider];
    
    self.filterLabel.frame = CGRectMake(self.filterSlider.frame.size.width + self.filterSlider.frame.origin.x + BeautyViewMargin, BeautyViewMargin, BeautyViewSliderHeight, BeautyViewSliderHeight);
    self.filterLabel.layer.cornerRadius = self.filterLabel.frame.size.width / 2;
    self.filterLabel.layer.masksToBounds = YES;
    self.filterLabel.hidden = YES;
    [self addSubview:self.filterLabel];
    
    self.effectCollectionView.frame = CGRectMake(0, self.beautySlider.frame.size.height + self.beautySlider.frame.origin.y + BeautyViewMargin, self.frame.size.width, effectCollectionViewHeight);
    self.effectCollectionView.hidden = YES;
    [self addSubview:self.effectCollectionView];
    
    self.functionCollectionView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - heightEx(50.f) , self.frame.size.width, heightEx(50.f));
    [self addSubview:self.functionCollectionView];
}

#pragma mark - value changed
- (void)onValueChanged:(id)sender{
    UISlider *slider = (UISlider *)sender;
    if(slider == self.filterSlider){
        self.filterLabel.text = [NSString stringWithFormat:@"%d",(int)self.filterSlider.value];
        if([self.delegate respondsToSelector:@selector(onSetMixLevel:)]){
            [self.delegate onSetMixLevel:self.filterSlider.value];
        }
    }
    else{
        [self.beautyValueMap setObject:[NSNumber numberWithFloat:self.beautySlider.value] forKey:[NSNumber numberWithInteger:self.selectBeautyIndexPath.row]];
        self.beautyLabel.text = [NSString stringWithFormat:@"%d",(int)self.beautySlider.value];
        
        if(self.selectBeautyIndexPath.row == 0){
            if([self.delegate respondsToSelector:@selector(onSetBeautyStyle:beautyLevel:whitenessLevel:ruddinessLevel:)]){
                _beautyLevel = self.beautySlider.value;
                [self.delegate onSetBeautyStyle:(int)self.selectBeautyTypeIndexPath.row beautyLevel:_beautyLevel whitenessLevel:_whiteLevel ruddinessLevel:_ruddyLevel];
            }
        }
        else if(self.selectBeautyIndexPath.row == 1){
            if([self.delegate respondsToSelector:@selector(onSetBeautyStyle:beautyLevel:whitenessLevel:ruddinessLevel:)]){
                _whiteLevel = self.beautySlider.value;
                [self.delegate onSetBeautyStyle:(int)self.selectBeautyTypeIndexPath.row beautyLevel:_beautyLevel whitenessLevel:_whiteLevel ruddinessLevel:_ruddyLevel];
            }
        }
        else if(self.selectBeautyIndexPath.row == 2){
            if([self.delegate respondsToSelector:@selector(onSetBeautyStyle:beautyLevel:whitenessLevel:ruddinessLevel:)]){
                _ruddyLevel = self.beautySlider.value;
                [self.delegate onSetBeautyStyle:(int)self.selectBeautyTypeIndexPath.row beautyLevel:_beautyLevel whitenessLevel:_whiteLevel ruddinessLevel:_ruddyLevel];
            }
        }
        else if(self.selectBeautyIndexPath.row == 3){
            if([self.delegate respondsToSelector:@selector(onSetEyeScaleLevel:)]){
                [self.delegate onSetEyeScaleLevel:self.beautySlider.value];
            }
        }
        else if(self.selectBeautyIndexPath.row == 4){
            if([self.delegate respondsToSelector:@selector(onSetFaceScaleLevel:)]){
                [self.delegate onSetFaceScaleLevel:self.beautySlider.value];
            }
        }
        else if(self.selectBeautyIndexPath.row == 5){
            if([self.delegate respondsToSelector:@selector(onSetFaceVLevel:)]){
                [self.delegate onSetFaceVLevel:self.beautySlider.value];
            }
        }
        else if(self.selectBeautyIndexPath.row == 6){
            if([self.delegate respondsToSelector:@selector(onSetChinLevel:)]){
                [self.delegate onSetChinLevel:self.beautySlider.value];
            }
        }
        else if(self.selectBeautyIndexPath.row == 7){
            if([self.delegate respondsToSelector:@selector(onSetFaceShortLevel:)]){
                [self.delegate onSetFaceShortLevel:self.beautySlider.value];
            }
        }
        else if(self.selectBeautyIndexPath.row == 8){
            if([self.delegate respondsToSelector:@selector(onSetNoseSlimLevel:)]){
                [self.delegate onSetNoseSlimLevel:self.beautySlider.value];
            }
        }
        else{
            
        }
    }
}

- (void)onSetEffectWithIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(onSetFilter:)]) {
        NSString* lookupFileName = @"";
        
        switch (index) {
            case 0:
                break;
            case 1:
                lookupFileName = @"fennen.png";
                break;
            case 2:
                lookupFileName = @"langman.png";
                break;
            case 3:
                lookupFileName = @"qingxin.png";
                break;
            case 4:
                lookupFileName = @"weimei.png";
                break;
            case 5:
                lookupFileName = @"huaijiu.png";
                break;
            case 6:
                lookupFileName = @"landiao.png";
                break;
            case 7:
                lookupFileName = @"qingliang.png";
                break;
            case 8:
                lookupFileName = @"rixi.png";
                break;
            default:
                break;
        }
        NSString * path = [[NSBundle mainBundle] pathForResource:@"FilterResource" ofType:@"bundle"];
        if (path != nil && index != FilterType_None) {
            path = [path stringByAppendingPathComponent:lookupFileName];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [self.delegate onSetFilter:image];
        } else {
            [self.delegate onSetFilter:nil];
        }
    }
}

- (void)changeFunction:(NSInteger)index{
    self.beautyLabel.hidden = index == 0 ? NO: YES;
    self.beautySlider.hidden = index == 0 ? NO: YES;
    self.beautyCollectionView.hidden = index == 0 ? NO: YES;
    self.effectCollectionView.hidden = index == 1? NO: YES;
    self.filterLabel.hidden = index == 1? NO: YES;
    self.filterSlider.hidden = index == 1? NO: YES;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    TextCell *selectCell = (TextCell *)[_functionCollectionView cellForItemAtIndexPath:self.selectFunctionIndexPath];
    [selectCell setSelected:NO];
    TextCell *cell = (TextCell *)[_functionCollectionView cellForItemAtIndexPath:indexPath];
    [cell setSelected:YES];
    self.selectFunctionIndexPath = indexPath;
}

- (void)startLoadPitu:(NSString *)pituDir pituName:(NSString *)pituName packageURL:(NSURL *)packageURL{
#ifdef PITU
    if (self.operation) {
        if (self.operation.state != NSURLSessionTaskStateRunning) {
            [self.operation resume];
        }
    }
    NSString *targetPath = [NSString stringWithFormat:@"%@/%@.zip", pituDir, pituName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:targetPath error:nil];
    }
    __weak __typeof(self) weakSelf = self;
    NSURLRequest *downloadReq = [NSURLRequest requestWithURL:packageURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.f];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self.pituDelegate onLoadPituStart];
    self.operation = [manager downloadTaskWithRequest:downloadReq progress:^(NSProgress * _Nonnull downloadProgress) {
        if (weakSelf.pituDelegate) {
            CGFloat progress = (float)downloadProgress.completedUnitCount / (float)downloadProgress.totalUnitCount;
            [weakSelf.pituDelegate onLoadPituProgress:progress];
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath_, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:targetPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            [weakSelf.pituDelegate onLoadPituFailed];
            return;
        }
        // 解压
        BOOL unzipSuccess = NO;
        ZipArchive *zipArchive = [[ZipArchive alloc] init];
        if ([zipArchive UnzipOpenFile:targetPath]) {
            unzipSuccess = [zipArchive UnzipFileTo:pituDir overWrite:YES];
            [zipArchive UnzipCloseFile];
            
            // 删除zip文件
            [[NSFileManager defaultManager] removeItemAtPath:targetPath error:&error];
        }
        if (unzipSuccess) {
            [weakSelf.pituDelegate onLoadPituFinished];
            [self.delegate onSelectMotionTmpl:pituName inDir:pituDir];
        } else {
            [weakSelf.pituDelegate onLoadPituFailed];
        }
    }];
    [self.operation resume];
#endif
}

#pragma mark - height
+ (NSUInteger)getHeight
{
    return BeautyViewMargin * 4 + 3 * BeautyViewSliderHeight + BeautyViewCollectionHeight;
}

#pragma mark - lazy load
- (NSMutableArray *)effectArray
{
    if(!_effectArray){
        _effectArray = [[NSMutableArray alloc] init];
        [_effectArray addObject:@"原图"];
        [_effectArray addObject:@"粉嫩"];
        [_effectArray addObject:@"浪漫"];
        [_effectArray addObject:@"清新"];
        [_effectArray addObject:@"唯美"];
        [_effectArray addObject:@"怀旧"];
        [_effectArray addObject:@"蓝调"];
        [_effectArray addObject:@"清凉"];
        [_effectArray addObject:@"日系"];
    }
    return _effectArray;
}

- (NSMutableArray *)beautyArray{
    if(!_beautyArray){
        _beautyArray = [[NSMutableArray alloc] init];
        [_beautyArray addObject:@"美颜"];
        [_beautyArray addObject:@"美白"];
        [_beautyArray addObject:@"红润"];
    }
    return _beautyArray;
}

- (NSMutableArray *)functionArray{
    if(!_functionArray){
        _functionArray = [[NSMutableArray alloc] init];
        [_functionArray addObject:@"美颜"];
        [_functionArray addObject:@"滤镜"];
    }
    return _functionArray;
}

- (NSMutableDictionary *)beautyValueMap{
    if(!_beautyValueMap){
        _beautyValueMap = [[NSMutableDictionary alloc] init];
        [_beautyValueMap setObject:@(6.3) forKey:@(0)]; //美颜默认值
        [_beautyValueMap setObject:@(2.7) forKey:@(1)]; //美白默认值
        [_beautyValueMap setObject:@(2.7) forKey:@(2)]; //红润默认值
    }
    return _beautyValueMap;
}

- (UICollectionView *)beautyCollectionView{
    if(!_beautyCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _beautyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _beautyCollectionView.backgroundColor = [UIColorFromRGB(0x151724)colorWithAlphaComponent:0.8];
        _beautyCollectionView.showsHorizontalScrollIndicator = NO;
        _beautyCollectionView.delegate = self;
        _beautyCollectionView.dataSource = self;
        [_beautyCollectionView registerClass:[TextImageCell class] forCellWithReuseIdentifier:[TextImageCell reuseIdentifier]];
    }
    return _beautyCollectionView;
}

- (UICollectionView *)effectCollectionView{
    if(!_effectCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _effectCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _effectCollectionView.backgroundColor = [UIColorFromRGB(0x151724)colorWithAlphaComponent:0.8];
        _effectCollectionView.showsHorizontalScrollIndicator = NO;
        _effectCollectionView.delegate = self;
        _effectCollectionView.dataSource = self;
        [_effectCollectionView registerClass:[TextImageCell class] forCellWithReuseIdentifier:[TextImageCell reuseIdentifier]];
    }
    return _effectCollectionView;
}

- (UICollectionView *)functionCollectionView{
    if(!_functionCollectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.f;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _functionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _functionCollectionView.backgroundColor = [UIColorFromRGB(0x151724)colorWithAlphaComponent:0.9];
        _functionCollectionView.showsHorizontalScrollIndicator = NO;
        _functionCollectionView.delegate = self;
        _functionCollectionView.dataSource = self;
        [_functionCollectionView registerClass:[TextCell class] forCellWithReuseIdentifier:[TextCell reuseIdentifier]];
    }
    return _functionCollectionView;
}

- (UISlider *)beautySlider{
    if(!_beautySlider){
        _beautySlider = [[UISlider alloc] init];
        _beautySlider.minimumValue = 0;
        _beautySlider.maximumValue = 10;
        _beautySlider.value = 3.f;
        [_beautySlider setMinimumTrackTintColor:UIColorFromRGB(0x0ACCAC)];
        [_beautySlider setMaximumTrackTintColor:[UIColor whiteColor]];
        [_beautySlider addTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _beautySlider;
}

- (UILabel *)beautyLabel{
    if(!_beautyLabel){
        _beautyLabel = [[UILabel alloc] init];
        _beautyLabel.backgroundColor = [UIColor whiteColor];
        _beautyLabel.textAlignment = NSTextAlignmentCenter;
        _beautyLabel.text = @"0";
        [_beautyLabel setTextColor:UIColorFromRGB(0x0ACCAC)];
    }
    return _beautyLabel;
}

- (UISlider *)filterSlider{
    if(!_filterSlider){
        _filterSlider = [[UISlider alloc] init];
        _filterSlider.minimumValue = 0;
        _filterSlider.value = 3.f;
        _filterSlider.maximumValue = 10;
        [_filterSlider setMinimumTrackTintColor:UIColorFromRGB(0x0ACCAC)];
        [_filterSlider setMaximumTrackTintColor:[UIColor whiteColor]];
        [_filterSlider addTarget:self action:@selector(onValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _filterSlider;
}

- (UILabel *)filterLabel{
    if(!_filterLabel){
        _filterLabel = [[UILabel alloc] init];
        _filterLabel.backgroundColor = [UIColor whiteColor];
        _filterLabel.textAlignment = NSTextAlignmentCenter;
        _filterLabel.text = @"0";
        [_filterLabel setTextColor:UIColorFromRGB(0x0ACCAC)];
    }
    return _filterLabel;
}

- (NSIndexPath *)selectEffectIndexPath{
    if(!_selectEffectIndexPath){
        _selectEffectIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    }
    return _selectEffectIndexPath;
}

- (NSIndexPath *)selectBeautyIndexPath
{
    if(!_selectBeautyIndexPath){
        _selectBeautyIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _selectBeautyIndexPath;
}

- (NSIndexPath *)selectFunctionIndexPath
{
    if(!_selectFunctionIndexPath){
        _selectFunctionIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _selectFunctionIndexPath;
}

- (NSMutableDictionary *)cellCacheForWidth
{
    if(!_cellCacheForWidth){
        _cellCacheForWidth = [NSMutableDictionary dictionary];
    }
    return _cellCacheForWidth;
}
- (void)resetValues
{
    self.beautySlider.hidden = NO;
    self.beautyLabel.hidden = NO;
    self.filterSlider.hidden = YES;
    self.filterLabel.hidden = YES;
    self.beautyCollectionView.hidden = NO;
    self.effectCollectionView.hidden = YES;
    self.functionCollectionView.hidden = NO;
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.functionCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:_functionCollectionView didSelectItemAtIndexPath:indexPath];
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.effectCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:_effectCollectionView didSelectItemAtIndexPath:indexPath];
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.beautyCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self collectionView:_beautyCollectionView didSelectItemAtIndexPath:indexPath];
    
    [self.beautyValueMap removeAllObjects];
    [self.beautyValueMap setObject:@(6.3) forKey:@(0)]; //美颜默认值
    [self.beautyValueMap setObject:@(2.7) forKey:@(1)]; //美白默认值
    [self.beautyValueMap setObject:@(2.7) forKey:@(2)]; //红润默认值
    
    _whiteLevel = 2.7;
    _beautyLevel = 6.3;
    _ruddyLevel = 2.7;
    self.beautySlider.value = 6.3;
    self.filterSlider.value = 3;
    [self onValueChanged:self.beautySlider];
    [self onValueChanged:self.filterSlider];
}

- (void)trigglerValues{
    [self onValueChanged:self.beautySlider];
    [self onValueChanged:self.filterSlider];
}
@end
