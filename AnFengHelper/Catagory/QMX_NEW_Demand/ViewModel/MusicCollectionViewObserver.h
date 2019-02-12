//
//  MusicCollectionViewObserver.h
//  SmartCity
//
//  Created by 吴可高 on 2018/1/18.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicSegmentView.h"
#import "MusicCollectContainerView.h"
@class BaseTableView;
@class Request_dazzle_findAudioFile;
@class HttpPage;

typedef void (^SearchDataComplete)(HttpPage * page, NSArray * items);
typedef void (^SearchErrorComplete)(NSError * error);

@interface MusicCollectionViewObserver : NSObject

@property(nonatomic,strong) MusicSegmentView * segmentView;
@property(nonatomic,strong) MusicCollectContainerView * collectionContainerView;
@property (strong, nonatomic) NSMutableDictionary * cacheMutableDictionary;//  数据分类缓存数据
@property(nonatomic,strong) BaseTableView * visibleRefreshTableView;
@property(nonatomic,assign) Class owerClass;
+(instancetype)shareInstance;
-(void)musicCatgoryAsynReques;
-(void)musicQueryItemsForCatgoryType:(Request_dazzle_findAudioFile*)args httppage:(HttpPage*)page type:(NSString*)type;

-(void)observerRefreshHeaderWithTable:(BaseTableView*)tableView;
-(void)observerRefreshFooterWithTable:(BaseTableView*)tableView;
//音乐检索功能
-(void)musicSearchFunctionWithName:(NSString*)name searchData:(SearchDataComplete)success error:(SearchErrorComplete)error;
//音乐独占模式
-(void)musicSoloCatgoryMonopolize;
@end

