//
//  MusicCollectionViewCell.m
//  SmartCity
//
//  Created by 吴可高 on 2018/1/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "MusicCollectionViewCell.h"
#import "MusicCollectionViewObserver.h"
#import "BaseTableView.h"
#import "MusicPauseOrPlayOptModel.h"
#import "MusicOptionalModel.h"
#import "DazzleRefreshHeader.h"
#import "DazzleRefreshFooter.h"

#import "QMX_VideoMusicEditCell.h"
#import "VideoClipsTool.h"

static NSString *const MusicCellIdentifier = @"kQMX_VideoMusicEditCell";

@interface MusicCollectionViewCell()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property(nonatomic,strong,readwrite) BaseTableView * tableView;
@property(nonatomic,strong) MusicPauseOrPlayOptModel * pauseOrPlayModel;
@property(nonatomic,strong) MusicCollectionViewObserver * musicCollectionObserver;
//主要辨别是用户点击的播放或者暂停按钮 --根据状态来是否刷新Cell的那些控件
@property (copy, nonatomic) NSString * conditionOptionString;
@property (strong, nonatomic) MusicOptionalModel *optionMusicModel;
@property (strong, nonatomic) MusicOptionalModel *previousDidSelectedOptionalModel;
@end
@implementation MusicCollectionViewCell

#pragma mark initialize
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
        [self autoRequestData];
    }
    return self;
}

-(void)autoRequestData{
    if ([NSStringFromClass(self.musicCollectionObserver.owerClass) isEqualToString:@"HCY_SelectMusicViewController"]) {
        self.musicCollectionObserver.visibleRefreshTableView = self.tableView;
    }
}

-(void)setUp{
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.tableView removeFromSuperview];
    [self.contentView addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoRotationSucceedCallback:) name:DazzleVideoRotateSucceedNotification object:nil];
    __weak  typeof(self)weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.contentView).insets(UIEdgeInsetsZero);
        
    }];
    //初始化音乐类型时添加刷新操作
    //搜索音乐时应该是有音乐结果才添加刷新控件
    if ([NSStringFromClass(self.musicCollectionObserver.owerClass) isEqualToString:@"HCY_SelectMusicViewController"]) {
        [self.tableView.mj_footer setAutomaticallyHidden:YES];
        //        self.tableView.mj_header = [DazzleRefreshHeader headerWithRefreshingBlock:^{
        //            __strong  typeof(weakSelf)strongSelf = weakSelf;
        //            [strongSelf.musicCollectionObserver observerRefreshHeaderWithTable:strongSelf.tableView];
        //        }];
        //        self.tableView.mj_footer = [DazzleRefreshFooter footerWithRefreshingBlock:^{
        //            __strong  typeof(weakSelf)strongSelf = weakSelf;
        //            [strongSelf.musicCollectionObserver observerRefreshFooterWithTable:strongSelf.tableView];
        //        }];
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong  typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.musicCollectionObserver observerRefreshHeaderWithTable:strongSelf.tableView];
        }];
        
        self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            __strong  typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.musicCollectionObserver observerRefreshFooterWithTable:strongSelf.tableView];
        }];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DazzleVideoRotateSucceedNotification object:nil];
    
}
#pragma mark - UIScrollView EmptyData Delegate
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    return [[NSAttributedString alloc]initWithString:@"当前分类数据为空"];
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (BOOL)emptyDataSetShouldFadeIn:(UIScrollView *)scrollView{
    return YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark -getter method
-(MusicCollectionViewObserver *)musicCollectionObserver{
    _musicCollectionObserver = ({
        if (!_musicCollectionObserver) {
            _musicCollectionObserver = [MusicCollectionViewObserver shareInstance];
        }
        _musicCollectionObserver;
    });
    return _musicCollectionObserver;
}

#pragma mark -setter methods
-(void)setItems:(NSMutableArray *)items{
    _items = items;
    if (_items.count == 0){return;}
    if ([NSStringFromClass(self.musicCollectionObserver.owerClass) isEqualToString:@"HCY_SearchMusicViewController"]) {
        __weak  typeof(self)weakSelf = self;
        [self.tableView.mj_footer setAutomaticallyHidden:YES];
        //        self.tableView.mj_header = [DazzleRefreshHeader headerWithRefreshingBlock:^{
        //            __strong  typeof(weakSelf)strongSelf = weakSelf;
        //            [strongSelf.musicCollectionObserver observerRefreshHeaderWithTable:strongSelf.tableView];
        //        }];
        //        self.tableView.mj_footer = [DazzleRefreshFooter footerWithRefreshingBlock:^{
        //            __strong  typeof(weakSelf)strongSelf = weakSelf;
        //            [strongSelf.musicCollectionObserver observerRefreshFooterWithTable:strongSelf.tableView];
        //        }];
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong  typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.musicCollectionObserver observerRefreshHeaderWithTable:strongSelf.tableView];
        }];
        
        self.tableView.mj_footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            __strong  typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf.musicCollectionObserver observerRefreshFooterWithTable:strongSelf.tableView];
        }];
    }
    [_items enumerateObjectsUsingBlock:^(MusicOptionalModel *  optional, NSUInteger idx, BOOL * _Nonnull stop) {
        MusicPauseOrPlayOptModel *pasueOrPlayModel = [[MusicPauseOrPlayOptModel alloc]init];
        pasueOrPlayModel.pause =  YES;// 每次请求完成或者切换音乐时候都是暂停状态
        pasueOrPlayModel.playCount = 0;
        pasueOrPlayModel.userEditMusicCount = 0;
        optional.pauseOrPlayModel = pasueOrPlayModel;
        [optional setDidSelected:NO];
    }];
    self.conditionOptionString = @"NO";
    [self.tableView reloadData];
}

- (BaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        if (@available(ios 11.0,*)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = [Tools colorWithHexString:@"262939"];
        _tableView.backgroundColor = [Tools colorWithHexString:@"191b2a"];
        
        [_tableView registerClass:[QMX_VideoMusicEditCell class] forCellReuseIdentifier:MusicCellIdentifier];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QMX_VideoMusicEditCell * cell = [QMX_VideoMusicEditCell musicEditCellWithTableView:tableView];
    cell.musicIndexPath = indexPath;
    cell.items = self.items;
    cell.optionModel = self.items[indexPath.row];
    __weak  typeof(self)weakSelf = self;
    __weak  typeof(cell)weakCell = cell;
    cell.blockCallBack = ^(MusicOptionalModel * optionalModel){
        __block NSMutableArray * reloadsIndexs = [NSMutableArray arrayWithCapacity:2];
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.musicCollectionObserver musicSoloCatgoryMonopolize];
        //保证记录最新和上一次操作的记录
        if (strongSelf.previousDidSelectedOptionalModel == nil) {
            NSInteger currentIndx = [strongSelf.items indexOfObject:optionalModel];
            NSIndexPath * cur_indexpath = [NSIndexPath indexPathForRow:currentIndx inSection:0];
            [reloadsIndexs addObject:cur_indexpath];
        }else if (![strongSelf.previousDidSelectedOptionalModel isEqual:optionalModel]) {
            NSInteger preIndex = [strongSelf.items indexOfObject:strongSelf.previousDidSelectedOptionalModel];
            NSIndexPath * pre_indexpath = [NSIndexPath indexPathForRow:preIndex inSection:0];
            [reloadsIndexs addObject:pre_indexpath];
            NSInteger currentIndx = [strongSelf.items indexOfObject:optionalModel];
            NSIndexPath * cur_indexpath = [NSIndexPath indexPathForRow:currentIndx inSection:0];
            [reloadsIndexs addObject:cur_indexpath];
        }else{
            NSInteger currentIndx = [strongSelf.items indexOfObject:optionalModel];
            NSIndexPath * cur_indexpath = [NSIndexPath indexPathForRow:currentIndx inSection:0];
            [reloadsIndexs addObject:cur_indexpath];
        }
        strongSelf.previousDidSelectedOptionalModel = optionalModel;
        strongSelf.conditionOptionString = @"YES";
        [strongSelf.items enumerateObjectsUsingBlock:^(MusicOptionalModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![optionalModel isEqual:obj]) {
                [obj setDidSelected:NO];
                [obj.pauseOrPlayModel setPause:YES];
                //之前用户编辑音乐还原
                obj.pauseOrPlayModel.userEditMusicCount = 0;
            }
        }];
        dispatch_barrier_async(dispatch_get_main_queue(), ^{
            [strongSelf.tableView reloadRowsAtIndexPaths:reloadsIndexs withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    };
    cell.musicTrimBlock = ^(KSYMEEditTrimType type, CMTimeRange range, MusicOptionalModel *model, KSYEditDragView oritentation){
        __strong  typeof(weakSelf)strongSelf = weakSelf;
        CMTime start = range.start;
        CMTime end = range.duration;
        NSTimeInterval startInterval = start.value / start.timescale;
        NSTimeInterval endTnterval = end.value / end.timescale + startInterval;
        model.pauseOrPlayModel.endTime = endTnterval;
        model.pauseOrPlayModel.startTime = startInterval;
        model.pauseOrPlayModel.userEditMusicCount +=1;
        strongSelf.pauseOrPlayModel.startTime = startInterval;
        [weakCell musicSeekToTimeIntervalstartInterval:startInterval endInterval:endTnterval option:model draggerView:oritentation];
        model.pauseOrPlayModel.selMusicRange = CMTimeRangeMake(range.start, range.duration);
    };
    cell.MusicTurnCatBlock = ^(MusicOptionalModel * optionalModel){
        __strong  typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.optionMusicModel = optionalModel;
        [[VideoClipsTool shareInstance]clipsAudioWithResuores:optionalModel.pauseOrPlayModel.cachePath timeRange:optionalModel.pauseOrPlayModel.selMusicRange duration:optionalModel.pauseOrPlayModel.duration export:nil];
    };
    return cell;
    
}

-(void)videoRotationSucceedCallback:(NSNotification*)notification{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary * param = (NSDictionary*)object;
        NSString * type = param[@"type"];
        NSString * videoUrlString =param[@"url"];
        self.optionMusicModel.pauseOrPlayModel.clipsAudioPath = videoUrlString;
        if ([type isEqualToString:@"audioClips"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:DazzleTruncatMusicNotification object:self.optionMusicModel];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicOptionalModel * model = self.items[indexPath.row];
    return  model.isDidSelected ? (85+90) : 90;
}

@end


