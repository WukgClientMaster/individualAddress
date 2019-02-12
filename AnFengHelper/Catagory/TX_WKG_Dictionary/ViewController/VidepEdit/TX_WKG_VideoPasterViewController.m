//
//  TX_WKG_VideoPasterViewController.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/23.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKG_VideoPasterViewController.h"
#import "RangeContent.h"
#import "PasterSelectView.h"
#import "VideoPreview.h"
#import "VideoPasterView.h"
#import "UIView+Additions.h"
#import "TextCollectionCell.h"
#import "RangeConfig.h"

@implementation VideoPasterInfo

@end

@interface TX_WKG_VideoPasterViewController ()<VideoPreviewDelegate, UICollectionViewDelegate,UICollectionViewDataSource,RangeContentDelegate,PasterSelectViewDelegate,VideoPasterViewDelegate>{
    VideoPreview  *_videoPreview;       //视频预览view
    TXVideoEditer* _ugcEditer;          //sdk的editer
    RangeContent * _videoRangeSlider;    //字幕的时间区域操作条
    UILabel*       _leftTimeLabel;
    UILabel*       _rightTimeLabel;
    UISlider*   _progressView;          //播放进度条
    UILabel*    _progressedLabel;       //播放时间
    UICollectionView* _videoTextCollection; //己添加字幕列表
    UICollectionView* _videoPasterCollection; //己添加贴纸列表
    UIButton*      _playBtn;            //播放按钮
    CGFloat        _videoStartTime;     //裁剪的视频开始时间
    CGFloat        _videoEndTime;       //裁剪的视频结束时间
    CGFloat        _previewAtTime;      //预览时间点
    CGFloat        _videoDuration;      //裁剪的视频总时间
    UILabel*       _timeLabel;
    BOOL           _isVideoPlaying;
    NSMutableArray<VideoPasterInfo*>* _videoPasterInfos;
    UITapGestureRecognizer* _singleTap;
    PasterSelectView *  _selectView;
    UIView      *       _videoPasterView;
    NSArray *      _qipaoList;
    NSArray *      _pasterList;
    PasterSelectView * _animateView;
    PasterSelectView * _staticView;
}
@end

@implementation TX_WKG_VideoPasterViewController
- (instancetype)initWithVideoEditer:(TXVideoEditer*)videoEditer previewView:(VideoPreview*)previewView startTime:(CGFloat)startTime endTime:(CGFloat)endTime pasterInfos:(NSArray<VideoPasterInfo*>*)pasterInfos{
    if (self = [super init]) {
        _ugcEditer = videoEditer;
        _videoPreview = previewView;
        _videoPreview.delegate = self;
        _videoStartTime = startTime;
        _videoEndTime = endTime;
        _videoDuration = endTime - startTime;
        _videoPasterInfos = pasterInfos.mutableCopy;
        //未添加过动图
        if (!_videoPasterInfos) {
            _videoPasterInfos = [NSMutableArray new];
        } else {
            //有己添加过动图
            for (VideoPasterInfo* pasterInfo in _videoPasterInfos) {
                pasterInfo.pasterView.delegate = self;
            }
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}
- (void)initUI{
    self.title = @"编辑视频";
    UIBarButtonItem * customBackButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"qmx_tuijian_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = customBackButton;
    customBackButton.tintColor = UIColorFromRGB(0xffffff);
    self.navigationItem.leftBarButtonItem = customBackButton;
    self.view.backgroundColor = UIColor.blackColor;
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
    @{NSFontAttributeName:[UIFont systemFontOfSize:17.f],
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _videoPreview.frame = CGRectMake(0, 0, self.view.width, 432 * kScaleY);
    _videoPreview.delegate = self;
    _videoPreview.backgroundColor = UIColor.darkTextColor;
    
    [_ugcEditer previewAtTime:_videoStartTime];
    [_ugcEditer pausePlay];
    _isVideoPlaying = NO;
    
    [_videoPreview setPlayBtnHidden:YES];
    [self.view addSubview:_videoPreview];
    UIImage* image = [UIImage imageNamed:@"videotext_play"];
    _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(15 * kScaleX, _videoPreview.bottom + 30 * kScaleY, image.size.width, image.size.height)];
    [_playBtn setImage:image forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(onPlayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playBtn];
    
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(_videoDuration) / 60, (int)(_videoDuration) % 60];
    _timeLabel.textColor = UIColorFromRGB(0x777777);
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [_timeLabel sizeToFit];
    _timeLabel.center = CGPointMake(self.view.width - 15 * kScaleX - _timeLabel.width / 2, _playBtn.center.y);
    [self.view addSubview:_timeLabel];
    
    UIView* toImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 2)];
    toImageView.backgroundColor = UIColor.lightGrayColor;
    UIImage* coverImage = toImageView.toImage;
    
    toImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    toImageView.backgroundColor = UIColorFromRGB(0x0accac);
    toImageView.layer.cornerRadius = 9;
    UIImage* thumbImage = toImageView.toImage;
    RangeConfig* config = [[RangeConfig alloc]init];
    config.pinWidth = 18;
    config.borderHeight = 0;
    config.thumbHeight = 20;
    config.leftPinImage = thumbImage;
    config.rightPigImage = thumbImage;
    config.leftCorverImage = coverImage;
    config.rightCoverImage = coverImage;
    
    toImageView = [UIView new];
    toImageView.backgroundColor = UIColorFromRGB(0x0accac);
    toImageView.bounds = CGRectMake(0, 0, _timeLabel.left - _playBtn.right - 15 - config.pinWidth * 2, 2);
    _videoRangeSlider = [[RangeContent alloc] initWithImageList:@[toImageView.toImage] config:config];
    _videoRangeSlider.center = CGPointMake(_playBtn.right + 7.5 + _videoRangeSlider.width / 2, _playBtn.center.y);
    _videoRangeSlider.delegate = self;
    _videoRangeSlider.hidden = YES;
    [self.view addSubview:_videoRangeSlider];
    
    _leftTimeLabel = [[UILabel alloc] init];
    _leftTimeLabel.textColor = UIColorFromRGB(0x777777);
    _leftTimeLabel.font = [UIFont systemFontOfSize:10];
    _leftTimeLabel.text = @"0:00";
    _leftTimeLabel.hidden = YES;
    [self.view addSubview:_leftTimeLabel];
    
    _rightTimeLabel = [[UILabel alloc] init];
    _rightTimeLabel.textColor = UIColorFromRGB(0x777777);
    _rightTimeLabel.font = [UIFont systemFontOfSize:10];
    _rightTimeLabel.text = @"0:00";
    _rightTimeLabel.hidden = YES;
    [self.view addSubview:_rightTimeLabel];
    
    _progressView = [UISlider new];
    _progressView.center = _videoRangeSlider.center;
    _progressView.bounds = CGRectMake(0, 0, _videoRangeSlider.width, 20);
    [self.view addSubview:_progressView];
    _progressView.tintColor = UIColorFromRGB(0x0accac);
    [_progressView setThumbImage:thumbImage forState:UIControlStateNormal];
    _progressView.minimumValue = _videoStartTime;
    _progressView.maximumValue = _videoEndTime;
    [_progressView addTarget:self action:@selector(onProgressSlided:) forControlEvents:UIControlEventValueChanged];
    [_progressView addTarget:self action:@selector(onProgressSlideEnd:) forControlEvents:UIControlEventTouchUpInside];
    
    _progressedLabel = [[UILabel alloc] initWithFrame:CGRectMake(_progressView.x, _progressView.y - 12, 30, 10)];
    _progressedLabel.textColor = UIColorFromRGB(0x777777);
    _progressedLabel.text = @"0:00";
    _progressedLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:_progressedLabel];
    
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - (40 + 40 * kScaleY) - 65, self.view.width, (40 + 40 * kScaleY))];
    bottomView.backgroundColor = UIColorFromRGB(0x181818);
    [self.view addSubview:bottomView];
    
    UIButton* newPasterBtn = [[UIButton alloc] initWithFrame:CGRectMake(17.5 * kScaleX, 20 * kScaleY, 40, 40)];
    [newPasterBtn setImage:[UIImage imageNamed:@"text_add"] forState:UIControlStateNormal];
    newPasterBtn.backgroundColor = UIColor.clearColor;
    newPasterBtn.layer.borderWidth = 1;
    newPasterBtn.layer.borderColor = UIColorFromRGB(0x777777).CGColor;
    [newPasterBtn addTarget:self action:@selector(onNewPasterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:newPasterBtn];
    
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _videoPasterCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(newPasterBtn.right + 10, 20 * kScaleY, self.view.width - 35 - 10, 40) collectionViewLayout:layout];
    _videoPasterCollection.delegate = self;
    _videoPasterCollection.dataSource = self;
    _videoPasterCollection.backgroundColor = UIColor.clearColor;
    _videoPasterCollection.allowsMultipleSelection = NO;
    [_videoPasterCollection registerClass:[PasterCollectionCell class] forCellWithReuseIdentifier:@"PasterCollectionCell"];
    [bottomView addSubview:_videoPasterCollection];
    
    [self createBubbleSelectView];
    
    //点击选中文字
    _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [_videoPreview addGestureRecognizer:_singleTap];
}
- (void)createBubbleSelectView
{
    int height = 90 * kScaleY;
    _videoPasterView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bottom - height - 60, self.view.width, height)];
    
    UIButton* animateBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0 , _videoPasterView.width / 2, 20)];
    [animateBtn setTitleColor:UIColorFromRGB(0x0accac) forState:UIControlStateNormal];
    [animateBtn setTitle:@"动态贴纸" forState:UIControlStateNormal];
    [animateBtn addTarget:self action:@selector(onPasterClicked:) forControlEvents:UIControlEventTouchUpInside];
    animateBtn.tag = 0;
    [_videoPasterView addSubview:animateBtn];
    
    UIButton* staticBtn = [[UIButton alloc] initWithFrame:CGRectMake(_videoPasterView.width / 2, 0 , _videoPasterView.width / 2, 20)];
    [staticBtn setTitleColor:UIColorFromRGB(0x0accac) forState:UIControlStateNormal];
    [staticBtn setTitle:@"静态贴纸" forState:UIControlStateNormal];
    [staticBtn addTarget:self action:@selector(onPasterClicked:) forControlEvents:UIControlEventTouchUpInside];
    staticBtn.tag = 1;
    [_videoPasterView addSubview:staticBtn];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"AnimatedPaster" ofType:@"bundle"];
    _animateView = [[PasterSelectView alloc] initWithFrame:CGRectMake(0, 20, _videoPasterView.width, _videoPasterView.height - 20)  pasterType:PasterType_Animate boundPath:bundlePath];
    _animateView.delegate = self;
    _animateView.hidden = NO;
    [_videoPasterView addSubview:_animateView];
    
    NSString *bundlePath2 = [[NSBundle mainBundle] pathForResource:@"Paster" ofType:@"bundle"];
    _staticView = [[PasterSelectView alloc] initWithFrame:CGRectMake(0, 20, _videoPasterView.width, _videoPasterView.height - 20) pasterType:PasterType_static boundPath:bundlePath2];
    _staticView.delegate = self;
    _staticView.hidden = YES;
    [_videoPasterView addSubview:_staticView];
    
    _videoPasterView.hidden = YES;
    [self.view addSubview:_videoPasterView];
}

- (void)onPasterClicked:(UIButton *)btn
{
    if (btn.tag == 0) {
        _animateView.hidden = NO;
        _staticView.hidden = YES;
    }else{
        _animateView.hidden = YES;
        _staticView.hidden = NO;
    }
}

#pragma PasterSelectViewDelegate
- (void)onPasterAnimateSelect:(PasterAnimateInfo *)info
{
    if (_videoPasterInfos.count > 0) {
        VideoPasterInfo* pasterInfo =  [self getSelectedVideoTextInfo];
        [pasterInfo.pasterView removeFromSuperview];
        
        int width = 170;
        int height = info.height / info.width * width;
        VideoPasterView *pasterView = [[VideoPasterView alloc] initWithFrame:CGRectMake((_videoPreview.width - width) / 2, (_videoPreview.height - height) / 2, width, height)];
        pasterView.delegate = self;
        [pasterView setImageList:info.imageList imageDuration:info.duration];
        [_videoPreview addSubview:pasterView];
        
        pasterInfo.pasterView = pasterView;
        pasterInfo.pasterInfoType = PasterInfoType_Animate;
        pasterInfo.path = info.path;
        pasterInfo.iconImage = info.iconImage;
        
        [self hiddeVideoPasterView];
        [self setVideoPasters:_videoPasterInfos];
        
        NSInteger index = [_videoPasterInfos indexOfObject:pasterInfo];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_videoPasterCollection selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
}

- (void)onPasterStaticSelect:(PasterStaticInfo *)info
{
    if (_videoPasterInfos.count > 0) {
        VideoPasterInfo* pasterInfo =  [self getSelectedVideoTextInfo];
        [pasterInfo.pasterView removeFromSuperview];
        
        int width = 170;
        int height = info.height / info.width * width;
        VideoPasterView *pasterView = [[VideoPasterView alloc] initWithFrame:CGRectMake((_videoPreview.width - width) / 2, (_videoPreview.height - height) / 2, width, height)];
        pasterView.delegate = self;
        [pasterView setImageList:@[info.image] imageDuration:0];
        [_videoPreview addSubview:pasterView];
        
        pasterInfo.pasterView = pasterView;
        pasterInfo.pasterInfoType = PasterInfoType_static;
        pasterInfo.image = info.image;
        pasterInfo.iconImage = info.iconImage;
        
        [self hiddeVideoPasterView];
        [self setVideoPasters:_videoPasterInfos];
        
        NSInteger index = [_videoPasterInfos indexOfObject:pasterInfo];
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_videoPasterCollection selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
}

- (void)onPasterViewTap
{
    _videoPasterView.hidden = NO;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)setProgressHidden:(BOOL)isHidden
{
    [_playBtn setImage:[UIImage imageNamed:@"videotext_play"] forState:UIControlStateNormal];
    
    if (isHidden) {
        //隐藏进度条时显示时间区域选择条
        _progressView.hidden = YES;
        _progressedLabel.hidden = YES;
        _videoRangeSlider.hidden = NO;
        _leftTimeLabel.hidden = NO;
        _rightTimeLabel.hidden = NO;
        [_ugcEditer pausePlay];
        _isVideoPlaying = NO;
        //[_ugcEditer previewAtTime:_videoRangeSlider.leftScale * (_videoDuration) + _videoStartTime];
        [_ugcEditer previewAtTime:_previewAtTime];
    } else {
        //显示进度条时隐藏时间区域选择条
        _progressView.hidden = NO;
        _progressedLabel.hidden = NO;
        _videoRangeSlider.hidden = YES;
        _leftTimeLabel.hidden = YES;
        _rightTimeLabel.hidden = YES;
        NSArray* indexPaths = [_videoPasterCollection indexPathsForSelectedItems];
        if (indexPaths.count > 0) {
            [_videoPasterCollection deselectItemAtIndexPath:indexPaths[0] animated:NO];
        }
        //不选中作何字幕
        [self showVideoPasterInfo:nil];
    }
}

//当前选中的动图信息
- (VideoPasterInfo*)getSelectedVideoTextInfo
{
    NSArray<NSIndexPath *> *indexPathsForSelectedItems =  [_videoPasterCollection indexPathsForSelectedItems];
    if (indexPathsForSelectedItems.count > 0) {
        NSIndexPath* selectedIndexPath = [_videoPasterCollection indexPathsForSelectedItems][0];
        if (selectedIndexPath.row < _videoPasterInfos.count) {
            return _videoPasterInfos[selectedIndexPath.row];
        }
    }
    return nil;
}

- (NSInteger) getSelectedVideoIndex
{
    NSArray<NSIndexPath *> *indexPathsForSelectedItems =  [_videoPasterCollection indexPathsForSelectedItems];
    if (indexPathsForSelectedItems.count > 0) {
        NSIndexPath* selectedIndexPath = [_videoPasterCollection indexPathsForSelectedItems][0];
        return selectedIndexPath.row;
    }
    return 0;
}

- (void)showVideoPasterInfo:(VideoPasterInfo*)pasterInfo
{
    NSMutableArray<VideoPasterInfo*>* videoPasterInfos = [NSMutableArray new];
    
    //除正在操作的贴纸外，其它贴纸在预览中生效
    for (VideoPasterInfo* info in _videoPasterInfos) {
        info.pasterView.hidden = YES;
        if (info != pasterInfo) {
            [videoPasterInfos addObject:info];
        }
    }
    
    if (!pasterInfo)
        return;
    
    //设置展示当前选中贴纸的时间信息
    pasterInfo.pasterView.hidden = NO;
    [_videoPreview addSubview:pasterInfo.pasterView];
    
    CGFloat leftX = MAX(0, (pasterInfo.startTime - _videoStartTime)) / (_videoDuration) * _videoRangeSlider.imageWidth;
    CGFloat rightX = MIN(_videoDuration, (pasterInfo.endTime - _videoStartTime)) / (_videoDuration) * _videoRangeSlider.imageWidth;
    _videoRangeSlider.leftPinCenterX = leftX + _videoRangeSlider.pinWidth / 2;
    _videoRangeSlider.rightPinCenterX = MAX(_videoRangeSlider.leftPinCenterX + _videoRangeSlider.pinWidth, rightX + _videoRangeSlider.pinWidth * 3 / 2);
    [_videoRangeSlider setNeedsLayout];
    
    _leftTimeLabel.frame = CGRectMake(_videoRangeSlider.x + _videoRangeSlider.leftPinCenterX - _videoRangeSlider.pinWidth / 2, _videoRangeSlider.top - 12, 30, 10);
    _leftTimeLabel.text = [NSString stringWithFormat:@"%.02f", _videoRangeSlider.leftScale *_videoDuration];
    
    _rightTimeLabel.frame = CGRectMake(_videoRangeSlider.x + _videoRangeSlider.rightPinCenterX - _videoRangeSlider.pinWidth / 2, _videoRangeSlider.top - 12, 30, 10);
    _rightTimeLabel.text = [NSString stringWithFormat:@"%.02f", _videoRangeSlider.rightScale *_videoDuration];
    
    _previewAtTime = pasterInfo.startTime;
    
    [self setVideoPasters:videoPasterInfos];
    [self setProgressHidden:YES];
    
}

//设置贴纸
- (void)setVideoPasters:(NSArray<VideoPasterInfo*>*)videoPasterInfos
{
    NSMutableArray* animatePasters = [NSMutableArray new];
    NSMutableArray* staticPasters = [NSMutableArray new];
    for (VideoPasterInfo* pasterInfo in videoPasterInfos) {
        if (pasterInfo.pasterInfoType == PasterInfoType_Animate) {
            TXAnimatedPaster* paster = [TXAnimatedPaster new];
            paster.startTime = pasterInfo.startTime;
            paster.endTime = pasterInfo.endTime;
            paster.frame = [pasterInfo.pasterView pasterFrameOnView:_videoPreview];
            paster.rotateAngle = pasterInfo.pasterView.rotateAngle * 180 / M_PI;
            paster.animatedPasterpath = pasterInfo.path;
            [animatePasters addObject:paster];
        }
        else if (pasterInfo.pasterInfoType == PasterInfoType_static){
            TXPaster *paster = [TXPaster new];
            paster.startTime = pasterInfo.startTime;
            paster.endTime = pasterInfo.endTime;
            paster.frame = [pasterInfo.pasterView pasterFrameOnView:_videoPreview];
            paster.pasterImage = pasterInfo.pasterView.staticImage;
            [staticPasters addObject:paster];
        }
    }
    [_ugcEditer setAnimatedPasterList:animatePasters];
    [_ugcEditer setPasterList:staticPasters];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _videoPasterInfos.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"PasterCollectionCell";
    PasterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (indexPath.row < _videoPasterInfos.count) {
        VideoPasterInfo* info = _videoPasterInfos[indexPath.row];
        cell.imageView.image = info.iconImage;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoPasterInfo* pasterInfo = [self getSelectedVideoTextInfo];
    if (_previewAtTime < pasterInfo.startTime || _previewAtTime > pasterInfo.endTime) {
        _previewAtTime = pasterInfo.startTime;
    }
    [self showVideoPasterInfo:pasterInfo];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40, 40);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (void)hiddeVideoPasterView
{
    NSMutableArray *emtyInfos = [NSMutableArray new];
    for (VideoPasterInfo *info in _videoPasterInfos) {
        if (info.pasterView.pasterImageView.image == nil && info.pasterView.pasterImageView.animationImages.count == 0) {
            [emtyInfos addObject:info];
        }
    }
    [_videoPasterInfos removeObjectsInArray:emtyInfos];
    [_videoPasterCollection reloadData];
    _videoPasterView.hidden = YES;
}

#pragma mark - UI event Handle
//播放，每次从头开始
- (void)onPlayBtnClicked:(UIButton*)sender
{
    [self setProgressHidden:NO];
    if (!_isVideoPlaying) {
        [self setVideoPasters:_videoPasterInfos];
        [_ugcEditer startPlayFromTime:_videoStartTime toTime:_videoEndTime];
        [_playBtn setImage:[UIImage imageNamed:@"videotext_stop"] forState:UIControlStateNormal];
        _isVideoPlaying = YES;
    }
    else{
        [_ugcEditer pausePlay];
        [_playBtn setImage:[UIImage imageNamed:@"videotext_play"] forState:UIControlStateNormal];
        _isVideoPlaying = NO;
        
        _previewAtTime = _progressView.value;
    }
    [self hiddeVideoPasterView];
}

//新添加动图
- (void)onNewPasterBtnClicked:(UIButton*)sender
{
    _videoPasterView.hidden = NO;
    [self setProgressHidden:YES];
    
    VideoPasterView * pasterView = [[VideoPasterView alloc] initWithFrame:CGRectZero];
    pasterView.delegate = self;
    [_videoPreview addSubview:pasterView];
    
    VideoPasterInfo* info = [VideoPasterInfo new];
    info.pasterView = pasterView;
    info.startTime = [self getStartTime];
    info.endTime = [self getEndTime:info.startTime];
    
    if (!_animateView.hidden) info.pasterInfoType = PasterInfoType_Animate;
    if (!_staticView.hidden) info.pasterInfoType = PasterInfoType_static;
    [_videoPasterInfos addObject:info];
    
    [_videoPasterCollection reloadData];
    [_videoPasterCollection performBatchUpdates:nil completion:^(BOOL finished) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:_videoPasterInfos.count - 1 inSection:0];
        [_videoPasterCollection selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }];
    
    _previewAtTime = info.startTime;
    [self showVideoPasterInfo:info];
}

- (float)getStartTime
{
    CGFloat time = 0;
    if (_videoPasterInfos.count > 0) {
        VideoPasterInfo * info = [_videoPasterInfos lastObject];
        time += info.endTime;
    }
    if (time == 0) {
        time += (_videoStartTime);
    }else{
        time += (_videoStartTime + 0.5);
    }
    if (time >= _videoEndTime) {
        time = 0;
    }
    return time;
}

- (float)getEndTime:(float)startTime
{
    CGFloat time = startTime + (_videoEndTime - _videoStartTime)  /  10;
    if (time >= _videoEndTime) {
        time = _videoEndTime;
    }
    return time;
}

//播放条拖动
- (void)onProgressSlided:(UISlider*)progressSlider
{
    _progressedLabel.x = _progressView.x + (progressSlider.value - _videoStartTime) / _videoDuration * (_progressView.width - _progressView.currentThumbImage.size.width);
    _progressedLabel.text = [NSString stringWithFormat:@"%.02f", progressSlider.value - _videoStartTime];
    [_ugcEditer previewAtTime:progressSlider.value];
    _previewAtTime = progressSlider.value;
}

//播放条拖动结束
- (void)onProgressSlideEnd:(UISlider*)progressSlider
{
    if (_isVideoPlaying){
        [_ugcEditer startPlayFromTime:progressSlider.value toTime:_videoEndTime];
    }
}

//返回
- (void)goBack
{
    [self hiddeVideoPasterView];
    [self showVideoPasterInfo:nil];
    [self setVideoPasters:_videoPasterInfos];
    [_videoPreview removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSetVideoPasterInfosFinish:)]) {
    [self.delegate onSetVideoPasterInfosFinish:_videoPasterInfos];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//点击选中贴纸
- (void)onTap:(UITapGestureRecognizer*)recognizer
{
    CGPoint tapPoint = [recognizer locationInView:recognizer.view];
    
    BOOL hasPaster = NO;
    for (NSInteger i = 0; i < _videoPasterInfos.count; i++) {
        CGRect pasterFrame = [_videoPasterInfos[i].pasterView pasterFrameOnView:recognizer.view];
        if (CGRectContainsPoint(pasterFrame, tapPoint)) {
            VideoPasterInfo *info = _videoPasterInfos[i];
            if (_previewAtTime >= info.startTime && _previewAtTime <= info.endTime) {
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [_videoPasterCollection selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
                [self showVideoPasterInfo:info];
                hasPaster = YES;
                break;
            }
        }
    }
    if (!hasPaster) {
        [self hiddeVideoPasterView];
    }
}

#pragma mark - VideoTextFieldDelegate

//删除在文字操作view
- (void)onRemovePasterView:(VideoPasterView*)pasterView;
{
    VideoPasterInfo* info = [self getSelectedVideoTextInfo];
    [_videoPasterInfos removeObject:info];
    [_videoPasterCollection reloadData];
    [self setVideoPasters:_videoPasterInfos];
    [self setProgressHidden:NO];
    [self hiddeVideoPasterView];
}

#pragma mark - RangeContentDelegate
- (void)onRangeLeftChanged:(RangeContent *)sender
{
    CGFloat textStartTime =  _videoStartTime + sender.leftScale * (_videoDuration);
    [_ugcEditer previewAtTime:textStartTime];
    _leftTimeLabel.frame = CGRectMake(_videoRangeSlider.x + _videoRangeSlider.leftPin.x, _videoRangeSlider.top - 12, 30, 10);
    _leftTimeLabel.text = [NSString stringWithFormat:@"%.02f", sender.leftScale * _videoDuration];
    _previewAtTime = textStartTime;
}

- (void)onRangeLeftChangeEnded:(RangeContent *)sender
{
    CGFloat pasterStartTime =  _videoStartTime + sender.leftScale * (_videoDuration);
    [_ugcEditer previewAtTime:pasterStartTime];
    VideoPasterInfo* pasterInfo = [self getSelectedVideoTextInfo];
    pasterInfo.startTime = pasterStartTime;
    _previewAtTime = pasterStartTime;
}

- (void)onRangeRightChanged:(RangeContent *)sender
{
    CGFloat textEndTime =  _videoStartTime+ sender.rightScale * (_videoDuration);
    [_ugcEditer previewAtTime:textEndTime];
    _rightTimeLabel.frame = CGRectMake(_videoRangeSlider.x + _videoRangeSlider.rightPin.x, _videoRangeSlider.top - 12, 30, 10);
    _rightTimeLabel.text = [NSString stringWithFormat:@"%.02f", sender.rightScale * _videoDuration];
    _previewAtTime = textEndTime;
}

- (void)onRangeRightChangeEnded:(RangeContent *)sender
{
    CGFloat pasterEndTime =  _videoStartTime+ sender.rightScale * (_videoDuration);
    [_ugcEditer previewAtTime:pasterEndTime];
    VideoPasterInfo* pasterInfo = [self getSelectedVideoTextInfo];
    pasterInfo.endTime = pasterEndTime;
    _previewAtTime = pasterEndTime;
}

#pragma mark - VideoPreviewDelegate
- (void)onVideoPlay
{
    [_ugcEditer startPlayFromTime:_videoStartTime toTime:_videoEndTime];
    [_playBtn setImage:[UIImage imageNamed:@"videotext_stop"] forState:UIControlStateNormal];
    _isVideoPlaying = YES;
    [self hiddeVideoPasterView];
}

- (void)onVideoPause
{
    [_ugcEditer pausePlay];
    [_playBtn setImage:[UIImage imageNamed:@"videotext_play"] forState:UIControlStateNormal];
    _isVideoPlaying = NO;
}

- (void)onVideoResume
{
    [_ugcEditer startPlayFromTime:_progressView.value toTime:_videoEndTime];
    _isVideoPlaying = YES;
    [self hiddeVideoPasterView];
}

- (void)onVideoPlayProgress:(CGFloat)time
{
    _progressView.value = time;
    _previewAtTime = time;
    _progressedLabel.text = [NSString stringWithFormat:@"%.02f", time - _videoStartTime];
    _progressedLabel.x = _progressView.x + (time - _videoStartTime) / _videoDuration * (_progressView.width - _progressView.currentThumbImage.size.width);
}

- (void)onVideoPlayFinished
{
    _isVideoPlaying = NO;
    [self onVideoPlay];
}

- (void)onVideoEnterBackground
{
    //进后台，暂停播放
    if (_isVideoPlaying) {
        [_ugcEditer pausePlay];
        [_playBtn setImage:[UIImage imageNamed:@"videotext_play"] forState:UIControlStateNormal];
        _isVideoPlaying = NO;
    }
}
@end
