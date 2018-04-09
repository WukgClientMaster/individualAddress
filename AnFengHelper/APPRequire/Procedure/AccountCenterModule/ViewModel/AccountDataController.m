//
//  AccountDataController.m
//  AnFengHelper
//
//  Created by 吴可高 on 2018/4/7.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "AccountDataController.h"
#import "AccountModel.h"

static AccountDataController * _dataController = nil;
@interface AccountDataController()
@property(nonatomic,strong) NSMutableArray * results;
@end
@implementation AccountDataController

+(instancetype)shareInstance{
    if (_dataController == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _dataController = [[AccountDataController alloc]init];
        });
    }
    return _dataController;
}

-(NSMutableArray *)results{
    _results = ({
        if (!_results) {
            _results  = [NSMutableArray array];
        }
        _results;
    });
    return _results;
}

-(void)queryAccountlistsData:(void(^)(id respnse,BOOL status))block{
    NSArray * labels = @[@" 可订明日 ",@" 主题乐园 ",@" 农家乐 ",@" 自然风光 ",@" 城市风光 ",@" 情侣约会 ",@" 赏花踏青 "];
    NSArray * descs = @[@"武汉欢乐谷",@"武汉海昌极地海洋世界",@"武汉两江游览",@"武汉杜莎夫人蜡像馆",@"武汉植物园",@"东湖樱花园",@"武汉园博园"];
    
#define AROUND_IMGURL_ONE @"http://pic158.nipic.com/file/20180319/24118152_102226004000_2.jpg"
#define AROUND_IMGURL_TWO @"http://pic7.huitu.com/res/20130223/178541_20130223221713685200_1.jpg"
#define AROUND_IMGURL_THREE @"http://pic151.nipic.com/file/20171219/22439450_193616352000_2.jpg"
    NSArray *  avatars =@[AROUND_IMGURL_ONE,AROUND_IMGURL_TWO,AROUND_IMGURL_THREE];
    for (int i = 0; i < 30; i++) {
        NSInteger idx = i % [descs count];
        NSString * price = [NSString stringWithFormat:@" ¥%zd元 ",arc4random()%1000];
        NSString * grade = [NSString stringWithFormat:@" %d分 ",arc4random()%10];
        NSString * soldOut = [NSString stringWithFormat:@" 已售%d份 ",arc4random()%100];
        NSString * reduce =  (i %3 == 0) ? @"YES":@"NO";
        NSString * free =  (i %5 == 1) ? @"YES":@"NO";
        NSInteger lb_idx = i % ([labels count]-1);
        NSArray * labs = (i %3 == 0) ? @[] : [labels subarrayWithRange:NSMakeRange(lb_idx, [labels count] - lb_idx)];
        NSInteger  index = i % 3;
        NSString * avatar= avatars[index];
        AccountModel * model = [AccountModel accountWithavatar:avatar desc:descs[idx] price:price grade:grade soldOut:soldOut labels:labs reduce:reduce freeAdmiss:free];
        [self.results addObject:model];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (block) {
            block(self.results,YES);
        }
    });
}

@end
