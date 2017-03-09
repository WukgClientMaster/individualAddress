//
//  HttpPage.m
//  TravelApp
//
//  Created by 吴可高 on 15/12/14.
//  Copyright (c) 2015年 吴可高. All rights reserved.
//

#import "HttpPage.h"
static  HttpPage * httpPage = nil;
static  dispatch_once_t once;
@interface HttpPage()
{
}
@end

@implementation HttpPage

+(instancetype)defaulePage;
{
    dispatch_once(&once, ^{
        if (!httpPage) {
            httpPage  = [[HttpPage alloc]init];
        }
    });
    return  httpPage;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.pageNo = 1;
        self.pageSize = 20;
    }
    return self;
}

-(NSDictionary*)pullDownRefresh;// 下拉
{
    return @{@"pageNo":@(1),@"pageSize":@(self.pageSize)};
}

-(NSDictionary*)pullUpRefresh; //  上拉
{
    if (self.pageNo >= _pageCount)
    {
        return nil;
    }
    return @{@"pageNo":@(self.pageNo +1),@"pageSize":@(self.pageSize)};
}
@end
