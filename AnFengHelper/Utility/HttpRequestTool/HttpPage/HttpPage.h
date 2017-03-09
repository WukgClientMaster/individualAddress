//
//  HttpPage.h
//  TravelApp
//
//  Created by 吴可高 on 15/12/14.
//  Copyright (c) 2015年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum :NSInteger
{
    KPullUpRefreshType,
    KPullDownRefreshType,

}KPullRefreshType;

@interface HttpPage : NSObject

@property (nonatomic,assign) NSInteger pageCount; //  总的页数
@property (nonatomic,assign) NSInteger pageNo;   // 数据请求起始页
@property (nonatomic,assign) NSInteger pageSize; // 一次性数据请求的条数
@property (nonatomic,assign) NSInteger totalCount; // 总数据条目
@property (nonatomic,assign) KPullRefreshType refreshType;

+(instancetype) defaulePage;
-(NSDictionary*)pullDownRefresh;// 下拉
-(NSDictionary*)pullUpRefresh; //  上拉

@end
