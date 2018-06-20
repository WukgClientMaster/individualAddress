//
//  AccountCenterViewController.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "AccountCenterViewController.h"
#import "AccountLabsCell.h"
#import "AccountNoneLabsCell.h"

#import "AccountDataController.h"
#import "AccountViewModel.h"
#import "CellViewModel.h"
#import <AVFoundation/AVFoundation.h>

@interface AccountCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * items;
@end

@implementation AccountCenterViewController

-(UITableView *)tableView{
    _tableView = ({
        if (!_tableView) {
            _tableView  = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            _tableView.delegate   = self;
            _tableView.dataSource = self;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            _tableView.separatorColor  = AdapterColor(220, 220, 220);
        }
        _tableView;
    });
    return _tableView;
}

-(void)queryData{
    __weak typeof(self)weakSelf = self;
    AccountDataController * dataController = [AccountDataController shareInstance];
    [dataController queryAccountlistsData:^(id respnse, BOOL status) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (status) {
            if ([respnse isKindOfClass:[NSMutableArray class]]) {
                NSMutableArray * items = (NSMutableArray*)respnse;
                [strongSelf fetchQueryViewModelSerialize:items];
            }
        }
    }];
}

-(void)fetchQueryViewModelSerialize:(NSMutableArray*)items{
    AccountViewModel * accountViewModel = [AccountViewModel shareInstance];
    __weak typeof(self)weakSelf = self;
    [accountViewModel startViewModelSerialize:items serializeCallback:^(id respnse, BOOL status) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (status) {
            if ([respnse isKindOfClass:[NSMutableArray class]]) {
                 strongSelf.items = (NSMutableArray*)respnse;
                [strongSelf.tableView reloadData];
            }
        }
    }];
}

-(void)setObjectView{
    __weak  typeof(self)weakSelf = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        make.left.and.right.equalTo(strongSelf.view);
        make.top.equalTo(strongSelf.view.mas_top);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).with.offset(-APPAdapterAdjustHeight(49.f));
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self queryData];
    [self setObjectView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
#pragma mark - UITableViewDelegate DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return APPAdapterAdjustHeight(125.f);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellViewModel * cellViewModel = self.items[indexPath.row];
    if (cellViewModel.labels.count == 0) {
        AccountNoneLabsCell * cell = [AccountNoneLabsCell cellReuseWith:tableView reuseIndefiner:@"cellIndefiner"];
        cell.cellData = self.items[indexPath.row];
        [cell loadContentData];
        return cell;
    }else{
        AccountLabsCell * cell = [AccountLabsCell cellReuseWith:tableView reuseIndefiner:@"lbsCellIndefiner"];
        cell.cellData = self.items[indexPath.row];
        [cell loadContentData];
        return cell;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
