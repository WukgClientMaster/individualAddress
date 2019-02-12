//
//  MusicCollectionViewObserver.m
//  SmartCity
//
//  Created by 吴可高 on 2018/1/18.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "MusicCollectionViewObserver.h"
#import "AllShowRequestManager.h"
#import "Request_dazzle_findAudioType.h"
#import "MusicRequestTool.h"
//
#import "SegmentSelectedModel.h"
#import "HttpPage.h"
#import "MusicOptionalModel.h"
#import "MusicPauseOrPlayOptModel.h"
#import "BaseTableView.h"
#import "QMX_MusicTool.h"
#import "MusicCollectionViewCell.h"
#import "QMX_VideoMusicEditCell.h"

static NSString * HuntALLMusicViwController = @"HCY_SelectMusicViewController";
static NSString * SearchMusicViwController  = @"HCY_SearchMusicViewController";

NSString * HOST_REQUEST();
NSString * HOST_REQUEST(){
    return HOSTPATH();
}

static MusicCollectionViewObserver * _collectionObserver = nil;
@interface MusicCollectionViewObserver()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic,strong) Request_dazzle_findAudioType * findAudioArgs;
@property(nonatomic,strong) Request_dazzle_findAudioFile * findFile;
@property(nonatomic,strong) HttpPage * page;
@property(nonatomic,strong) HttpPage * searchMusicPage;

@property(nonatomic,strong) NSMutableDictionary * httpDictionary;
@property(nonatomic,strong) NSMutableArray * catgorys;
@property (copy, nonatomic) SearchErrorComplete  error;
@property (copy, nonatomic) SearchDataComplete  success;
@property (copy, nonatomic) NSString * previousIndexFormat;

@end

@implementation MusicCollectionViewObserver
-(NSMutableDictionary *)cacheMutableDictionary{
    _cacheMutableDictionary = ({
        if (_cacheMutableDictionary == nil){
            _cacheMutableDictionary = [NSMutableDictionary dictionary];
        }
        _cacheMutableDictionary;
    });
    return _cacheMutableDictionary;
}

-(NSMutableArray *)catgorys{
    _catgorys = ({
        if (!_catgorys) {
            _catgorys = [NSMutableArray array];
        }
        _catgorys;
    });
    return _catgorys;
}

-(NSMutableDictionary *)httpDictionary{
    _httpDictionary = ({
        if (!_httpDictionary) {
            _httpDictionary = [NSMutableDictionary dictionary];
        }
        _httpDictionary;
    });
    return _httpDictionary;
}

-(Request_dazzle_findAudioFile *)findFile{
    _findFile = ({
        if (!_findFile) {
            _findFile = [[Request_dazzle_findAudioFile alloc]init];
        }
        _findFile;
    });
    return _findFile;
}

-(Request_dazzle_findAudioType *)findAudioArgs{
    _findAudioArgs = ({
        if (!_findAudioArgs) {
            _findAudioArgs = [Request_dazzle_findAudioType new];
        }
        _findAudioArgs;
    });
    return _findAudioArgs;
}
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    if (_collectionObserver == nil) {
        dispatch_once(&onceToken, ^{
            if (!_collectionObserver) {
                _collectionObserver = [[MusicCollectionViewObserver alloc]init];
            }
        });
    }
    return _collectionObserver;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = [HttpPage defaulePage];
        _searchMusicPage = [HttpPage defaulePage];
        
    }
    return self;
}
//音乐独占模式
-(void)musicSoloCatgoryMonopolize{
    [[self.collectionContainerView.collectionView visibleCells]enumerateObjectsUsingBlock:^(__kindof MusicCollectionViewCell * _Nonnull musicCell, NSUInteger idx, BOOL * _Nonnull stop) {
        for (int i = 0; i  < [musicCell.contentView subviews].count; i++) {
            UIView * contentView = [musicCell.contentView subviews][i];
            if ([contentView isKindOfClass:[BaseTableView class]]) {
                BaseTableView * tableView = (BaseTableView*)contentView;
                NSArray <QMX_VideoMusicEditCell *>* visibleCells = [tableView visibleCells];
                [visibleCells enumerateObjectsUsingBlock:^(QMX_VideoMusicEditCell  * musicCell, NSUInteger idx, BOOL * _Nonnull stop) {
                    [musicCell.player stop];
                    [musicCell.play_Item_Btn setSelected:NO];
                }];
            }
        }
    }];
}

- (void)dealloc
{
    [self.collectionContainerView removeObserver:self forKeyPath:@"visibleCurrentIndex"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == nil) {
        [[QMX_MusicTool shareInstance]deletePreloadingDataIndexParams];
        if ([self.previousIndexFormat isEqualToString:self.collectionContainerView.visibleCurrentIndex]) {
            return;
        }
        //是否包含
        if ([[self.cacheMutableDictionary allKeys]containsObject:self.collectionContainerView.visibleCurrentIndex]) {
            self.collectionContainerView.cacheDataDictionary = self.cacheMutableDictionary;
            self.previousIndexFormat = self.collectionContainerView.visibleCurrentIndex;
        }else{
            //不包含请求数据
            NSInteger idx = [self.collectionContainerView.visibleCurrentIndex integerValue];
            SegmentSelectedModel * model = self.segmentView.segments[idx];
            NSString * key = [NSString stringWithFormat:@"%zd",idx];
            HttpPage * page = self.httpDictionary[key];
            page.refreshType = KPullDownRefreshType;
            self.findFile.type = model.catgoryID;
            self.findFile.page = [@(page.page)stringValue];
            self.findFile.row  = [@(page.row)stringValue];
            self.findFile.name = @"";
            self.page = page;
            [self musicQueryItemsForCatgoryType:self.findFile httppage:page type:self.collectionContainerView.visibleCurrentIndex];
            self.previousIndexFormat = self.collectionContainerView.visibleCurrentIndex;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)musicCatgoryAsynReques;
{
    //删除之前的缓存
    [self.collectionContainerView.cacheDataDictionary removeAllObjects];
    __weak typeof(self)weakSelf =  self;
    [MusicRequestTool musicAsynRequestWithModel:self.findAudioArgs WithUrlSring:HOST isShowLoading:YES success:^(id response) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        id target = ooDetailRecursionAboutJson(response);
        NSArray * results = [SegmentSelectedModel mj_objectArrayWithKeyValuesArray:target[@"data"][@"findMusicType"]];
        __block NSArray * normal
        = @[[UIColor whiteColor]];
        __block  NSArray * selected
        = @[UIColorFromRGB(0x09ebcf)];
        [results enumerateObjectsUsingBlock:^(SegmentSelectedModel*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setSelected:(idx == 0) ? YES: NO];
            [obj setSelectedStateColor:selected[0]];
            [obj setNormalStateColor:normal[0]];
        }];
        [strongSelf.catgorys addObjectsFromArray:results];
        [strongSelf allocatedHttpPage:results];
        strongSelf.segmentView.segments = results;
        strongSelf.collectionContainerView.segments = results;
        [strongSelf observerRefreshHeaderWithTable:strongSelf.visibleRefreshTableView];
    } failure:^(NSError *error) {
    } error:^(NSString *message) {
    }];
}

-(void)allocatedHttpPage:(NSArray*)segments{
    if (self.httpDictionary == nil)return;
    if (segments.count ==0 || segments == nil)return;
    for (int idx =0; idx < segments.count; idx++) {
        HttpPage * page = [HttpPage defaulePage];
        NSString * key  = [NSString stringWithFormat:@"%zd",idx];
        [self.httpDictionary setObject:page forKey:key];
        self.page = (idx ==0) ? page : nil;
    }
}
//音乐列表下拉刷新
-(void)observerRefreshHeaderWithTable:(BaseTableView*)tableView{
    NSString * type = self.collectionContainerView.visibleCurrentIndex;
    if ([NSStringFromClass(self.owerClass)isEqualToString:SearchMusicViwController]) {
        [tableView.mj_header endRefreshing];
        return;
    }
    if ([[self.httpDictionary allKeys]containsObject:type]) {
        self.visibleRefreshTableView = tableView;
        [self.visibleRefreshTableView.mj_header endRefreshing];
        [self.visibleRefreshTableView.mj_footer endRefreshing];
        NSInteger idx = [type integerValue];
        //默认选中第一个分类时候
        HttpPage * page = self.httpDictionary[type];
        page.page = 0;
        page.refreshType = KPullDownRefreshType;
        self.page = page;
        SegmentSelectedModel * selectedSegmentModel = self.catgorys[idx];
        self.findFile.type = selectedSegmentModel.catgoryID;
        self.findFile.page = [@(page.page)stringValue];
        self.findFile.row = [@(page.row)stringValue];
        self.findFile.name = @"";
        //删除预加载索引
        [[QMX_MusicTool shareInstance]deletePreloadingDataIndexParams];
        [self musicQueryItemsForCatgoryType:self.findFile httppage:page type:type];
    }
}
//音乐列表上拉刷新
-(void)observerRefreshFooterWithTable:(BaseTableView*)tableView{
    NSString * type = self.collectionContainerView.visibleCurrentIndex;
    if ([NSStringFromClass(self.owerClass)isEqualToString:SearchMusicViwController]) {
        type = @"1000";
    }
    if ([[self.httpDictionary allKeys]containsObject:type]) {
        self.visibleRefreshTableView = tableView;
        NSInteger idx = [type integerValue];
        //默认选中第一个分类时候
        HttpPage * page = self.httpDictionary[type];
        page.refreshType = KPullUpRefreshType;
        [self.page pullUpRefresh];
        page.page = self.page.page;
        self.page = page;
        if ([NSStringFromClass(self.owerClass) isEqualToString:SearchMusicViwController]) {
            self.findFile.type = @"";
        }else{
            SegmentSelectedModel * selectedSegmentModel = self.catgorys[idx];
            self.findFile.type = selectedSegmentModel.catgoryID;
            self.findFile.name = @"";
        }
        self.findFile.page = [@(page.page)stringValue];
        self.findFile.row = [@(page.row)stringValue];
        [self musicQueryItemsForCatgoryType:self.findFile httppage:page type:type];
    }else{
        self.visibleRefreshTableView = tableView;
        //默认选中第一个分类时候
        self.searchMusicPage.refreshType = KPullUpRefreshType;
        self.searchMusicPage.page = [[self.searchMusicPage pullUpRefresh][@"page"]integerValue];
        self.findFile.type = @"";
        self.findFile.page = [@(self.searchMusicPage.page)stringValue];
        self.findFile.row = [@(self.searchMusicPage.row)stringValue];
        [self musicQueryItemsForCatgoryType:self.findFile httppage:self.searchMusicPage type:type];
    }
}
//音乐检索功能
-(void)musicSearchFunctionWithName:(NSString*)name searchData:(SearchDataComplete)searchSuccess error:(SearchErrorComplete)searchError{
    //分页操作并且初始化一个HTTPPage
    self.success = searchSuccess;
    self.error = searchError;
    self.searchMusicPage.refreshType = KPullDownRefreshType;
    self.searchMusicPage.page = 0;
    self.findFile.type = @"";
    self.findFile.name = name;
    self.findFile.page = [@(self.searchMusicPage.page)stringValue];
    self.findFile.row =  [@(self.searchMusicPage.row)stringValue];
    self.page = self.searchMusicPage;
    [self musicQueryItemsForCatgoryType:self.findFile httppage:self.searchMusicPage type:@"1000"];
}

-(void)musicQueryItemsForCatgoryType:(Request_dazzle_findAudioFile*)args httppage:(HttpPage*)page  type:(NSString*)type;
{
    //刷新数据操作时候要判断
    //self.visibleRefreshTableView 是否为空
    __weak  typeof(self)weakSelf = self;
    __block NSMutableDictionary * mutableDictionary = self.cacheMutableDictionary;
    [MusicRequestTool musicAsynRequestWithModel:args WithUrlSring:HOST isShowLoading:YES success:^(id response) {
        __strong  typeof(weakSelf)strongSelf = weakSelf;
        page.totalCount = [response[@"total"]integerValue];
        strongSelf.page.totalCount = [response[@"total"]integerValue];
        strongSelf.searchMusicPage.totalCount = [response[@"total"]integerValue];
        id target = ooDetailRecursionAboutJson(response);
        NSArray* results = [MusicOptionalModel mj_objectArrayWithKeyValuesArray:target[@"data"][@"findMusic"]];
        if ([NSStringFromClass(strongSelf.owerClass) isEqualToString:@"HCY_SelectMusicViewController"]){
            [strongSelf requestDataSuccess:results mutable:mutableDictionary type:type page:strongSelf.page];
        }else{
            [results enumerateObjectsUsingBlock:^(MusicOptionalModel * optional , NSUInteger idx, BOOL * _Nonnull stop) {
                MusicPauseOrPlayOptModel *pasueOrPlayModel = [[MusicPauseOrPlayOptModel alloc]init];
                pasueOrPlayModel.pause =  YES;// 每次请求完成或者切换音乐时候都是暂停状态
                pasueOrPlayModel.playCount = 0;
                pasueOrPlayModel.userEditMusicCount = 0;
                optional.pauseOrPlayModel = pasueOrPlayModel;
                [optional setDidSelected:NO];
            }];
            //上拉刷新
            if (page.refreshType == KPullUpRefreshType) {
                if (results.count < page.row) {
                    [self.visibleRefreshTableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.visibleRefreshTableView.mj_footer endRefreshing];
                }
            }
            strongSelf.success(strongSelf.page,results);
        }
    } failure:^(NSError *error) {
        __strong  typeof(weakSelf)strongSelf = weakSelf;
        if ([NSStringFromClass(strongSelf.owerClass) isEqualToString:@"HCY_SelectMusicViewController"]) {
            [strongSelf requestDataError:nil mutable:mutableDictionary type:type];
        }else{
            strongSelf.error(error);
        }
    } error:^(NSString *message) {
        __strong  typeof(weakSelf)strongSelf = weakSelf;
        if ([NSStringFromClass(strongSelf.owerClass) isEqualToString:@"HCY_SelectMusicViewController"]) {
            [strongSelf requestDataError:nil mutable:mutableDictionary type:type];
        }
        else{
            strongSelf.error(nil);
        }
    }];
}

-(void)requestDataSuccess:(NSArray*)results mutable:(NSMutableDictionary*)mutableDictionary type:(NSString*)type page:(HttpPage*)page{
    if (mutableDictionary == nil)
        mutableDictionary = [NSMutableDictionary dictionary];
    //如果包含关键字key 并且刷新方式为：上拉刷新
    if ([[mutableDictionary allKeys]containsObject:type] && page.refreshType == KPullUpRefreshType) {
        NSMutableArray * values = mutableDictionary[type];
        NSMutableArray * final_result = [NSMutableArray arrayWithArray:values];
        [final_result addObjectsFromArray:results];
        [mutableDictionary setObject:final_result forKey:type];
    }
    //如果包含关键字key 并且刷新方式为：下拉刷新
    else if([[mutableDictionary allKeys]containsObject:type] && page.refreshType == KPullDownRefreshType){
        NSMutableArray * values = [mutableDictionary[type] mutableCopy];
        [values removeAllObjects];
        [values addObjectsFromArray:results];
        [mutableDictionary setObject:values forKey:type];
        [self.visibleRefreshTableView.mj_header endRefreshing];
    }else if (![[mutableDictionary allKeys]containsObject:type]&&page.refreshType == KPullDownRefreshType){
        //当不包含当前关键字时候，一定时下拉刷新
        [mutableDictionary setObject:results forKey:type];
        [self.visibleRefreshTableView.mj_header endRefreshing];
    }
    if (results.count < self.page.row) {
        [self.visibleRefreshTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.visibleRefreshTableView.mj_footer endRefreshing];
    }
    self.collectionContainerView.cacheDataDictionary = mutableDictionary;
}

-(void)requestDataError:(NSError * )error mutable:(NSMutableDictionary*)mutableDictionary type:(NSString*)type{
    [mutableDictionary setObject:@[] forKey:type];
    self.collectionContainerView.cacheDataDictionary = mutableDictionary;
    [self.visibleRefreshTableView.mj_header endRefreshing];
    [self.visibleRefreshTableView.mj_footer endRefreshing];
}


static id ooDetailRecursionAboutJson(id object);
static id ooDetailRecursionAboutJson(id object)
{
    // 判断json数据返回的是什么类型： NSString ｜ NSArray ｜ NSDictionary
    // 判断json数据的类型是NSString时：
    id filterNullContrainerObject;
    if (![object isKindOfClass:[NSArray class]]
        &&![object isKindOfClass:[NSDictionary class]])
    {
        id  result = object;
        if ([result isKindOfClass:[NSNull class]])
        {
            result = @"";
        }
        else if ([result isKindOfClass:[NSString class]]
                 &&(!result||[result isEqualToString:@""]))
        {
            result = @"";
        }
        filterNullContrainerObject  = (NSString*)result;
    }
    // 判断json数据的类型是NSArray时：
    else if ([object isKindOfClass:[NSArray class]])
    {
        NSArray * sourceArray =(NSArray*)object;
        if (sourceArray.count ==0 || !sourceArray)
        {
            filterNullContrainerObject = @[];
        }
        NSMutableArray *filterArray  = [NSMutableArray array];
        [sourceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             NSString * filter = ooDetailRecursionAboutJson(obj);
             [filterArray addObject:filter];
         }];
        filterNullContrainerObject  = filterArray;
    }
    // 判断json数据的类型是NSDictionary时：
    else if ([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *sourceDictionary = (NSDictionary*)object;
        NSMutableDictionary *sourcefilterDictionary = [NSMutableDictionary dictionary];
        if (!sourceDictionary || sourceDictionary.count ==0)
        {
            filterNullContrainerObject = @{};
        }
        [sourceDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop)
         {
             id object = ooDetailRecursionAboutJson(obj);
             [sourcefilterDictionary setValue:object forKey:key];
         }];
        filterNullContrainerObject  = sourcefilterDictionary;
    }
    return filterNullContrainerObject;
}
@end

