//
//  TX_WKG_PhotoEditViewController.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/5/10.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_PhotoEditViewController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "PhotoInterruptView.h"
#import "CY_FaceDynamicsIssueController.h"
#import "TX_WKG_PhotoMenuEditView.h"
#import "XScratchView.h" //实现马赛克功能
#import "TX_WKG_PhotoScrawlContentView.h" //涂鸦功能
#import "TKImageView.h" //图片裁剪功能视图
#import "XRGBTool.h"
#import "TX_WKG_PhotoTool.h"
#import "TX_WKG_Photo_Tool.h"
#import "TX_WKG_RenderImageView.h"
#import "TX_WKG_Photo_EditConfig.h"
#import "TX_WKG_Photo_DragContentView.h"
#import "TX_WKG_Photo_TextEdit_PopOverView.h"
#import "TX_WKG_Effect_Node.h"
#import "TX_WKG_Paster_Node.h"
#import "TX_WKG_Photo_PasterContentView.h"

@interface  TX_WKG_SnapshotsModel : NSObject
@property (strong, nonatomic) NSMutableArray * snapshots;//屏幕获取快照容器
@end

@implementation TX_WKG_SnapshotsModel

-(NSMutableArray *)snapshots{
    _snapshots = ({
        if (!_snapshots) {
            _snapshots = [NSMutableArray array];
        }
        _snapshots;
    });
    return _snapshots;
}

@end


void * TX_WKG_Photo_Snapshots_CountKey = &TX_WKG_Photo_Snapshots_CountKey;

@interface TX_WKG_PhotoEditViewController ()<TX_WKG_PhotoOptionalDelegate>
@property (strong, nonatomic) UIImage * photo;
@property (strong, nonatomic) TX_WKG_RenderImageView * photoImageView;
@property (strong, nonatomic) PhotoInterruptView * photoInterruptView;
@property (strong, nonatomic) TX_WKG_PhotoMenuEditView * photoMenuEditView;
@property (nonatomic, strong) XScratchView *scratchView;
@property (strong, nonatomic) TX_WKG_PhotoScrawlContentView * scrawlContentView;
@property (strong, nonatomic) NSMutableArray * removeSubObjectViews;
@property (nonatomic, strong) TKImageView *cropView;
@property (strong, nonatomic) TX_WKG_SnapshotsModel *snapshotModel;
@property (strong, nonatomic) TX_WKG_Photo_DragContentView * dragContentView; //文本操作视图
@property (strong, nonatomic) NSMutableArray * undoContriners;
@property (copy, nonatomic)   TX_WKG_PhotoEditCompleteHander callback;
@property (strong, nonatomic) NSMutableArray * selectedImages;
@property (strong, nonatomic) UIView * dragSuperHolderView;
@property (strong, nonatomic) TX_WKG_Photo_TextEdit_PopOverView *popOverView;
@property (strong, nonatomic) TX_WKG_Photo_PasterContentView * pasterContentView;
@property (strong, nonatomic) GPUImagePicture * imagePicture;
@property (strong, nonatomic) UIImage * waitOptionalImage;
@end

@implementation TX_WKG_PhotoEditViewController


#pragma mark -
-(void)tx_Wkg_photoDidSelectedMainMenu:(NSString*)title{
    //当另外一个视图呈现出来的时候才设置这个代码
    [self.photoMenuEditView setSelectIndexPath:nil];
    [self.photoInterruptView setSubControllWithTitle:@"下一步" hidden:YES];
    [self.photoMenuEditView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(heightEx(145.f)));
    }];
    if ([title isEqualToString:@"马赛克"]) {
        [self.photoMenuEditView replaceMianMenuViewWithTitle:@"马赛克"];
    }else if([title isEqualToString:@"涂鸦"]){
        [self.photoMenuEditView replaceMianMenuViewWithTitle:@"涂鸦"];
    }else if([title isEqualToString:@"裁剪旋转"]){
        [self.photoMenuEditView replaceMianMenuViewWithTitle:@"裁剪旋转"];
    }else if([title isEqualToString:@"文本"]){
        [self.photoMenuEditView replaceMianMenuViewWithTitle:@"文本"];
    }else if([title isEqualToString:@"贴图"]){
        [self.photoMenuEditView replaceMianMenuViewWithTitle:@"贴图"];
    }else if ([title isEqualToString:@"滤镜"]){
        [self.photoMenuEditView replaceMianMenuViewWithTitle:@"滤镜"];
    }else if ([title isEqualToString:@"调节"]){
        [self.photoMenuEditView replaceMianMenuViewWithTitle:@"调节"];
    }
    [self.photoMenuEditView settingPhotoOptionViewHidden:NO];
}

#pragma mark - PhotoInterruptView Events
-(void)dimssViewControllerEvents:(NSString*)title{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextStepFuncationEvents:(NSString*)title{
    if (self.callback == nil) {
        UIImage * snapshotimage = self.photoImageView.image;
        if (snapshotimage == nil) return;
        //        [self.navigationController popViewControllerAnimated:NO];
        [self saveAlbum:snapshotimage];
        self.EditFinishBlock(snapshotimage);
        return;
        CY_FaceDynamicsIssueController *vc3 = [CY_FaceDynamicsIssueController new];
        NSMutableArray * items = [NSMutableArray array];
        dispatch_async(dispatch_queue_create("com.wkg.cn", DISPATCH_QUEUE_SERIAL), ^{
            [items addObject:snapshotimage];
            for (int i = 0; i < self.selectedImages.count; i++) {
                UIImage * image = self.selectedImages[i];
                [items addObject:image];
            }
            dispatch_barrier_async(dispatch_get_main_queue(), ^{
                [vc3 setPhotoModel:nil images:items];
                [self.navigationController pushViewController:vc3 animated:YES];
            });
        });
    }else{
        if (self.callback) {
            UIImage * image = self.photoImageView.image;
            if (image == nil) return;
            self.callback(image);
            [self saveAlbum:image];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)saveAlbum:(UIImage*)image{
    [HXPhotoTools savePhotoToCustomAlbumWithName:@"全民炫-脸圈" photo:image];
}
#pragma mark - getter methods
-(NSMutableArray *)selectedImages{
    _selectedImages = ({
        if (!_selectedImages) {
            _selectedImages = [NSMutableArray array];
        }
        _selectedImages;
    });
    return _selectedImages;
}

-(NSMutableArray *)undoContriners{
    _undoContriners = ({
        if (!_undoContriners) {
            _undoContriners = [NSMutableArray array];
        }
        _undoContriners;
    });
    return _undoContriners;
}

-(TX_WKG_SnapshotsModel *)snapshotModel{
    _snapshotModel  = ({
        if (!_snapshotModel) {
            _snapshotModel = [[TX_WKG_SnapshotsModel alloc]init];
        }
        _snapshotModel;
    });
    return _snapshotModel;
}

-(NSMutableArray *)removeSubObjectViews{
    _removeSubObjectViews = ({
        if (!_removeSubObjectViews) {
            _removeSubObjectViews = [NSMutableArray array];
        }
        _removeSubObjectViews;
    });
    return _removeSubObjectViews;
}

-(TX_WKG_PhotoScrawlContentView *)scrawlContentView{
    _scrawlContentView = ({
        if (!_scrawlContentView) {
            CGRect bounds = CGRectMake(0, 0, CGRectGetWidth(self.photoImageView.frame), CGRectGetHeight(self.photoImageView.frame));
            _scrawlContentView = [[TX_WKG_PhotoScrawlContentView alloc]initWithFrame:bounds];
        }
        _scrawlContentView;
    });
    return _scrawlContentView;
}

-(XScratchView *)scratchView{
    _scratchView = ({
        if (!_scratchView) {
            CGRect bounds = CGRectMake(0, 0, CGRectGetWidth(self.photoImageView.frame), CGRectGetHeight(self.photoImageView.frame));
            _scratchView = [[XScratchView alloc]initWithFrame:bounds];
        }
        _scratchView;
    });
    return _scratchView;
}
//添加文本视图
-(void)initializeTextContentView{
    if (_dragContentView == nil) {
        _dragContentView = [[TX_WKG_Photo_DragContentView alloc]initWithFrame:CGRectMake((KScreenWidth - widthEx(120))/2.f, CGRectGetHeight(self.photoImageView.frame)/2.f ,widthEx(120),heightEx(45))text:@"你若安好"];
        __weak typeof(self)weakSelf = self;
        _dragContentView.dragContentCallback = ^(NSString *optional) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if ([optional isEqualToString:@"编辑"]) {
                [strongSelf showPopOverView];
            }else if ([optional isEqualToString:@"关闭"]){
                [strongSelf.dragContentView removeFromSuperview];
                _dragContentView = nil;
            }
        };
    }
    if (_dragSuperHolderView == nil) {
        _dragSuperHolderView = [[UIView alloc]initWithFrame:CGRectMake(0,heightEx(45), KScreenWidth, KScreenHeight - heightEx(145 + 45))];
    }
    _dragContentView.contentLabel.textColor = (_dragContentView.textColor ==nil ? [UIColor blackColor] : _dragContentView.textColor);
    [_dragSuperHolderView addSubview:_dragContentView];
    [self.view addSubview:_dragSuperHolderView];
}

-(void)pasterSuperHolderViewDidSelected:(UITapGestureRecognizer*)gesture{
    NSArray *subviews = [[self.dragSuperHolderView.subviews reverseObjectEnumerator] allObjects];
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[TX_WKG_Photo_PasterContentView class]]) {
            TX_WKG_Photo_PasterContentView *dragView = (id)view;
            CGPoint location = [gesture locationInView:view];
            if (view.userInteractionEnabled && CGRectContainsPoint(dragView.imageView.frame, location)) {
                if ([dragView isToolBarHidden]) {
                    [dragView showToolBar];
                    [self.photoMenuEditView.pasterMenuView setSelectedPasterItemWithIndexPath:dragView.pasterNode.indexPath status:YES];
                }else {
                    [dragView hideToolBar];
                }
            }else {
                [dragView hideToolBar];
            }
        }
    }
}

-(void)initializePasterContentViewWithImageString:(NSString*)imageString withPasterNode:(TX_WKG_Paster_Node*)node{
    UIImage * image = [UIImage imageNamed:imageString];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_dragSuperHolderView){
            [[_dragSuperHolderView subviews]enumerateObjectsUsingBlock:^(__kindof TX_WKG_Photo_PasterContentView * _Nonnull pasterContentView, NSUInteger idx, BOOL * _Nonnull stop) {
                [pasterContentView hideToolBar];
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _pasterContentView =  [[TX_WKG_Photo_PasterContentView alloc]initWithFrame:CGRectMake((KScreenWidth - widthEx(120))/2.f, CGRectGetHeight(self.photoImageView.frame)/2.f ,widthEx(120),heightEx(45)) image:image];
            _pasterContentView.pasterNode = node;
            __weak typeof(self)weakSelf = self;
            _pasterContentView.pasterContentClickCallback = ^(NSString *optional) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                if ([optional isEqualToString:@"关闭"]) {
                    [strongSelf.photoMenuEditView.pasterMenuView setSelectedPasterItemWithIndexPath:strongSelf.pasterContentView.pasterNode.indexPath status:NO];
                    [strongSelf.dragContentView removeFromSuperview];
                    _dragContentView = nil;
                }
            };
            if (_dragSuperHolderView == nil) {
                _dragSuperHolderView = [[UIView alloc]initWithFrame:CGRectMake(0,heightEx(45), KScreenWidth, KScreenHeight - heightEx(145 + 45))];
                UITapGestureRecognizer * tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pasterSuperHolderViewDidSelected:)];
                tapgesture.numberOfTapsRequired = 1.f;
                _dragSuperHolderView.userInteractionEnabled = YES;
                [_dragSuperHolderView addGestureRecognizer:tapgesture];
            }
            [_dragSuperHolderView addSubview:_pasterContentView];
            [self.removeSubObjectViews addObject:_dragSuperHolderView];
            [self.view addSubview:_dragSuperHolderView];
        });
    });
}

-(void)showPopOverView{
    if (self.popOverView == nil) {
        self.popOverView = [[TX_WKG_Photo_TextEdit_PopOverView alloc]initWithFrame:[UIScreen mainScreen].bounds text:self.dragContentView.contentLabel.text];
        __weak typeof(self)weakSelf = self;
        self.popOverView.optionalCallback = ^(NSString *type, NSString *text) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.popOverView removeFromSuperview];
            _popOverView = nil;
            if ([type isEqualToString:@"关闭"]) {
                
            }else if([type isEqualToString:@"使用"]){
                [weakSelf.dragContentView setConfigWithContentText:text];
            }
        };
    }
    if ([self.popOverView.textView canBecomeFirstResponder]) {
        [self.popOverView.textView becomeFirstResponder];
    }
    [self.view addSubview:self.popOverView];
}

//初始化裁剪视图
-(void)initializeCropView{
    _cropView = [[TKImageView alloc] initWithFrame:self.photoImageView.frame];
    _cropView.toCropImage = self.photoImageView.image;
    _cropView.showMidLines = YES;
    _cropView.needScaleCrop = YES;
    _cropView.showCrossLines = YES;
    _cropView.cornerBorderInImage = NO;
    _cropView.cropAreaCornerWidth = 44;
    _cropView.cropAreaCornerHeight = 44;
    _cropView.minSpace = 30;
    _cropView.cropAreaCornerLineColor = [UIColor whiteColor];
    _cropView.cropAreaBorderLineColor = [UIColor whiteColor];
    _cropView.cropAreaCornerLineWidth = 4;
    _cropView.cropAreaBorderLineWidth = 2;
    _cropView.cropAreaMidLineWidth = 1;
    _cropView.cropAreaMidLineHeight = 1;
    _cropView.cropAreaMidLineColor = [UIColor whiteColor];
    _cropView.cropAreaCrossLineColor = [UIColor whiteColor];
    _cropView.cropAreaCrossLineWidth = 1;
    _cropView.initialScaleFactor = .8f;
    _cropView.cropAspectRatio = 1.0f;
    NSValue * value = [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)];
    CGSize aspect = [value CGSizeValue];
    [_cropView setCropAspectRatio:aspect.width/aspect.height];
    [_cropView show];
    [self.view addSubview:_cropView];
}
-(void)cropViewRotateOrClipsEvents:(NSString*)title{
    NSDictionary * json = @{@"旋转": [NSValue valueWithCGSize:CGSizeMake(0.0f, 0.0f)],
                            @"自由": [NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)],
                            @"原始":[NSValue valueWithCGSize:CGSizeMake(0.0f, 1.0f)],
                            @"1-1":[NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)],
                            @"4-3":[NSValue valueWithCGSize:CGSizeMake(4.0f, 3.0f)],
                            @"3-4":[NSValue valueWithCGSize:CGSizeMake(3.0f, 4.0f)],
                            @"9-16":[NSValue valueWithCGSize:CGSizeMake(9.0f, 16.0f)],
                            @"16-9":[NSValue valueWithCGSize:CGSizeMake(16.0f, 9.0f)],
                            };
    if ([title isEqualToString:@"旋转"]) {
        [self.cropView rotate];
    }else{
        NSValue * value =  json[title];
        CGSize aspect = [value CGSizeValue];
        [self.cropView setCropAspectRatio:aspect.width/aspect.height];
    }
}
#pragma mark - 图片全局撤销功能API开发
-(void)photoRollback{
    if (self.snapshotModel.snapshots.count == 0)return;
    UIImage * image =  (UIImage*)[self.snapshotModel.snapshots lastObject];
    [self.undoContriners addObject:image];
    [self.snapshotModel.snapshots removeLastObject];
    NSString * roll = self.snapshotModel.snapshots.count == 0 ? @"NO" : @"YES";
    NSString * undoRoll = @"YES";
    [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":roll,@"向后撤销":undoRoll} userInfo:nil];
    UIImage * placeImage;
    if (self.snapshotModel.snapshots.count == 0) {
        placeImage = self.photo;
    }else{
        placeImage = (UIImage*)[self.snapshotModel.snapshots lastObject];
    }
    self.photoImageView.image = placeImage;
    self.waitOptionalImage = placeImage;
}

-(void)photoUndoRollback{
    if (self.undoContriners.count == 0)return;
    UIImage * image = (UIImage*)[self.undoContriners lastObject];
    [self.snapshotModel.snapshots addObject:image];
    [self.undoContriners removeLastObject];
    NSString * roll = @"YES";
    NSString * undoRoll = self.undoContriners.count == 0 ? @"NO" : @"YES";
    [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":roll,@"向后撤销":undoRoll} userInfo:nil];
    UIImage * placeImage;
    if (self.snapshotModel.snapshots.count == 0) {
        placeImage = self.photo;
    }else{
        placeImage = (UIImage*)[self.snapshotModel.snapshots lastObject];
    }
    self.photoImageView.image = placeImage;
    self.waitOptionalImage = placeImage;
}

-(void)tx_wkg_photoGlobalOptionalWithFormatString:(NSString*)formatString{
    if ([formatString isEqualToString:@"向前撤销"]) {
        [self photoRollback];
    }else if([formatString isEqualToString:@"向后撤销"]){
        [self photoUndoRollback];
    }
}

-(TX_WKG_PhotoMenuEditView *)photoMenuEditView{
    _photoMenuEditView = ({
        if (!_photoMenuEditView) {
            _photoMenuEditView = [[TX_WKG_PhotoMenuEditView alloc]initWithFrame:CGRectZero];
            _photoMenuEditView.mainMenuDelegate = self;
            _photoMenuEditView.backgroundColor = [UIColor whiteColor];
            __weak typeof(self)weakSelf = self;
            _photoMenuEditView.optionalAssetsCallback = ^(NSString * menu,NSString *title) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                //所有子视图操作中，权限最高操作
                if ([title isEqualToString:@"关闭"]) {
                    [strongSelf.photoInterruptView setSubControllWithTitle:@"下一步" hidden:NO];
                    if (strongSelf.snapshotModel.snapshots.count > 0) {
                        [strongSelf.photoMenuEditView closeMenuView];
                        strongSelf.photoMenuEditView.selectIndexPath = nil;
                        [strongSelf.photoMenuEditView.collectionView setHidden:NO];
                        if (![[strongSelf.photoMenuEditView subviews]containsObject:strongSelf.photoMenuEditView.optionalView]) {
                            strongSelf.photoMenuEditView.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Normal_Optional_Type;
                            [strongSelf.photoMenuEditView addSubview:strongSelf.photoMenuEditView.optionalView];
                            [strongSelf.photoMenuEditView.optionalView mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.and.right.mas_equalTo(weakSelf);
                                make.bottom.mas_equalTo(weakSelf.photoMenuEditView.mas_bottom);
                                make.height.mas_equalTo(heightEx(45.f));
                            }];
                        }else{
                            strongSelf.photoMenuEditView.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Global_Optional_Type;
                        }
                        NSString * undoRoll = strongSelf.undoContriners.count == 0 ? @"NO" : @"YES";
                        NSString * roll = @"YES";
                        [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":roll,@"向后撤销":undoRoll} userInfo:nil];
                    }else{
                        [strongSelf.photoMenuEditView settingPhotoOptionViewHidden:YES];
                        [strongSelf.photoMenuEditView closeMenuView];
                        strongSelf.photoMenuEditView.selectIndexPath = nil;
                        [strongSelf.photoMenuEditView.collectionView setHidden:NO];
                        [strongSelf.photoMenuEditView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.mas_equalTo(@(heightEx(100.f)));
                        }];
                    }
                    for (int i = 0 ; i < strongSelf.removeSubObjectViews.count; i++) {
                        UIView * view = strongSelf.removeSubObjectViews[i];
                        [view removeFromSuperview];
                    }
                    [strongSelf.photoImageView setHidden:NO];
                    if ([menu isEqualToString:@"涂鸦"]) {
                        [strongSelf.scrawlContentView clearAllScreen];
                    }
                    if ([menu isEqualToString:@"马赛克"]) {
                        [strongSelf.scratchView clearAllScreen];
                    }
                    if ([menu isEqualToString:@"裁剪旋转"]){
                        [strongSelf.cropView hide];
                        [strongSelf.cropView removeFromSuperview];
                        [strongSelf.photoMenuEditView.clipsView  resetPhotoClipsStatus];
                    }
                    if ([menu isEqualToString:@"文本"]) {
                        [strongSelf.dragSuperHolderView removeFromSuperview];
                        [strongSelf.dragContentView removeFromSuperview];
                        _dragSuperHolderView = nil;
                        _dragContentView     = nil;
                        [strongSelf.photoMenuEditView.textView resetPhotoTextStatus];
                    }
                    if ([menu isEqualToString:@"贴图"]) {
                        [strongSelf.photoMenuEditView.pasterMenuView resetSelectedStatus];
                        [strongSelf.dragSuperHolderView removeFromSuperview];
                        [[strongSelf.dragSuperHolderView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    }
                    if ([menu isEqualToString:@"调节"]) {
                        [strongSelf.photoMenuEditView setBackgroundColor:[UIColor whiteColor]];
                       [strongSelf.photoMenuEditView.adaperView.bothway_slider resetViews];
                        [strongSelf.photoMenuEditView.adaperView resetPhotoAdaptorStatus];
                        strongSelf.photoImageView.image = strongSelf.waitOptionalImage;
                    }
                    if ([menu isEqualToString:@"滤镜"]) {
                        if (strongSelf.snapshotModel.snapshots.count == 0) {
                            strongSelf.photoImageView.image = strongSelf.photo;
                            strongSelf.waitOptionalImage = strongSelf.photo;

                        }else{
                            UIImage * image = (UIImage*)[strongSelf.snapshotModel.snapshots lastObject];
                            strongSelf.photoImageView.image = image;
                            strongSelf.waitOptionalImage = image;
                        }
                        [strongSelf.photoMenuEditView.effectView resetPhotoEffectStatus];
                    }
                    return;
                }
                if ([menu isEqualToString:@"全局撤销"]){
                    [strongSelf tx_wkg_photoGlobalOptionalWithFormatString:title];
                }
                else if ([menu isEqualToString:@"涂鸦"]) {
                    if ([title isEqualToString:@"涂鸦"]){
                        if (![[strongSelf.photoImageView subviews]containsObject:strongSelf.scrawlContentView]) {
                            [strongSelf.photoImageView addSubview:strongSelf.scrawlContentView];
                            [strongSelf.removeSubObjectViews addObject:strongSelf.scrawlContentView];
                        }
                    }else if([title isEqualToString:@"向前撤销"]){
                        [strongSelf.scrawlContentView rollback];
                    }else if([title isEqualToString:@"向后撤销"]){
                        [strongSelf.scrawlContentView undoRollback];
                    }else if([title isEqualToString:@"使用"]){
                        [strongSelf.photoInterruptView setSubControllWithTitle:@"下一步" hidden:NO];
                        [strongSelf.photoMenuEditView closeMenuView]; strongSelf.photoMenuEditView.selectIndexPath = nil;
                        [strongSelf.photoMenuEditView.collectionView setHidden:NO];
                        [strongSelf.photoImageView setHidden:NO];
                        UIImage * snapshot = [TX_WKG_Photo_Tool renderGrphicsWithViews:strongSelf.photoImageView renderSize:CGSizeMake(CGRectGetWidth(strongSelf.photoImageView.frame), CGRectGetHeight(strongSelf.photoImageView.frame))];
                        if (snapshot) {
                            strongSelf.photoImageView.image = snapshot;
                            strongSelf.waitOptionalImage = snapshot;
                            [[strongSelf.snapshotModel mutableArrayValueForKeyPath:@"snapshots"] addObject:snapshot];
                            NSString * roll = @"YES";
                            NSString * undoRoll = @"NO";
                            [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":roll,@"向后撤销":undoRoll} userInfo:nil];
                        }
                        [strongSelf.scrawlContentView clearAllOptData];
                        for (int i = 0 ; i < strongSelf.removeSubObjectViews.count; i++) {
                            UIView * view = strongSelf.removeSubObjectViews[i];
                            [view removeFromSuperview];
                        }
                    }
                }else if ([menu isEqualToString:@"裁剪旋转"]){
                    [strongSelf.photoImageView setHidden:YES];
                    if ([title isEqualToString:@"裁剪"]) {
                        [strongSelf initializeCropView];
                    }else if(![title isEqualToString:@"使用"]){
                        [strongSelf cropViewRotateOrClipsEvents:title];
                    }else{
                        //使用该图片功能
                        [strongSelf.photoMenuEditView.clipsView  resetPhotoClipsStatus];
                        [strongSelf.photoInterruptView setSubControllWithTitle:@"下一步" hidden:NO];
                        UIImage * image = [strongSelf.cropView currentCroppedImage];
                        [strongSelf.photoImageView setHidden:NO];
                        strongSelf.photoImageView.image = image;
                        strongSelf.waitOptionalImage = image;
                        [[strongSelf.snapshotModel mutableArrayValueForKeyPath:@"snapshots"] addObject:image];
                        NSString * roll = @"YES";
                        NSString * undoRoll = @"NO";
                        [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":roll,@"向后撤销":undoRoll} userInfo:nil];
                        [strongSelf.cropView hide];
                        [strongSelf.cropView removeFromSuperview];
                        
                        [strongSelf.photoMenuEditView closeMenuView]; strongSelf.photoMenuEditView.selectIndexPath = nil;
                        [strongSelf.photoMenuEditView.collectionView setHidden:NO];
                        for (int i = 0 ; i < strongSelf.removeSubObjectViews.count; i++) {
                            UIView * view = strongSelf.removeSubObjectViews[i];
                            [view removeFromSuperview];
                        }
                    }
                }else if ([menu isEqualToString:@"文本"]){
                    [strongSelf photoMenuOptionalDragTextViewWithTitle:title];
                }
                else if([menu isEqualToString:@"贴图"]){
                    [strongSelf photoMenuOPtionalsPasterWithTitle:title];
                }else if([menu isEqualToString:@"滤镜"]){
                    [strongSelf photoMenuOPtionalsEffectWithTitle:title];
                }else if ([menu isEqualToString:@"调节"]){
                    [strongSelf photoMenuOPtionalsAdaptorWithTitle:title];
                }
                else if ([menu isEqualToString:@"马赛克"]){
                    if ([title isEqualToString:@"马赛克"]) {
                        if (![[strongSelf.photoImageView subviews]containsObject:strongSelf.scratchView]) {
                            [strongSelf.photoImageView addSubview:strongSelf.scratchView];
                            [strongSelf.removeSubObjectViews addObject:strongSelf.scratchView];
                            strongSelf.scratchView.surfaceImage = strongSelf.photoImageView.image;
                            strongSelf.scratchView.mosaicImage  = [XRGBTool getMosaicImageWith:strongSelf.photoImageView.image level:0];
                            strongSelf.scratchView.scratchType = KTX_WKG_XScratchTypeWrite;
                        }
                    }
                    else if([title isEqualToString:@"向前撤销"]){
                        [strongSelf.scratchView rollback];
                    }else if ([title isEqualToString:@"向后撤销"]){
                        [strongSelf.scratchView undoRollback];
                    }else if([title isEqualToString:@"使用"]){
                        [strongSelf.photoInterruptView setSubControllWithTitle:@"下一步" hidden:NO];
                        [strongSelf.photoMenuEditView closeMenuView]; strongSelf.photoMenuEditView.selectIndexPath = nil;
                        [strongSelf.photoMenuEditView.collectionView setHidden:NO];
                        [strongSelf.photoImageView setHidden:NO];
                        UIImage * snapshot = [TX_WKG_Photo_Tool renderGrphicsWithViews:strongSelf.photoImageView renderSize:CGSizeMake(CGRectGetWidth(strongSelf.photoImageView.frame), CGRectGetHeight(strongSelf.photoImageView.frame))];
                        if (snapshot) {
                            strongSelf.photoImageView.image = snapshot;
                            strongSelf.waitOptionalImage = snapshot;
                            [[strongSelf.snapshotModel mutableArrayValueForKeyPath:@"snapshots"] addObject:snapshot];
                            NSString * roll = @"YES";
                            NSString * undoRoll = @"NO";
                            [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":roll,@"向后撤销":undoRoll} userInfo:nil];
                        }
                        [strongSelf.scratchView clearAllOptData];
                        for (int i = 0 ; i < strongSelf.removeSubObjectViews.count; i++) {
                            UIView * view = strongSelf.removeSubObjectViews[i];
                            [view removeFromSuperview];
                        }
                    }
                }
            };
        }
        _photoMenuEditView;
    });
    return _photoMenuEditView;
}
-(void)photoMenuOPtionalsAdaptorWithTitle:(NSString*)title{
    if ([title isEqualToString:@"使用"]) {
        self.photoMenuEditView.backgroundColor = [UIColor whiteColor];
        [self.photoMenuEditView.adaperView.bothway_slider resetViews];
        [self.photoMenuEditView.adaperView resetPhotoAdaptorStatus];
        
        [self.photoInterruptView setSubControllWithTitle:@"下一步" hidden:NO];
        UIImage * snapshot = [TX_WKG_Photo_Tool renderGrphicsWithViews:self.photoImageView renderSize:CGSizeMake(CGRectGetWidth(self.photoImageView.frame), CGRectGetHeight(self.photoImageView.frame))];
        if (snapshot) {
            self.photoImageView.image = snapshot;
            self.waitOptionalImage = snapshot;
            [[self.snapshotModel mutableArrayValueForKeyPath:@"snapshots"] addObject:snapshot];
            NSString * roll = @"YES";
            NSString * undoRoll = @"NO";
            [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":roll,@"向后撤销":undoRoll} userInfo:nil];
            [self.photoMenuEditView closeMenuView]; self.photoMenuEditView.selectIndexPath = nil;
            [self.photoMenuEditView.collectionView setHidden:NO];
            for (int i = 0 ; i < self.removeSubObjectViews.count; i++) {
                UIView * view = self.removeSubObjectViews[i];
                [view removeFromSuperview];
            }
        }
    }
}

-(void)photoMenuOPtionalsEffectWithTitle:(NSString*)title{
    if ([title isEqualToString:@"滤镜"]) {
        
    }else if ([title isEqualToString:@"使用"]){
        //使用该图片功能
        [self.photoMenuEditView.effectView resetPhotoEffectStatus];
        [self.photoInterruptView setSubControllWithTitle:@"下一步" hidden:NO];
        [self.photoImageView setHidden:NO];
        
        UIImage * snapshot = [TX_WKG_Photo_Tool renderGrphicsWithViews:self.photoImageView renderSize:CGSizeMake(CGRectGetWidth(self.photoImageView.frame), CGRectGetHeight(self.photoImageView.frame))];
        if (snapshot) {
            self.photoImageView.image = snapshot;
            self.waitOptionalImage = snapshot;
            [[self.snapshotModel mutableArrayValueForKeyPath:@"snapshots"] addObject:snapshot];
            NSString * roll = @"YES";
            NSString * undoRoll = @"NO";
            [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":roll,@"向后撤销":undoRoll} userInfo:nil];
            [self.photoMenuEditView closeMenuView]; self.photoMenuEditView.selectIndexPath = nil;
            [self.photoMenuEditView.collectionView setHidden:NO];
            for (int i = 0 ; i < self.removeSubObjectViews.count; i++) {
                UIView * view = self.removeSubObjectViews[i];
                [view removeFromSuperview];
            }
        }
    }
}

-(void)photoMenuOPtionalsPasterWithTitle:(NSString*)title{
    if ([title isEqualToString:@"贴图"]) {
        
    }else if ([title isEqualToString:@"使用"]){
        //使用该图片功能
        [self.photoMenuEditView.pasterMenuView resetSelectedStatus];
        [self.photoInterruptView setSubControllWithTitle:@"下一步" hidden:NO];
        [self.photoImageView setHidden:NO];
        CGFloat scaleX  = self.photoImageView.frame.size.width/CGImageGetWidth(self.photoImageView.image.CGImage);
        CGFloat scaleY  = self.photoImageView.frame.size.height/CGImageGetHeight(self.photoImageView.image.CGImage);
        CGFloat scaleFactor = MIN(scaleX, scaleY);
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.photoImageView.image];
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UIView *view in self.dragSuperHolderView.subviews) {
                if ([view isKindOfClass:[TX_WKG_Photo_PasterContentView class]]) {
                    TX_WKG_Photo_PasterContentView *originView = (TX_WKG_Photo_PasterContentView *)view;
                    TX_WKG_Photo_PasterContentView *dragView = [originView copyWithScaleFactor:scaleFactor relativedView:self.photoImageView];
                    [dragView hideToolBar];
                    [imageView addSubview:dragView];
                }
            }
            dispatch_barrier_async(dispatch_get_main_queue(), ^{
                UIImage * snapshot = [TX_WKG_Photo_Tool renderGrphicsWithViews:imageView renderSize:CGSizeMake(CGRectGetWidth(imageView.frame), CGRectGetHeight(imageView.frame))];
                if (snapshot) {
                    self.photoImageView.image = snapshot;
                    self.waitOptionalImage = snapshot;
                    [[self.snapshotModel mutableArrayValueForKeyPath:@"snapshots"] addObject:snapshot];
                    NSString * roll = @"YES";
                    NSString * undoRoll = @"NO";
                    [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":roll,@"向后撤销":undoRoll} userInfo:nil];
                    [self.photoMenuEditView closeMenuView]; self.photoMenuEditView.selectIndexPath = nil;
                    [self.photoMenuEditView.collectionView setHidden:NO];
                    [[self.dragSuperHolderView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    _dragSuperHolderView = nil;
                    _dragContentView = nil;
                    for (int i = 0 ; i < self.removeSubObjectViews.count; i++) {
                        UIView * view = self.removeSubObjectViews[i];
                        [view removeFromSuperview];
                    }
                }
            });
        });
    }
}

-(void)photoMenuOptionalDragTextViewWithTitle:(NSString*)title{
    if ([title isEqualToString:@"文本"]) {
        [self initializeTextContentView];
    }else if ([title isEqualToString:@"使用"]){
        //使用该图片功能
        [self.photoInterruptView setSubControllWithTitle:@"下一步" hidden:NO];
        [self.photoImageView setHidden:NO];
        //根据编辑器在子视图位置
        if (_dragContentView) {
            CGPoint convertPoint = [_dragContentView convertPoint:CGPointZero toView:self.photoImageView];
            _dragContentView.frame = CGRectMake(convertPoint.x, convertPoint.y, CGRectGetWidth(_dragContentView.frame), CGRectGetHeight(_dragContentView.frame));
            [_dragContentView hideToolBar];
            [self.photoImageView addSubview:_dragContentView];
        }
        UIImage * snapshot = [TX_WKG_Photo_Tool renderGrphicsWithViews:self.photoImageView renderSize:CGSizeMake(CGRectGetWidth(self.photoImageView.frame), CGRectGetHeight(self.photoImageView.frame))];
        if (snapshot) {
            if (_dragContentView) {
                [self.removeSubObjectViews addObject:_dragContentView];
                [self.dragContentView removeFromSuperview];
            }
            [self.dragSuperHolderView removeFromSuperview];
            self.photoImageView.image = snapshot;
            self.waitOptionalImage = snapshot;
            [[self.snapshotModel mutableArrayValueForKeyPath:@"snapshots"] addObject:snapshot];
            NSString * roll = @"YES";
            NSString * undoRoll = @"NO";
            [[NSNotificationCenter defaultCenter]postNotificationName:TX_WKG_NOTIFICATION_PHOTO_MENUOPTIONAL_DEFINIER object:@{@"向前撤销":roll,@"向后撤销":undoRoll} userInfo:nil];
            
            _dragSuperHolderView = nil;
            _dragContentView     = nil;
            [self.photoMenuEditView.textView resetPhotoTextStatus];
            [self.photoMenuEditView closeMenuView]; self.photoMenuEditView.selectIndexPath = nil;
            [self.photoMenuEditView.collectionView setHidden:NO];
            for (int i = 0 ; i < self.removeSubObjectViews.count; i++) {
                UIView * view = self.removeSubObjectViews[i];
                [view removeFromSuperview];
            }
        }
    }
}

-(PhotoInterruptView *)photoInterruptView{
    _photoInterruptView = ({
        if (!_photoInterruptView) {
            _photoInterruptView = [[PhotoInterruptView alloc]initWithFrame:CGRectZero];
            _photoInterruptView.backgroundColor = [UIColor whiteColor];
            __weak typeof(self)weakSelf = self;
            _photoInterruptView.opt_callback = ^(UIButton *item, NSString *title) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
                NSDictionary * json = @{@"返回":@"dimssViewControllerEvents:",
                                        @"下一步":@"nextStepFuncationEvents:",
                                        };
                NSString * selector = json[title];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                SEL sel = NSSelectorFromString(selector);
                [strongSelf performSelector:sel withObject:item];
#pragma clang diagnostic pop
            };
        }
        _photoInterruptView;
    });
    return _photoInterruptView;
}

-(TX_WKG_RenderImageView *)photoImageView{
    _photoImageView = ({
        if (!_photoImageView) {
            CGRect frame = CGRectMake(widthEx(20), SC_StatusBarAndNavigationBarHeight + 8.f, KScreenWidth - widthEx(40.f), KScreenHeight - heightEx(150) - SC_StatusBarAndNavigationBarHeight -8.f);
            _photoImageView = [[TX_WKG_RenderImageView alloc]initWithFrame:frame];
            _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
            _photoImageView.layer.masksToBounds = YES;
            _photoImageView.userInteractionEnabled = YES;
        }
        _photoImageView;
    });
    return _photoImageView;
}

-(instancetype)initWithCameraPhoto:(UIImage*)photo selecttedImages:(NSArray<UIImage*>*)selectedImages{
    if (self = [super init]) {
        self.photo = photo;
        if (selectedImages == nil || selectedImages.count == 0){}else{
            [selectedImages enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.selectedImages addObject:image];
            }];
        }
    }
    return self;
}

-(instancetype)initWithCameraPhoto:(UIImage*)photo callback:(TX_WKG_PhotoEditCompleteHander)callback{
    if (self = [super init]) {
        self.photo = photo;
        self.callback = [callback copy];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager]setEnable:NO];
    self.photoImageView.image = self.photo;
    self.waitOptionalImage = self.photo;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager]setEnable:YES];;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    self.view.backgroundColor   = UIColorFromRGB(0x474747);
    __weak typeof(self)weakSelf = self;
    [self.view addSubview:self.photoInterruptView];
    [self.photoInterruptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(0);
        make.height.mas_equalTo(SC_StatusBarAndNavigationBarHeight);
    }];
    [self.view addSubview:self.photoMenuEditView];
    [self.photoMenuEditView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom);
        make.height.mas_equalTo(heightEx(100.f));
    }];
    [self.view addSubview:self.photoImageView];
    [self.view bringSubviewToFront:self.photoMenuEditView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tx_wkg_photo_paster_effective_events:) name:TX_WKG_PHOTO_ADD_PASTER_EFFECTIVE_NOTIFICATION_DEFINER object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tx_wkg_photo_adaptor_effective_events:) name:TX_WKG_PHOTO_NEWDECOMMEND_ADPATOR_EFFECTIVE_NOTIFICATION_DEFINER object:nil];
    [self.snapshotModel addObserver:self forKeyPath:@"snapshots" options:(NSKeyValueObservingOptionNew) context:TX_WKG_Photo_Snapshots_CountKey];
    
    
    
}

-(void)tx_wkg_photo_adaptor_effective_events:(NSNotification*)notification{
    id obj = notification.object;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary * json = (NSDictionary*)obj;
        if ([json[@"optional"] isEqualToString:@"亮度"]) {
            GPUImageBrightnessFilter * brightnessFilter = [[GPUImageBrightnessFilter alloc]init];
            [brightnessFilter setBrightness:[json[@"value"]floatValue]];
            [brightnessFilter forceProcessingAtSize:self.waitOptionalImage.size];
            [brightnessFilter useNextFrameForImageCapture];
            GPUImagePicture * imagePicture = [[GPUImagePicture alloc]initWithImage:self.waitOptionalImage];
            [imagePicture addTarget:brightnessFilter];
            [imagePicture processImage];
            UIImage * renderImage = [brightnessFilter imageFromCurrentFramebuffer];
            self.photoImageView.image = renderImage;
        }else if ([json[@"optional"] isEqualToString:@"饱和度"]){
            CGFloat value = [json[@"value"]floatValue];
            value += 1;
            GPUImageSaturationFilter * saturationFilter = [[GPUImageSaturationFilter alloc]init];
            saturationFilter.saturation = value;
            [saturationFilter forceProcessingAtSize:self.waitOptionalImage.size];
            [saturationFilter useNextFrameForImageCapture];
            GPUImagePicture * imagePicture = [[GPUImagePicture alloc]initWithImage:self.waitOptionalImage];
            [imagePicture addTarget:saturationFilter];
            [imagePicture processImage];
            UIImage * renderImage = [saturationFilter imageFromCurrentFramebuffer];
            self.photoImageView.image = renderImage;
        }else if ([json[@"optional"] isEqualToString:@"锐化"]){
            GPUImageSharpenFilter * sharpenFilter = [[GPUImageSharpenFilter alloc]init];
            CGFloat value = [json[@"value"]floatValue];
            value *= 4;
            sharpenFilter.sharpness = value;
            [sharpenFilter forceProcessingAtSize:self.waitOptionalImage.size];
            [sharpenFilter useNextFrameForImageCapture];
            GPUImagePicture * imagePicture = [[GPUImagePicture alloc]initWithImage:self.waitOptionalImage];
            [imagePicture addTarget:sharpenFilter];
            [imagePicture processImage];
            UIImage * renderImage = [sharpenFilter imageFromCurrentFramebuffer];
            self.photoImageView.image = renderImage;
        }else if ([json[@"optional"] isEqualToString:@"色温"]){
            CGFloat value = [json[@"value"]floatValue];
            if (value < 0) {
                value = 1000 + 4000 * (1 - fabs(value));
            }else{
                value = 5000 + 4000 * value;
            }
            GPUImageWhiteBalanceFilter * whiteBalanceFilter = [[GPUImageWhiteBalanceFilter alloc]init];
            whiteBalanceFilter.temperature = value;
            whiteBalanceFilter.tint = 0.f;
            [whiteBalanceFilter forceProcessingAtSize:self.waitOptionalImage.size];
            [whiteBalanceFilter useNextFrameForImageCapture];
            GPUImagePicture * imagePicture = [[GPUImagePicture alloc]initWithImage:self.waitOptionalImage];
            [imagePicture addTarget:whiteBalanceFilter];
            [imagePicture processImage];
            UIImage * renderImage = [whiteBalanceFilter imageFromCurrentFramebuffer];
            self.photoImageView.image = renderImage;
        }
    }
}

-(void)tx_wkg_photo_paster_effective_events:(NSNotification*)notification{
    id obj = notification.object;
    if ([obj isKindOfClass:[TX_WKG_Paster_Node class]]) {
        TX_WKG_Paster_Node * node = (TX_WKG_Paster_Node *)obj;
        [self initializePasterContentViewWithImageString:node.imageString withPasterNode:node];
    }else if ([obj isKindOfClass:[TX_WKG_Effect_Node class]]){
        TX_WKG_Effect_Node * node = (TX_WKG_Effect_Node*)obj;
        if (node.optionalImage == nil){
            if (self.snapshotModel.snapshots.count == 0) {
                self.photoImageView.image = self.photo;
                self.waitOptionalImage = self.photo;
            }else{
                UIImage * image = (UIImage*)[self.snapshotModel.snapshots lastObject];
                self.photoImageView.image = image;
                self.waitOptionalImage = image;
            }
            return;
        }
        //获取title
        UIImage * lookupFilterImage = nil;
        if (self.snapshotModel.snapshots.count == 0) {
            lookupFilterImage = self.photo;
        }else{
            UIImage * image = (UIImage*)[self.snapshotModel.snapshots lastObject];
            lookupFilterImage = image;
        }
        if (self.imagePicture == nil) {
            self.imagePicture = [[GPUImagePicture alloc]initWithImage:lookupFilterImage];
        }
        GPUImageLookupFilter *lookUpFilter = [[GPUImageLookupFilter alloc] init];
        GPUImagePicture *lookupImg = [[GPUImagePicture alloc] initWithImage:node.optionalImage];
        [lookupImg addTarget:lookUpFilter atTextureLocation:1];
        [self.imagePicture addTarget:lookUpFilter atTextureLocation:0];
        [lookUpFilter useNextFrameForImageCapture];
        if ([lookupImg processImageWithCompletionHandler:nil] && [self.imagePicture processImageWithCompletionHandler:nil]) {
            UIImage * image = [lookUpFilter imageFromCurrentFramebuffer];
            self.photoImageView.image = image;
            self.waitOptionalImage = image;
            _imagePicture = nil;
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == TX_WKG_Photo_Snapshots_CountKey) {
        NSMutableArray * snapshots =  (NSMutableArray*)change[@"new"];
        if (snapshots.count > 0) {
            if (![[self.photoMenuEditView subviews]containsObject:self.photoMenuEditView.optionalView]) {
                __weak typeof(self)weakSelf = self;
                self.photoMenuEditView.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Normal_Optional_Type;
                [self.photoMenuEditView addSubview:self.photoMenuEditView.optionalView];
                [self.photoMenuEditView.optionalView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.mas_equalTo(weakSelf);
                    make.bottom.mas_equalTo(weakSelf.photoMenuEditView.mas_bottom);
                    make.height.mas_equalTo(heightEx(45.f));
                }];
            }else{
                self.photoMenuEditView.optionalView.photoMenuType = TX_WKG_PhotoMenuEdit_Global_Optional_Type;
            }
        }else{
            [self.photoMenuEditView settingPhotoOptionViewHidden:YES];
            [self.photoMenuEditView closeMenuView];
            self.photoMenuEditView.selectIndexPath = nil;
            [self.photoMenuEditView.collectionView setHidden:NO];
            [self.photoMenuEditView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@(heightEx(100.f)));
            }];
            for (int i = 0 ; i < self.removeSubObjectViews.count; i++) {
                UIView * view = self.removeSubObjectViews[i];
                [view removeFromSuperview];
            }
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:TX_WKG_PHOTO_ADD_PASTER_EFFECTIVE_NOTIFICATION_DEFINER object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:TX_WKG_PHOTO_NEWDECOMMEND_ADPATOR_EFFECTIVE_NOTIFICATION_DEFINER object:nil];
    [self.snapshotModel removeObserver:self forKeyPath:@"snapshots"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
