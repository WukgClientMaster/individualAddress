//
//  AccountViewModel.m
//  AnFengHelper
//
//  Created by 吴可高 on 2018/4/7.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "AccountViewModel.h"
#import "CellViewModel.h"
#import "AccountModel.h"

static AccountViewModel * _viewModel = nil;
@interface AccountViewModel()
@property(nonatomic,strong) NSMutableArray * results;
@end

@implementation AccountViewModel

-(NSMutableArray *)results{
    _results = ({
        if (!_results) {
            _results  = [NSMutableArray array];
        }
        _results;
    });
    return _results;
}
+(instancetype)shareInstance{
    if (_viewModel == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _viewModel = [[AccountViewModel alloc]init];
        });
    }
    return _viewModel;
}

-(void)startViewModelSerialize:(NSMutableArray*)items serializeCallback:(void(^)(id respnse,BOOL status))block{
    for (int i =0; i < items.count; i++) {
        AccountModel  * model = items[i];
        CellViewModel * cellAttributeModel = [[CellViewModel alloc]init];
        cellAttributeModel.labsBackgroundColor    = AdapterColor(220, 220, 220);
        cellAttributeModel.priceBackgroundColor   = AdapterColor(230, 230, 230);
        cellAttributeModel.gradeBackgroundColor   = AdapterColor(240, 240, 240);
        cellAttributeModel.soldoutBackgroundColor = AdapterColor(247, 247, 247);
        cellAttributeModel.reduceBackgroundColor   = AdapterColor(240, 240, 240);
        cellAttributeModel.freeAdmissBackgroundColor = AdapterColor(247, 247, 247);
        cellAttributeModel.avatarurl = model.avatarurl;
        cellAttributeModel.desc = model.desc;
        cellAttributeModel.price = model.price;
        cellAttributeModel.grade = model.grade;
        cellAttributeModel.soldout = model.soldout;
        cellAttributeModel.labels = model.labels;
        cellAttributeModel.reduce = model.reduce;
        cellAttributeModel.freeAdmission = model.freeAdmission;
        [self.results addObject:cellAttributeModel];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (block) {
            block(self.results,YES);
        }
    });
}

@end
