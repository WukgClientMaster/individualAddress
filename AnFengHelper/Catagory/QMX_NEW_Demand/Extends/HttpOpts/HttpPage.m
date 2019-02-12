//
//  HttpPage.m
//  TravelApp
//
//  Created by 吴可高 on 15/12/14.
//  Copyright (c) 2015年 吴可高. All rights reserved.
//

#import "HttpPage.h"
HttpPage * _httpPage = nil;
@interface HttpPage()
{
}
@end

@implementation HttpPage

+(instancetype)defaulePage;
{
    _httpPage  = [[HttpPage alloc]init];
    return  _httpPage;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.page  = 0;
        self.row   = 20;
    }
    return self;
}
-(void)autoRefreshConfigData{
    self.page = 1;
    self.row  = 20;
}
//起始页:1
-(NSDictionary*)pullDownAutoRefresh{
    self.page = 1;
    return @{@"page":@(self.page),@"row":@(self.row)};
}

-(NSDictionary*)pullDownRefresh{
    self.page = 0;
    return @{@"page":@(self.page),@"row":@(self.row)};
}

-(NSDictionary*)pullUpRefresh{
    return @{@"page":@(++self.page),@"row":@(self.row)};
}

@end
