//
//  MoreViewController.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "MoreViewController.h"
#import "APPItemConfig.h"
#import "SettingCell.h"
#import "APPDB.h"

@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * items;
@end

@implementation MoreViewController
-(UITableView *)tableView
{
    _tableView = ({
        if (!_tableView) {
            _tableView  = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
            _tableView.delegate   = self;
            _tableView.dataSource = self;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            _tableView.separatorColor  = AdapterColor(220, 220, 220);
        }
        _tableView;
    });
    return _tableView;
}

-(NSMutableArray *)items
{
    _items = ({
        if (!_items) {
            _items = [NSMutableArray arrayWithCapacity:0];
        }
        _items;
    });
    return _items;
}
-(void)initData
{
    APPSwitchItem * arrowItem0 = [APPSwitchItem initializeWithImg:@"" title:@"游戏" subtitle:@""];
    APPGroup * group0 = [APPGroup initializeWithItems:@[arrowItem0] header:@"" footer:@""];
    //
    APPItem * item0 =[APPItem initializeWithImg:@"" title:@"启动密码" subtitle:@""];
    APPArrowItem * item1 =[APPArrowItem initializeWithImg:@"" title:@"启动密码" subtitle:@"" class:[self class]];
    APPArrowItem * item2 = [APPArrowItem initializeWithImg:@"" title:@"校准时间" subtitle:@"" class:[self class]];
    APPArrowItem * item3 = [APPArrowItem initializeWithImg:@"" title:@"主题" subtitle:@"" class:[self class]];
    APPGroup * group1 = [APPGroup initializeWithItems:@[item0,item1,item2,item3] header:@"" footer:@""];
    //
    APPItem * item_0 = [APPItem initializeWithImg:@"" title:@"账号申述" subtitle:@""];
    APPArrowItem * item_1 = [APPArrowItem initializeWithImg:@"" title:@"主题" subtitle:@"" class:[self class]];
    APPGroup * group2 =[APPGroup initializeWithItems:@[item_0,item_1] header:@"" footer:@""];
    //
    APPCustomItem * item_2 =[APPCustomItem initializeWithImg:@"" title:@"加入我们" subtitle:@"" block:^(NSString *msg, id response) {
        
    }];
    APPGroup * group3 = [APPGroup initializeWithItems:@[item_2] header:@"" footer:@""];
    [self.items addObjectsFromArray:@[group0,group1,group2,group3]];
}

-(void)setObjectView
{
    __weak  typeof(self)weakSelf = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        make.edges.equalTo(strongSelf.view);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setObjectView];
    [self initData];
}
#pragma mark - UITabViewDataSource Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    APPGroup * group = self.items[section];
    return group.items.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     SettingCell * cell = (SettingCell*)[SettingCell cellReuseWith:tableView reuseIndefiner:@"cellIndefiner"];
     APPGroup * group = self.items[indexPath.section];
     cell.cellData = group.items[indexPath.row];
    [cell loadContentData];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
