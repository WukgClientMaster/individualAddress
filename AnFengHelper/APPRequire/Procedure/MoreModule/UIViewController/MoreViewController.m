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
#import "TESTingViewController.h"

@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * items;
@end

@implementation MoreViewController
-(UITableView *)tableView{
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

-(NSMutableArray *)items{
    _items = ({
        if (!_items) {
            _items = [NSMutableArray arrayWithCapacity:0];
        }
        _items;
    });
    return _items;
}

-(void)initData{
    APPSwitchItem * swItem1 = [APPSwitchItem initializeWithImg:@"" title:@"手势密码" subtitle:@""];
    APPSwitchItem * swItem0 = [APPSwitchItem initializeWithImg:@"" title:@"消息接受企业提醒" subtitle:@""];
    APPSwitchItem * swItem2 = [APPSwitchItem initializeWithImg:@"" title:@"消息接受系统提醒" subtitle:@""];
    APPGroup * group0 = [APPGroup initializeWithItems:@[swItem1,swItem0,swItem2] header:@"消息设置" footer:@""];
    
    APPArrowItem * arItem0 = [APPArrowItem initializeWithImg:@"" title:@"更换主题" subtitle:@"" class:[TESTingViewController class]];
    __weak  typeof(self)weakSelf = self;
    APPCustomItem * cuItem0 = [APPCustomItem initializeWithImg:@"" title:@"联系我们" subtitle:@"" block:^(NSString *msg, id response) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf showInfoAlertViewWithText:msg];
    }];
    
    APPArrowItem * arItem1 = [APPArrowItem initializeWithImg:@"" title:@"账号申诉" subtitle:@"" class:[TESTingViewController class]];
    APPGroup * group1 = [APPGroup initializeWithItems:@[arItem0,cuItem0,arItem1] header:@"个人服务" footer:@""];
    //自我介绍
    APPCUSTextFieldViewItem * textFieldItem0 = [APPCUSTextFieldViewItem initializeWithImg:@"" title:@"姓名" subtitle:@""];
    textFieldItem0.configJson = @{KEYBOARD_TYPE:@(UIKeyboardTypeDefault),PLACEHOLDER:@"请输入姓名",TEXT_RANGE:@[@(0),@(5)]};
    
    APPCUSTextFieldViewItem * textFieldItem1 = [APPCUSTextFieldViewItem initializeWithImg:@"" title:@"联系方式" subtitle:@""];
    textFieldItem1.configJson = @{KEYBOARD_TYPE:@(UIKeyboardTypePhonePad),PLACEHOLDER:@"请输入联系方式",TEXT_RANGE:@[@(0),@(11)]};
    APPCustomItem * customItem0 = [APPCustomItem initializeWithImg:@"" title:@"出生年月" subtitle:@"" block:^(NSString *msg, id response) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf showInfoAlertViewWithText:msg];
    }];
    APPCUSTextFieldViewItem * textFieldItem2 = [APPCUSTextFieldViewItem initializeWithImg:@"" title:@"现住地址" subtitle:@""];
    textFieldItem2.configJson = @{KEYBOARD_TYPE:@(UIKeyboardTypeDefault),PLACEHOLDER:@"请填写现住地址",TEXT_RANGE:@[@(0),@(25)]};

    
    
    APPArrowItem * runningHourItem = [APPArrowItem initializeWithImg:@"" title:@"工作年份" subtitle:@"" class:[TESTingViewController class]];
    APPGroup * group2 = [APPGroup initializeWithItems:@[textFieldItem0,textFieldItem1,customItem0,textFieldItem2,runningHourItem] header:@"自我介绍" footer:@""];

     //教育经历
    APPCustomItem * eduItem0 = [APPCustomItem initializeWithImg:@"" title:@"最高学历" subtitle:@"" block:^(NSString *msg, id response) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf showInfoAlertViewWithText:msg];
    }];
    APPArrowItem * eduItem1 = [APPArrowItem initializeWithImg:@"" title:@"毕业学校" subtitle:@"" class:[TESTingViewController class]];
    APPCUSTextFieldViewItem * eduItem2 = [APPCUSTextFieldViewItem initializeWithImg:@"" title:@"专业" subtitle:@""];
    eduItem2.configJson = @{KEYBOARD_TYPE:@(UIKeyboardTypeDefault),PLACEHOLDER:@"请填写专业名称",TEXT_RANGE:@[@(0),@(20)]};

    APPArrowItem * eduItem3 = [APPArrowItem initializeWithImg:@"" title:@"毕业时间" subtitle:@"" class:[TESTingViewController class]];
    APPGroup * group3 = [APPGroup initializeWithItems:@[eduItem0,eduItem1,eduItem2,eduItem3] header:@"教育经历" footer:@""];

    //屏蔽公司信息
    APPCUSTextFieldViewItem * comItem0 = [APPCUSTextFieldViewItem initializeWithImg:@"" title:@"公司名称" subtitle:@""];
    comItem0.configJson = @{KEYBOARD_TYPE:@(UIKeyboardTypeDefault),PLACEHOLDER:@"请填写公屏蔽公司名称",TEXT_RANGE:@[@(0),@(30)]};

    APPCUSTextFieldViewItem * comItem1 = [APPCUSTextFieldViewItem initializeWithImg:@"" title:@"职位" subtitle:@""];
    comItem1.configJson = @{KEYBOARD_TYPE:@(UIKeyboardTypeDefault),PLACEHOLDER:@"请填写公屏蔽公司职位",TEXT_RANGE:@[@(0),@(20)]};
    
    APPCustomItem * comItem2  = [APPCustomItem initializeWithImg:@"" title:@"起至时间" subtitle:@"" block:^(NSString *msg, id response) {
        __strong typeof(weakSelf)strongSelf =weakSelf;
        [strongSelf showInfoAlertViewWithText:msg];
    }];
    APPArrowItem * comItem3 = [APPArrowItem initializeWithImg:@"" title:@"期望薪资" subtitle:@"" class:[TESTingViewController class]];
    APPArrowItem * comItem4 = [APPArrowItem initializeWithImg:@"" title:@"联系邮箱" subtitle:@"" class:[TESTingViewController class]];
    APPGroup * group4 = [APPGroup initializeWithItems:@[comItem0,comItem1,comItem2,comItem3,comItem4] header:@"屏蔽公司信息" footer:@""];
    self.items = @[group0,group1,group2,group3,group4].mutableCopy;
}


-(void)showInfoAlertViewWithText:(NSString*)text{
    NSString * msg = [NSString stringWithFormat:@"当前操作类别:%@",text];
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)setObjectView{
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
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager]setKeyboardDistanceFromTextField:APPAdapterAdjustHeight(20.f)];
}

#pragma mark - UITabViewDataSource Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.items.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return APPAdapterAdjustHeight(45.f);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    APPGroup * group = self.items[section];
    return group.items.count;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    APPGroup * group = self.items[section];
    return group.header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? APPAdapterAdjustHeight(40.f) :  APPAdapterAdjustHeight(45.f)/2.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return APPAdapterAdjustHeight(0.f);
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     SettingCell * cell = (SettingCell*)[SettingCell cellReuseWith:tableView reuseIndefiner:@"cellIndefiner"];
     APPGroup * group = self.items[indexPath.section];
     cell.cellData = group.items[indexPath.row];
    [cell loadContentData];
    return cell;
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    APPGroup * group = self.items[indexPath.section];
    id data = group.items[indexPath.row];
    if (data == nil) return;
    if ([data isKindOfClass:[APPArrowItem class]]) {
        APPArrowItem * arrow = (APPArrowItem*)data;
        if (arrow.targetClass) {
            UIViewController * controller = [arrow.targetClass new];
            if ([controller isKindOfClass:[TESTingViewController class]]) {
                TESTingViewController *vc = (TESTingViewController*)controller;
                vc.configTitle = arrow.title;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else if ([data isKindOfClass:[APPCustomItem class]]){
        APPCustomItem * custom = (APPCustomItem*)data;
        if (custom.block) {
            custom.block(custom.title, custom);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
