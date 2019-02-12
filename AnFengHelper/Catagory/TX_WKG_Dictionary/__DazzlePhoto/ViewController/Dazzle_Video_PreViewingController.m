//
//  Dazzle_Video_PreViewingController.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "Dazzle_Video_PreViewingController.h"
#import "AlbumCollectionFlowLayout.h"
#import "DazzlePreviewingCell.h"
#import "DazlleAlbumCell.h"
//
#import "DazzlePreviewingReusableView.h"
#import "Dazzle_PhotoPresentContainerView.h"
//
#import "PHAlbumCategoryView.h"
#import "Dazzle_VideoPlayerView.h"
#import "DazzlePhotoPlaceholderView.h"
//
#import "AssetOptionalTopView.h"
#import "AssertDataManager.h"
#import "DazzleAssetModel.h"
#import "DazzleAssetCollectionModel.h"
#import "PhotoDowloadTool.h"
#import "PhotoCompositionTool.h"
#import "HX_ProgressHUD.h"
#import "WKG_VideoPreViewController.h"
#import <TXLiteAVSDK_Professional/TXVideoEditer.h>
#import "ESPictureProgressView.h"


NSString * kDazzle_Video_PreViewingContentKey = @"kDazzle_Video_PreViewingContentKey";

@interface Dazzle_Video_PreViewingController ()<UICollectionViewDelegate,UICollectionViewDataSource,PHAlbumCategoryOptionalDelegate,UIGestureRecognizerDelegate,TXVideoGenerateListener>
@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) AlbumCollectionFlowLayout * albumCollectionFlowLayout;
@property (strong, nonatomic) DazzlePreviewingReusableView * previewingReusableView;
@property (strong, nonatomic) AssetOptionalTopView *optionalTopView;
@property (strong, nonatomic) Dazzle_PhotoPresentContainerView * presentContainerView;
@property (strong, nonatomic) DazzlePhotoPlaceholderView * placeholderView;
@property (strong, nonatomic) Dazzle_VideoPlayerView * videoPlayerView;
@property (strong, nonatomic) PHAlbumCategoryView * categoryView;
@property (strong, nonatomic) NSMutableArray * datas;
@property (strong, nonatomic) NSMutableArray * hasSelectedDatas;
@property (strong, nonatomic) NSMutableArray * hasSelectedCellDatas;
@property (strong, nonatomic) NSMutableDictionary * optionalJsonData;
@property (strong, nonatomic) NSMutableArray * configRenderImages;
@property (strong, nonatomic) UIImageView * videoCoverImageView;
@property (copy, nonatomic) NSString * videoOutputPath;
@property (strong, nonatomic) TXVideoEditer * videoEditer;
@property (strong, nonatomic) MBProgressHUD * hud;
@property (strong, nonatomic) ESPictureProgressView * progressView;
@end

@implementation Dazzle_Video_PreViewingController

-(void)exportVideoWithUrlString:(NSString*)urlString{
	if (urlString.length == 0 || urlString == nil)return;
	NSString * absolute = urlString;
	NSString * scheme = @"file://";
	if ([absolute hasPrefix:scheme]) {
		urlString = [absolute substringWithRange:NSMakeRange(scheme.length, absolute.length - scheme.length)];
	}
	NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
	NSString *videoFileName = [NSString stringWithFormat:@"%@%d.mp4", [NSString stringWithFormat:@"video%f", interval].md5String, arc4random()%10000];
	_videoOutputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:videoFileName];
	NSURL * assetUrl = [NSURL fileURLWithPath:urlString];
	AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:assetUrl options:nil];
	__block MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText  = [NSString stringWithFormat:@"拼命压缩中..."];
	self.hud = hud;
	AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset960x540];
	exportSession.outputURL = [NSURL fileURLWithPath:_videoOutputPath];
	exportSession.shouldOptimizeForNetworkUse = true;
	exportSession.outputFileType = AVFileTypeMPEG4;
	[exportSession exportAsynchronouslyWithCompletionHandler:^{
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.hud hide:YES afterDelay:0];
			if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
				[[NSNotificationCenter defaultCenter]postNotificationName:kDazzle_Video_PreViewingContentKey object:_videoOutputPath];
				[self dismissViewControllerAnimated:YES completion:nil];
			}else{
				[HX_ProgressHUD showWithTitle:@"视频压缩失败" AfterDelay:1.f];
			}
		});
	}];
}

#pragma mark - IBOutlet Events
-(void)photoPrepareComposition{
    [self.videoPlayerView stopVideo];
    if (self.hasSelectedDatas.count == 1) {
        DazzleAssetModel * model = (DazzleAssetModel*) [self.hasSelectedDatas firstObject];
        if (model.mediaType == PHAssetMediaTypeVideo) {
			if (model.duration > 180.f) {
				[HX_ProgressHUD showWithTitle:@"选择视频不得超过180秒" AfterDelay:1.f];
				return;
			}
			if(model.videoSize < 8.f){
				[[NSNotificationCenter defaultCenter]postNotificationName:kDazzle_Video_PreViewingContentKey object:model.videoUrlString];
				[self dismissViewControllerAnimated:YES completion:nil];
			}else{
				[self exportVideoWithUrlString:model.videoUrlString];
			}
            return;
        }
    }
    if (self.hasSelectedDatas.count <3) {
        [HX_ProgressHUD showWithTitle:@"至少选择3张图片" AfterDelay:1.f];
        return;
    }
	if (self.hasSelectedDatas.count >30) {
		[HX_ProgressHUD showWithTitle:@"至多选择30张图片" AfterDelay:1.f];
		return;
	}
    [self.configRenderImages removeAllObjects];
    for (int i = 0; i < self.hasSelectedDatas.count;i++) {
        DazzleAssetModel * model = self.hasSelectedDatas[i];
        UIImage * originImage = model.originImage;
        UIImage * renderImage = [self imageWithImage:originImage];
        [self.configRenderImages addObject:renderImage];
    }
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *videoFileName = [NSString stringWithFormat:@"%@%d.mp4", [NSString stringWithFormat:@"video%f", interval].md5String, arc4random()%10000];
    _videoOutputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:videoFileName];
    __block MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText  = [NSString stringWithFormat:@"拼命合成中..."];
	self.hud = hud;
	if (self.videoEditer == nil) {
		TXPreviewParam * param = [[TXPreviewParam alloc] init];
		param.videoView =  nil;
		param.renderMode = PREVIEW_RENDER_MODE_FILL_EDGE;
		self.videoEditer = [[TXVideoEditer alloc]initWithPreview:param];
		self.videoEditer.generateDelegate = self;
	}
	[self.videoEditer setVideoPath:self.videoOutputPath];
	[self.videoEditer setPictureList:self.configRenderImages fps:15.f];
	[self.videoEditer setPictureTransition:(TXTransitionType_LefRightSlipping) duration:nil];
	[self.videoEditer generateVideo:(VIDEO_COMPRESSED_720P) videoOutputPath:self.videoOutputPath];
}

-(void) onGenerateProgress:(float)progress{
	
}

-(void) onGenerateComplete:(TXGenerateResult *)result{
	if (result.retCode == GENERATE_RESULT_OK) {
		[self.hud hide:YES afterDelay:0];
		WKG_VideoPreViewController * videoPreviewVC = [[WKG_VideoPreViewController alloc]initWithVideoPth:self.videoOutputPath coverImage:self.configRenderImages[0]];
		videoPreviewVC.done_optional = @"done";
		[self.navigationController pushViewController:videoPreviewVC animated:YES];
	}
}

-(UIImage*)imageWithImage:(UIImage*)image{
    CGSize  renderSize = CGSizeZero;
    CGFloat imgWidth =   image.size.width;
    CGFloat imgHeight =  image.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    if (imgWidth / imgHeight >=1.f) {
		CGFloat height =  750 * (imgWidth / imgHeight) >= 1334 ? 1334 : 750 * (imgWidth/imgHeight);
        renderSize = CGSizeMake(750* scale, height* scale);
    }else if (imgWidth / imgHeight < 1.f){
        CGFloat height = 750 * (imgHeight/ imgWidth) >= 1334 ? 1334 :  750 * (imgHeight/ imgWidth);
		renderSize = CGSizeMake(750* scale,height*scale);
    }
    UIGraphicsBeginImageContext(renderSize);
    [image drawInRect:CGRectMake(0,0,renderSize.width,renderSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setObjectView];
    __weak typeof(self)weakSelf = self;
    [AssertDataManager shared].containerViewController = self;
    [[AssertDataManager shared]queryAuthorityData:^(BOOL isAuthority) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (isAuthority) {
            [strongSelf loadData];
            [strongSelf loadCategoryDatas];
        }
    }];
}

-(void)loadDatasWithCollection:(DazzleAssetCollectionModel*)model{
    __weak typeof(self)weakSelf = self;
    [[AssertDataManager shared]queryAssetsWithCollection:model handel:^(BOOL status, NSArray<DazzleAssetModel *> *datas) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (status) {
             strongSelf.videoCoverImageView.frame = CGRectMake(0, 0, KScreenWidth, 50);
            [strongSelf.videoCoverImageView removeFromSuperview];
            [strongSelf.optionalTopView setHidden:NO];
            [strongSelf.datas removeAllObjects];
            [strongSelf.datas addObjectsFromArray:datas];
            [strongSelf configDataCollectionViews];
            [strongSelf.collectionView reloadData];
        }
    }failure:^(NSString *msg) {
        
    }];
}

-(void)configDataCollectionViews{
    [self.optionalJsonData removeAllObjects];
    [self.hasSelectedDatas removeAllObjects];
    [self.hasSelectedCellDatas removeAllObjects];
    self.placeholderView.frame = CGRectMake(0, 0, kScreenWidth, 400);
    [self configHeaderViewContentHeight:400.f];
    DazzleAssetModel * selectedModel = (DazzleAssetModel*)[self.datas firstObject];
    selectedModel.selected = YES;
    DazzleAssetModel * copySelectedModel = [selectedModel copy];
    if (copySelectedModel.image == nil) {
        [PhotoDowloadTool getHighQualityFormatPhoto:copySelectedModel.phAsset size:CGSizeMake(100, 100) startRequestIcloud:^(PHImageRequestID cloudRequestId) {
        } progressHandler:^(double progress) {
        } completion:^(UIImage *image) {
            copySelectedModel.image = image;
        } failed:^(NSDictionary *info) {
        }];
    }
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.hasSelectedCellDatas addObject:indexPath];
    DazzlePreviewingCell * cell = (DazzlePreviewingCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    selectedModel.selected = YES;
    cell.model = selectedModel;
    NSString * key = [NSString stringWithFormat:@"key_s:%zdr:%zd",indexPath.section,indexPath.row];
    copySelectedModel.groupKey = key;
    NSMutableArray * datas = [NSMutableArray arrayWithObject:copySelectedModel];
    if (![[self.optionalJsonData allKeys]containsObject:key]) {
        NSMutableDictionary * json = [NSMutableDictionary dictionary];
        [json setObject:indexPath forKey:@"indexPath"];
        [json setObject:datas forKey:@"data"];
        [json setObject:selectedModel forKey:@"model"];
        [self.optionalJsonData setObject:json forKey:key];
        [self.hasSelectedCellDatas addObject:indexPath];
    }
    [self.previewingReusableView setViewsHidden:YES];
    [self.placeholderView removeFromSuperview];
    [self.categoryView removeFromSuperview];
    [self.videoPlayerView removeFromSuperview];
    if (copySelectedModel.mediaType == PHAssetMediaTypeImage) {
		[self.hasSelectedDatas addObject:copySelectedModel];
        [self.previewingReusableView addSubview:self.placeholderView];
        if (selectedModel.originImage) {
            [self.placeholderView setAssetModel:selectedModel];
        }else{
            [self requestDatas:selectedModel copyAssetModel:copySelectedModel];
        }
    }else if (copySelectedModel.mediaType == PHAssetMediaTypeVideo){
        [self.previewingReusableView addSubview:self.videoPlayerView];
        if (selectedModel.videoUrlString) {
            [self.videoPlayerView setAssetModel:copySelectedModel];
        }else{
			[self.videoPlayerView setAssetModel:copySelectedModel];
            [self requestDatas:selectedModel copyAssetModel:copySelectedModel];
        }
    }
}

-(void)loadCategoryDatas{
    __weak typeof(self)weakSelf = self;
    [[AssertDataManager shared]queryCollections:^(BOOL status, NSArray<DazzleAssetCollectionModel *> *datas) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (status) {
            strongSelf.presentContainerView.datas = datas;
        }
    } failure:^(NSString *msg) {
    }];
}

-(void)loadData{
    __weak typeof(self)weakSelf = self;
    [[AssertDataManager shared]queryAllPhotos:^(BOOL status, NSArray<DazzleAssetModel *> *datas) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (status) {
			[strongSelf.optionalTopView setHidden:NO];
			[strongSelf.datas removeAllObjects];
			[strongSelf.datas addObjectsFromArray:datas];
			[strongSelf configDataCollectionViews];
			[strongSelf.collectionView reloadData];
        }
    } failure:^(NSString *msg) {
    }];
}

-(void)setObjectView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.optionalTopView.frame = CGRectMake(0, 0, KScreenWidth, SC_StatusBarAndNavigationBarHeight);
    self.previewingReusableView.frame = CGRectMake(0,SC_StatusBarAndNavigationBarHeight, KScreenWidth, 400);
    self.collectionView.frame = CGRectMake(0,CGRectGetMaxY(self.previewingReusableView.frame), KScreenWidth,KScreenHeight - CGRectGetMaxY(self.previewingReusableView.frame));
    [self.view addSubview:self.optionalTopView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.previewingReusableView];
    [self.view addSubview:self.presentContainerView];
	self.progressView.progress = 0.001f;
	[self.progressView setHidden:YES];
	[self.view addSubview:self.progressView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - UICollectionView Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DazzlePreviewingCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DazzlePreviewingCell class]) forIndexPath:indexPath];
    if (!cell) {
        cell = [[DazzlePreviewingCell alloc]initWithFrame:CGRectZero];
    }
    cell.indexPath = indexPath;
    cell.model = self.datas[indexPath.row];
    __weak typeof(self)weakSelf = self;
    cell.didSelectedCallback = ^(DazzleAssetModel *model, NSString *selectedStatus, DazzlePreviewingCell *cell) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf previewingCellSelectedItemOptional:model opt:selectedStatus previewingCell:cell indexPath:cell.indexPath];
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DazzleAssetModel * model = self.datas[indexPath.row];
	DazzlePreviewingCell * cell = (DazzlePreviewingCell*)[collectionView cellForItemAtIndexPath:indexPath];
	if (self.hasSelectedDatas.count >=2 && model.mediaType == PHAssetMediaTypeVideo) {
		
	}else{
		[self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionTop) animated:YES];
	}
	[self.progressView setHidden:YES];
    [self previewingCellSelectedItemOptional:model opt:@"selected" previewingCell:cell indexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemSize = (KScreenWidth -3.f )/4.f;
    return CGSizeMake(itemSize, itemSize);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.f;
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1.f;
}
#pragma mark - containerViews
-(void)loadContainerView{
    [self.videoPlayerView stopVideo];
    CGFloat originY = CGRectGetMinY(self.presentContainerView.frame);
    if (originY == kScreenHeight) {
        [UIView animateWithDuration:1.2 delay:0.f usingSpringWithDamping:0.95f initialSpringVelocity:6.f options:(UIViewAnimationOptionCurveLinear) animations:^{
            [self.optionalTopView setCategoryViewsHidden:YES];
            [self.optionalTopView setUserInteractionEnabled:NO];
            self.presentContainerView.y = SC_StatusBarAndNavigationBarHeight;
        } completion:^(BOOL finished) {
            [self.optionalTopView setUserInteractionEnabled:YES];
        }];
    }else{
        [UIView animateWithDuration:1.2 delay:0.f usingSpringWithDamping:1.f initialSpringVelocity:3.f options:(UIViewAnimationOptionCurveLinear) animations:^{
            [self.optionalTopView setCategoryViewsHidden:NO];
            [self.optionalTopView setUserInteractionEnabled:NO];
            self.presentContainerView.y = kScreenHeight;
        } completion:^(BOOL finished) {
            [self.optionalTopView setUserInteractionEnabled:YES];
        }];
    }
}

-(void)configHeaderViewContentHeight:(CGFloat)height{
    self.previewingReusableView.frame = CGRectMake(0,SC_StatusBarAndNavigationBarHeight, KScreenWidth, height);
    self.collectionView.frame = CGRectMake(0,(SC_StatusBarAndNavigationBarHeight + height), KScreenWidth,KScreenHeight - (SC_StatusBarAndNavigationBarHeight + height));
}
-(void)configPlaceholderViewHeight:(CGFloat)height{
    self.placeholderView.frame = CGRectMake(0,0, height, height);
    if (![[self.previewingReusableView subviews]containsObject:self.placeholderView]) {
        [self.previewingReusableView addSubview:self.placeholderView];
    }
}


#pragma mark - PHAlbumCategoryOptionalDelegate
-(void)albumCategoryDidDelete:(DazzleAssetModel*)assetModel shouldRemovegroup:(NSString*)removegroup{
    NSMutableDictionary * json = self.optionalJsonData[assetModel.groupKey];
    NSMutableArray * data = json[@"data"];
    [data removeObject:assetModel];
    [self.hasSelectedDatas removeObject:assetModel];
    if ([removegroup isEqualToString:@"NO"]) {
         if (self.hasSelectedDatas.count ==1){
            [self.previewingReusableView setViewsHidden:YES];
            [self configHeaderViewContentHeight:400];
            [self.placeholderView removeFromSuperview];
            [self.categoryView removeFromSuperview];
            [self.videoPlayerView removeFromSuperview];
            [self.previewingReusableView addSubview:self.placeholderView];
            DazzleAssetModel * model =(DazzleAssetModel*)[self.hasSelectedDatas lastObject];
            [self.placeholderView setAssetModel:model];
        }
    }
    else  if ([removegroup isEqualToString:@"YES"]) {
        NSMutableDictionary * json = self.optionalJsonData[assetModel.groupKey];
        NSIndexPath * indexPath = json[@"indexPath"];
        [self.hasSelectedCellDatas removeObject:indexPath];
        DazzlePreviewingCell * cell = (DazzlePreviewingCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        DazzleAssetModel * optionalAssetModel = json[@"model"];
        optionalAssetModel.selected = NO;
        cell.model = optionalAssetModel;
        [self.optionalJsonData removeObjectForKey:assetModel.groupKey];
        if (self.hasSelectedDatas.count >=2) {
            [self.categoryView setData:self.optionalJsonData];
            [self.categoryView setItems:self.hasSelectedDatas];
            [self.previewingReusableView setViewsHidden:YES];
        }else if(self.hasSelectedDatas.count == 0){
            [self configHeaderViewContentHeight:400];
            [self.previewingReusableView setViewsHidden:NO];
            [self.placeholderView removeFromSuperview];
            [self.categoryView removeFromSuperview];
            [self.videoPlayerView removeFromSuperview];
        }else{
            [self.previewingReusableView setViewsHidden:YES];
            [self configHeaderViewContentHeight:400];
            self.placeholderView.frame = CGRectMake(0, 0, kScreenWidth, 400);
            [self.placeholderView removeFromSuperview];
            [self.categoryView removeFromSuperview];
            [self.videoPlayerView removeFromSuperview];
            [self.previewingReusableView addSubview:self.placeholderView];
            DazzleAssetModel * model =(DazzleAssetModel*)[self.hasSelectedDatas lastObject];
            [self.placeholderView setAssetModel:model];
        }
    }
}

#pragma mark - 对数据的操作
-(void)previewingCellSelectedItemOptional:(DazzleAssetModel*) model opt:(NSString*)opt previewingCell:(DazzlePreviewingCell*)cell indexPath:(NSIndexPath*)indexPath{
    if (model == nil)return;
     self.videoCoverImageView.frame = CGRectMake(0, 0, KScreenWidth, 50);
    [self.videoCoverImageView removeFromSuperview];
    [self.optionalTopView setHidden:NO];
    if ([opt isEqualToString:@"selected"]) {
        if (model.mediaType == PHAssetMediaTypeVideo) {
            if (self.hasSelectedDatas.count >=2)return;
            [self.hasSelectedCellDatas enumerateObjectsUsingBlock:^(NSIndexPath *  _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
                DazzlePreviewingCell * viewingCell = (DazzlePreviewingCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
                DazzleAssetModel * optionalModel = self.datas[indexPath.row];
                optionalModel.selected = NO;
                viewingCell.model = optionalModel;
            }];
            model.selected = YES;
            cell.model = model;
            [self.previewingReusableView setViewsHidden:YES];
            [self.hasSelectedDatas removeAllObjects];
            [self.optionalJsonData removeAllObjects];
            [self.hasSelectedCellDatas removeAllObjects];
            [self.hasSelectedCellDatas addObject:indexPath];
            [self.placeholderView removeFromSuperview];
            [self.categoryView removeFromSuperview];
            [self.videoPlayerView removeFromSuperview];
            [self configHeaderViewContentHeight:400];
            self.placeholderView.frame = CGRectMake(0, 0, kScreenWidth, 400);
            if ([[self.previewingReusableView subviews]containsObject:self.placeholderView]) {
                [self.placeholderView removeFromSuperview];
            }
            if (![[self.previewingReusableView subviews]containsObject:self.videoPlayerView]) {
                [self.previewingReusableView addSubview:self.videoPlayerView];
            }
            if (model.videoUrlString) {
                [self.videoPlayerView setAssetModel:model];
                DazzleAssetModel * copyAssetModel = [model copy];
                [self.hasSelectedDatas addObject:copyAssetModel];
            }else{
				[self.videoPlayerView setAssetModel:model];
                [self requestDatas:model copyAssetModel:nil];
            }
        }else if (model.mediaType == PHAssetMediaTypeImage){
            DazzleAssetModel * copyAssetModel = [model copy];
            [self.hasSelectedDatas addObject:copyAssetModel];
            [self.hasSelectedDatas enumerateObjectsUsingBlock:^(DazzleAssetModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.mediaType == PHAssetMediaTypeVideo) {
                    [self.hasSelectedDatas removeObject:obj];
                }
            }];
            model.selected = YES;
            cell.model = model;
            NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
            NSString * key = [NSString stringWithFormat:@"key_s:%zdr:%zd",indexPath.section,indexPath.row];
            copyAssetModel.groupKey = key;
            if (![[self.optionalJsonData allKeys]containsObject:key]) {
                NSMutableDictionary * json = [NSMutableDictionary dictionary];
                NSMutableArray * datas = [NSMutableArray array];
                [datas addObject:copyAssetModel];
                [json setObject:indexPath forKey:@"indexPath"];
                [json setObject:datas forKey:@"data"];
                [json setObject:model forKey:@"model"];
                [self.optionalJsonData setObject:json forKey:key];
                [self.hasSelectedCellDatas addObject:indexPath];
            }else{
                NSMutableDictionary * json = [self.optionalJsonData objectForKey:key];
                NSMutableArray * datas = json[@"data"];
                [datas addObject:copyAssetModel];
                [self.optionalJsonData setObject:json forKey:key];
            }
            if ([[self.previewingReusableView subviews]containsObject:self.videoPlayerView]) {
                [self.videoPlayerView stopVideo];
                [self.videoPlayerView removeFromSuperview];
            }
            if (self.hasSelectedDatas.count < 2) {
                [self.placeholderView removeFromSuperview];
                [self.categoryView removeFromSuperview];
                [self.videoPlayerView removeFromSuperview];
                [self configHeaderViewContentHeight:400];
                self.placeholderView.frame = CGRectMake(0, 0, kScreenWidth, 400);
                [self.previewingReusableView setViewsHidden:YES];
                if (![[self.previewingReusableView subviews]containsObject:self.placeholderView]) {
                    [self.previewingReusableView addSubview:self.placeholderView];
                }
                if (model.originImage) {
                    [self.placeholderView setAssetModel:model];
                }else{
                    //请求图片的原始图片和视频的本地地址
					[self.placeholderView setAssetModel:model];
//
					[self requestDatas:model copyAssetModel:copyAssetModel];
                }
                [self.hasSelectedCellDatas enumerateObjectsUsingBlock:^(NSIndexPath *  _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
                    DazzlePreviewingCell * viewingCell = (DazzlePreviewingCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
                    DazzleAssetModel * optionalModel = self.datas[indexPath.row];
                    if (optionalModel.mediaType ==PHAssetMediaTypeVideo) {
                        optionalModel.selected = NO;
                        [self.hasSelectedCellDatas removeObject:indexPath];
                    }
                    viewingCell.model = optionalModel;
                }];
            }else if (self.hasSelectedDatas.count >=2){
                [self.previewingReusableView setViewsHidden:YES];
                [self configHeaderViewContentHeight:100];
                if ([[self.previewingReusableView subviews]containsObject:self.placeholderView]) {
                    [self.placeholderView removeFromSuperview];
                }
                if (![[self.previewingReusableView subviews]containsObject:self.categoryView]) {
                    [self.previewingReusableView addSubview:self.categoryView];
                }
                if (model.originImage == nil) {
                    //请求图片的原始图片和视频的本地地址
                    [self requestDatas:model copyAssetModel:copyAssetModel];
                }
                [self.categoryView setData:self.optionalJsonData];
                [self.categoryView setItems:self.hasSelectedDatas];
            }
        }
    }else if ([opt isEqualToString:@"unSelected"]){
        [self.hasSelectedCellDatas removeObject:indexPath];
        NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
        NSString * key = [NSString stringWithFormat:@"key_s:%zdr:%zd",indexPath.section,indexPath.row];
        NSMutableDictionary * json = [self.optionalJsonData objectForKey:key];
        NSArray * items = json[@"data"];
        DazzleAssetModel * model = json[@"model"];
        model.selected = NO;
        [self.hasSelectedDatas removeObjectsInArray:items];
        [self.optionalJsonData removeObjectForKey:key];
        if (self.hasSelectedDatas.count >=2) {
            [self.previewingReusableView setViewsHidden:YES];
            [self configHeaderViewContentHeight:100];
            [self.categoryView setData:self.optionalJsonData];
            [self.categoryView setItems:self.hasSelectedDatas];
        }else if(self.hasSelectedDatas.count == 0){
            [self configHeaderViewContentHeight:400];
            [self.placeholderView removeFromSuperview];
            [self.categoryView removeFromSuperview];
            [self.videoPlayerView removeFromSuperview];
            [self.previewingReusableView setViewsHidden:NO];
        }else if (self.hasSelectedDatas.count ==1){
            [self.previewingReusableView setViewsHidden:YES];
            [self configHeaderViewContentHeight:400];
            self.placeholderView.frame = CGRectMake(0, 0, kScreenWidth, 400);
            [self.placeholderView removeFromSuperview];
            [self.categoryView removeFromSuperview];
            [self.videoPlayerView removeFromSuperview];
            [self.previewingReusableView addSubview:self.placeholderView];
            DazzleAssetModel * model =(DazzleAssetModel*)[self.hasSelectedDatas lastObject];
            [self.placeholderView setAssetModel:model];
        }
    }
}

-(void)requestDatas:(DazzleAssetModel*)model copyAssetModel:(DazzleAssetModel*)copyModel{
    if (model == nil )return;
	[self.progressView setHidden:NO];
    if (model.mediaType == PHAssetMediaTypeImage) {
        __weak typeof(self)weakSelf = self;
        [PhotoDowloadTool getImageData:model.phAsset startRequestIcloud:^(PHImageRequestID cloudRequestId) {
        } progressHandler:^(double progress) {
			__strong typeof(weakSelf)strongSelf = weakSelf;
			strongSelf.progressView.progress = progress;
        } completion:^(NSData *imageData, UIImageOrientation orientation) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
			[[UIApplication sharedApplication]endIgnoringInteractionEvents];
			[strongSelf.progressView setHidden:YES];
            UIImage * image = [UIImage imageWithData:imageData];
            model.originImage = image;
            copyModel.originImage = image;
            if (strongSelf.hasSelectedDatas.count < 2){
                [strongSelf.placeholderView setAssetModel:model];
            }
        } failed:^(NSDictionary *info) {
			[[UIApplication sharedApplication]endIgnoringInteractionEvents];
			[self.progressView showError];
        }];
    }else if (model.mediaType == PHAssetMediaTypeVideo){
        __weak typeof(self)weakSelf = self;
		[[UIApplication sharedApplication]beginIgnoringInteractionEvents];
        [PhotoDowloadTool getMediumQualityAVAssetWithPHAsset:model.phAsset startRequestIcloud:^(PHImageRequestID cloudRequestId) {
        } progressHandler:^(double progress) {
			__strong typeof(weakSelf)strongSelf = weakSelf;
			strongSelf.progressView.progress = progress;
        } completion:^(AVAsset *asset) {
			__strong typeof(weakSelf)strongSelf = weakSelf;
			[[UIApplication sharedApplication]endIgnoringInteractionEvents];
			[strongSelf.progressView setHidden:YES];
            if ([asset isKindOfClass:[AVURLAsset class]]) {
                AVURLAsset * urlAsset = (AVURLAsset*)asset;
                model.videoUrlString     = urlAsset.URL.absoluteString;                
				if ([asset isKindOfClass:[AVURLAsset class]]) {
					AVURLAsset* urlAsset = (AVURLAsset*)asset;
					NSNumber *size;
					[urlAsset.URL getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
					CGFloat videoSize = [size floatValue]/(1024.0*1024.0);
					model.videoSize = videoSize;
				}
                DazzleAssetModel * copyAssetModel = [model copy];
                [strongSelf.hasSelectedDatas addObject:copyAssetModel];
                if (strongSelf.hasSelectedDatas.count < 2){
                    [strongSelf.videoPlayerView setAssetModel:model];
                }
            }
        } failed:^(NSDictionary *info) {
			[[UIApplication sharedApplication]endIgnoringInteractionEvents];
			[self.progressView showError];
        }];
    }
}

-(Dazzle_PhotoPresentContainerView *)presentContainerView{
    _presentContainerView = ({
        if (!_presentContainerView) {
            _presentContainerView = [[Dazzle_PhotoPresentContainerView alloc]initWithFrame:CGRectMake(0,kScreenHeight, KScreenWidth, (kScreenHeight -SC_StatusBarAndNavigationBarHeight))];
            _presentContainerView.backgroundColor = [UIColor whiteColor];
            __weak typeof(self)weakSelf = self;
            _presentContainerView.callback = ^(DazzleAssetCollectionModel *model) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf loadDatasWithCollection:model];
                [strongSelf loadContainerView];
                [strongSelf.optionalTopView setCategoryWithString:model.collectionName];
            };
        }
        _presentContainerView;
    });
    return _presentContainerView;
}

#pragma mark - getter methods
-(ESPictureProgressView *)progressView{
	_progressView = ({
		if (!_progressView) {
			_progressView = [[ESPictureProgressView alloc]init];
			_progressView.centerX = CGRectGetMidX(self.view.frame);
			_progressView.centerY = CGRectGetMidY(self.view.frame)-50.f;
		}
		_progressView;
	});
	return _progressView;
}

-(NSMutableArray *)configRenderImages{
    _configRenderImages = ({
        if (!_configRenderImages) {
            _configRenderImages = [NSMutableArray array];
        }
        _configRenderImages;
    });
    return _configRenderImages;
}

-(NSMutableArray *)hasSelectedCellDatas{
    _hasSelectedCellDatas = ({
        if (!_hasSelectedCellDatas) {
            _hasSelectedCellDatas = [NSMutableArray array];
        }
        _hasSelectedCellDatas;
    });
    return _hasSelectedCellDatas;
}

-(NSMutableArray *)hasSelectedDatas{
    _hasSelectedDatas = ({
        if (!_hasSelectedDatas) {
            _hasSelectedDatas = [NSMutableArray array];
        }
        _hasSelectedDatas;
    });
    return _hasSelectedDatas;
}

-(NSMutableDictionary *)optionalJsonData{
    _optionalJsonData = ({
        if (!_optionalJsonData) {
            _optionalJsonData = [NSMutableDictionary dictionary];
        }
        _optionalJsonData;
    });
    return _optionalJsonData;
}

-(NSMutableArray *)datas{
    _datas = ({
        if (!_datas) {
            _datas = [NSMutableArray array];
        }
        _datas;
    });
    return _datas;
}

-(DazzlePreviewingReusableView *)previewingReusableView{
    _previewingReusableView = ({
        if (!_previewingReusableView) {
            _previewingReusableView = [[DazzlePreviewingReusableView alloc]initWithFrame:CGRectMake(0, SC_StatusBarAndNavigationBarHeight, KScreenWidth, 400)];
        }
        _previewingReusableView;
    });
    return _previewingReusableView;
}

-(PHAlbumCategoryView *)categoryView{
    _categoryView = ({
        if (!_categoryView) {
            _categoryView = [[PHAlbumCategoryView alloc]initWithFrame:CGRectMake(0,0, KScreenWidth, 100.f)];
            _categoryView.delegate = self;
        }
        _categoryView;
    });
    return _categoryView;
}

-(DazzlePhotoPlaceholderView *)placeholderView{
    _placeholderView = ({
        if (!_placeholderView) {
            _placeholderView = [[DazzlePhotoPlaceholderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
        }
        _placeholderView;
    });
    return _placeholderView;
}

-(Dazzle_VideoPlayerView *)videoPlayerView{
    _videoPlayerView = ({
        if (!_videoPlayerView) {
            _videoPlayerView = [[Dazzle_VideoPlayerView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
        }
        _videoPlayerView;
    });
    return _videoPlayerView;
}

-(AssetOptionalTopView *)optionalTopView{
    _optionalTopView = ({
        if (!_optionalTopView) {
            _optionalTopView = [[AssetOptionalTopView alloc]initWithFrame:CGRectZero];
            __weak typeof(self)weakSelf = self;
            _optionalTopView.callback = ^(NSString *title) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                if ([title isEqualToString:@"dismiss"]) {
                    [strongSelf dismissViewControllerAnimated:YES completion:nil];
                }else if ([title isEqualToString:@"category"]){
                    [strongSelf loadContainerView];
                }else if ([title isEqualToString:@"next"]){
                    [strongSelf photoPrepareComposition];
                }
            };
        }
        _optionalTopView;
    });
    return _optionalTopView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        AlbumCollectionFlowLayout *layout = [[AlbumCollectionFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.minimumInteritemSpacing = 1.f;
        layout.minimumLineSpacing = 1.f;
        self.albumCollectionFlowLayout = layout;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SC_StatusBarAndNavigationBarHeight, kScreen_Width, kScreen_Height - SC_StatusBarAndNavigationBarHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        if (@available(ios 11.0,*)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[DazzlePreviewingCell class] forCellWithReuseIdentifier:NSStringFromClass([DazzlePreviewingCell class])];
        UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvents:)];
        pangesture.minimumNumberOfTouches = 1;
        pangesture.delegate = self;
        [_collectionView setUserInteractionEnabled:YES];
        [_collectionView addGestureRecognizer:pangesture];
    }
    return _collectionView;
}

-(UIImageView *)videoCoverImageView{
    _videoCoverImageView = ({
        if (!_videoCoverImageView) {
            _videoCoverImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            _videoCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
            _videoCoverImageView.layer.masksToBounds = YES;
            UIImage * cover = [UIImage imageNamed:@"imgs.bundle/__wkg_qmx_photovideo_videoCover"];
            _videoCoverImageView.image = cover;
        }
        _videoCoverImageView;
    });
    return _videoCoverImageView;
}

-(void)panViewIsVideoContainer:(UIPanGestureRecognizer*)gesture{
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self.collectionView];
        CGFloat absX = fabs(translation.x);
        CGFloat absY = fabs(translation.y);
        // 设置滑动有效距离
        if (MAX(absX, absY) < 1.f)
            return;
        if (absX > absY ) {
            if (translation.x < 0) {
                //向左滑动
            }else{
                //向右滑动
            }
        } else if (absY > absX) {
            if (translation.y < 0) {
                if (CGRectGetMinY(self.previewingReusableView.frame) == -350)
                return;
                [self.optionalTopView setHidden:YES];
                self.previewingReusableView.frame = CGRectMake(0,translation.y, KScreenWidth,400);
                self.collectionView.frame = CGRectMake(0, (400 + translation.y), KScreenWidth,KScreenHeight - (400 + translation.y));
            }else{
                CGFloat offSetY = self.collectionView.contentOffset.y;
                if (offSetY > 0)return;
                CGFloat height = CGRectGetMinY(self.collectionView.frame);
                if (height >= (400 + SC_StatusBarAndNavigationBarHeight) )return;
                self.videoCoverImageView.frame = CGRectMake(0,0, KScreenWidth, 50);
                [self.videoCoverImageView removeFromSuperview];
                [self.optionalTopView setHidden:NO];
                self.previewingReusableView.frame = CGRectMake(0,(translation.y - 350), KScreenWidth, 400);
                self.collectionView.frame = CGRectMake(0,(translation.y + 50), KScreenWidth,KScreenHeight - (translation.y + 50));
            }
        }
    }
    if (gesture.state == UIGestureRecognizerStateCancelled ||
         gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [gesture translationInView:self.collectionView];
        CGFloat absX = fabs(translation.x);
        CGFloat absY = fabs(translation.y);
        CGFloat height = CGRectGetMinY(self.previewingReusableView.frame);
        if (absY > absX) {
            if (translation.y<0) {
                //向上滑动
                if (height <= - 400 * 0.5f) {
                    self.videoCoverImageView.frame = CGRectMake(0, 0, KScreenWidth, 50);
                    [self.previewingReusableView addSubview:self.videoCoverImageView];
                    [self.optionalTopView setHidden:YES];
                    self.previewingReusableView.frame = CGRectMake(0,-350, KScreenWidth, 400);
                    self.collectionView.frame = CGRectMake(0, 50, KScreenWidth,KScreenHeight - 50);
                }else{
                    [self configHeaderViewContentHeight:400];
                    self.videoCoverImageView.frame = CGRectMake(0, 0, KScreenWidth, 50);
                    [self.videoCoverImageView removeFromSuperview];
                    [self.optionalTopView setHidden:NO];
                }
            }else{
                if (height >= -150.f) {
                    [self configHeaderViewContentHeight:400];
                    self.videoCoverImageView.frame = CGRectMake(0, 0, KScreenWidth, 50);
                    [self.videoCoverImageView removeFromSuperview];
                    [self.optionalTopView setHidden:NO];
                }else{
                    CGFloat offSetY = self.collectionView.contentOffset.y;
                    if (offSetY > 0)return;
                    CGFloat height = CGRectGetMinY(self.collectionView.frame);
                    if (height >= (400 + SC_StatusBarAndNavigationBarHeight) )return;
                    self.videoCoverImageView.frame = CGRectMake(0, 0, KScreenWidth, 50);
                        [self.previewingReusableView addSubview:self.videoCoverImageView];
                        [self.optionalTopView setHidden:YES];
                        self.previewingReusableView.frame = CGRectMake(0,-350, KScreenWidth, 400);
                        self.collectionView.frame = CGRectMake(0, 50, KScreenWidth,KScreenHeight - 50);
                }
            }
        }
        [gesture setTranslation:CGPointZero inView:self.collectionView];
    }
}
-(void)panEmptyViewContainer:(UIPanGestureRecognizer*)gesture{
	if (gesture.state == UIGestureRecognizerStateChanged) {
		CGPoint translation = [gesture translationInView:self.collectionView];
		CGFloat absX = fabs(translation.x);
		CGFloat absY = fabs(translation.y);
			// 设置滑动有效距离
		if (MAX(absX, absY) < 1.f)
			return;
		if (absX > absY ) {
			if (translation.x < 0) {
					//向左滑动
			}else{
					//向右滑动
			}
		} else if (absY > absX) {
			if (translation.y < 0) {
				if (CGRectGetMinY(self.previewingReusableView.frame) == -350)
					return;
				[self.optionalTopView setHidden:YES];
				self.previewingReusableView.frame = CGRectMake(0,translation.y, KScreenWidth,400);
				self.collectionView.frame = CGRectMake(0, (400 + translation.y), KScreenWidth,KScreenHeight - (400 + translation.y));
			}else{
				CGFloat offSetY = self.collectionView.contentOffset.y;
				if (offSetY > 0)return;
				CGFloat height = CGRectGetMinY(self.collectionView.frame);
				if (height >= (400 + SC_StatusBarAndNavigationBarHeight) )return;
				self.videoCoverImageView.frame = CGRectMake(0,0, KScreenWidth, 50);
				[self.videoCoverImageView removeFromSuperview];
				[self.optionalTopView setHidden:NO];
				self.previewingReusableView.frame = CGRectMake(0,(translation.y - 350), KScreenWidth, 400);
				self.collectionView.frame = CGRectMake(0,(translation.y + 50), KScreenWidth,KScreenHeight - (translation.y + 50));
			}
		}
	}
	if (gesture.state == UIGestureRecognizerStateCancelled ||
		gesture.state == UIGestureRecognizerStateEnded) {
		CGPoint translation = [gesture translationInView:self.collectionView];
		CGFloat absX = fabs(translation.x);
		CGFloat absY = fabs(translation.y);
		CGFloat height = CGRectGetMinY(self.previewingReusableView.frame);
		if (absY > absX) {
			if (translation.y<0) {
					//向上滑动
				if (height <= - 400 * 0.5f) {
					self.videoCoverImageView.frame = CGRectMake(0, 0, KScreenWidth, 50);
					[self.previewingReusableView addSubview:self.videoCoverImageView];
					[self.optionalTopView setHidden:YES];
					self.previewingReusableView.frame = CGRectMake(0,-350, KScreenWidth, 400);
					self.collectionView.frame = CGRectMake(0, 50, KScreenWidth,KScreenHeight - 50);
				}else{
					[self configHeaderViewContentHeight:400];
					self.videoCoverImageView.frame = CGRectMake(0, 0, KScreenWidth, 50);
					[self.videoCoverImageView removeFromSuperview];
					[self.optionalTopView setHidden:NO];
				}
			}else{
				if (height >= -150.f) {
					[self configHeaderViewContentHeight:400];
					self.videoCoverImageView.frame = CGRectMake(0, 0, KScreenWidth, 50);
					[self.videoCoverImageView removeFromSuperview];
					[self.optionalTopView setHidden:NO];
				}else{
					CGFloat offSetY = self.collectionView.contentOffset.y;
					if (offSetY > 0)return;
					CGFloat height = CGRectGetMinY(self.collectionView.frame);
					if (height >= (400 + SC_StatusBarAndNavigationBarHeight) )return;
					self.videoCoverImageView.frame = CGRectMake(0, 0, KScreenWidth, 50);
					[self.previewingReusableView addSubview:self.videoCoverImageView];
					[self.optionalTopView setHidden:YES];
					self.previewingReusableView.frame = CGRectMake(0,-350, KScreenWidth, 400);
					self.collectionView.frame = CGRectMake(0, 50, KScreenWidth,KScreenHeight - 50);
				}
			}
		}
		[gesture setTranslation:CGPointZero inView:self.collectionView];
	}
}

#pragma mark - view Delegate
-(void)panEvents:(UIPanGestureRecognizer*)gesture{
	if (self.hasSelectedDatas.count !=1){
		if (self.hasSelectedDatas.count == 0) {
			[self panEmptyViewContainer:gesture];
		}
		return;
	}
    DazzleAssetModel * model = (DazzleAssetModel*)[self.hasSelectedDatas firstObject];
    if (model.mediaType == PHAssetMediaTypeVideo){
        [self panViewIsVideoContainer:gesture];
        return;
    }
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGFloat offSetY = self.collectionView.contentOffset.y;
        if (offSetY <=0 && [[self.previewingReusableView subviews]containsObject:self.placeholderView])return;
    }
    if (gesture.state == UIGestureRecognizerStateChanged) {
        [self pangestureMethod:gesture];
    }
    if(gesture.state == UIGestureRecognizerStateCancelled ||
             gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [gesture translationInView:self.collectionView];
        CGFloat absX = fabs(translation.x);
        CGFloat absY = fabs(translation.y);
        CGFloat height = CGRectGetHeight(self.previewingReusableView.frame);
        if (absY > absX) {
            if (translation.y<0) {
                //向上滑动
                if (height <= 400 * 0.5f) {
                    [self configHeaderViewContentHeight:100];
                    if ([[self.previewingReusableView subviews]containsObject:self.placeholderView]) {
                        [self.placeholderView removeFromSuperview];
                    }
                    self.categoryView.frame = CGRectMake(0, 0, KScreenWidth, 100);
                    if (![[self.previewingReusableView subviews]containsObject:self.categoryView]) {
                        [self.previewingReusableView addSubview:self.categoryView];
                    }
                    [self.categoryView setData:self.optionalJsonData];
                    [self.categoryView setItems:self.hasSelectedDatas];
                }else{
                    [self configHeaderViewContentHeight:400];
                    [self.previewingReusableView setViewsHidden:YES];
                    [self.placeholderView removeFromSuperview];
                    [self.categoryView removeFromSuperview];
                    [self.videoPlayerView removeFromSuperview];
                    self.placeholderView.frame = CGRectMake(0, 0, KScreenWidth, 400);
                    [self.previewingReusableView addSubview:self.placeholderView];
                    DazzleAssetModel * model =(DazzleAssetModel*)[self.hasSelectedDatas lastObject];
                    [self.placeholderView setAssetModel:model];
                }
            }else{
                if (height >= 160.f) {
                    [self configHeaderViewContentHeight:400];
                    [self.previewingReusableView setViewsHidden:YES];
                    [self.placeholderView removeFromSuperview];
                    [self.categoryView removeFromSuperview];
                    [self.videoPlayerView removeFromSuperview];
                    self.placeholderView.frame = CGRectMake(0, 0, KScreenWidth, 400);
                    [self.previewingReusableView addSubview:self.placeholderView];
                    DazzleAssetModel * model =(DazzleAssetModel*)[self.hasSelectedDatas lastObject];
                    [self.placeholderView setAssetModel:model];
                    //向下滑动
                }else{
                    CGFloat offSetY = self.collectionView.contentOffset.y;
                    if (offSetY > 0)return;
                    CGFloat height = CGRectGetMinY(self.collectionView.frame);
                    if (height >= (400 + SC_StatusBarAndNavigationBarHeight) )return;
                    [self configHeaderViewContentHeight:100];
                    if ([[self.previewingReusableView subviews]containsObject:self.placeholderView]) {
                        [self.placeholderView removeFromSuperview];
                    }
                    self.categoryView.frame = CGRectMake(0, 0, KScreenWidth, 100);
                    if (![[self.previewingReusableView subviews]containsObject:self.categoryView]) {
                        [self.previewingReusableView addSubview:self.categoryView];
                    }
                    [self.categoryView setData:self.optionalJsonData];
                    [self.categoryView setItems:self.hasSelectedDatas];
                }
            }
        }
        [gesture setTranslation:CGPointZero inView:self.collectionView];
    }
}


-(void)pangestureMethod:(UIPanGestureRecognizer*)gesture{
    CGPoint translation = [gesture translationInView:self.collectionView];
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat absX = fabs(translation.x);
        CGFloat absY = fabs(translation.y);
        // 设置滑动有效距离
        if (MAX(absX, absY) < 1.f)
            return;
        if (absX > absY ) {
            if (translation.x < 0) {
                //向左滑动
            }else{
                //向右滑动
            }
        } else if (absY > absX) {
            if (translation.y < 0) {
                 //向上滑动
                if ([[self.previewingReusableView subviews]containsObject:self.categoryView]) return;
                [self configHeaderViewContentHeight:(400 + translation.y)];
                [self configPlaceholderViewHeight:(400 + translation.y)];
            }else{
                CGFloat offSetY = self.collectionView.contentOffset.y;
                if (offSetY > 0)return;
                CGFloat height = CGRectGetMinY(self.collectionView.frame);
                if (height >= (400 + SC_StatusBarAndNavigationBarHeight) )return;
                [self.placeholderView removeFromSuperview];
                [self.categoryView removeFromSuperview];
                [self.videoPlayerView removeFromSuperview];
                [self configHeaderViewContentHeight:100 + translation.y];
                [self configPlaceholderViewHeight:(100 + translation.y)];
            }
        }
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView * touchView = gestureRecognizer.view;
    if ([touchView isKindOfClass:[UICollectionView class]]) {
        return YES;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
@end
