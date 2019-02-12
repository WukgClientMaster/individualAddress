//
//  TableViewController.m
//  AnFengHelper
//
//  Created by 智享城市iOS开发 on 2019/1/31.
//  Copyright © 2019年 AnFen. All rights reserved.
//

#import "TableViewController.h"
#import "APPItemConfig.h"
#import "SettingCell.h"

@interface TableViewController ()
@property (strong, nonatomic) NSMutableArray * items;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = _configTitle;
	[self initData];
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
	
	APPArrowItem * arItem0 = [APPArrowItem initializeWithImg:@"" title:@"更换主题" subtitle:@"" class:[TableViewController class]];
	__weak  typeof(self)weakSelf = self;
	APPCustomItem * cuItem0 = [APPCustomItem initializeWithImg:@"" title:@"联系我们" subtitle:@"" block:^(NSString *msg, id response) {

	}];
	
	APPArrowItem * arItem1 = [APPArrowItem initializeWithImg:@"" title:@"账号申诉" subtitle:@"" class:[TableViewController class]];
	APPGroup * group1 = [APPGroup initializeWithItems:@[arItem0,cuItem0,arItem1] header:@"个人服务" footer:@""];
		//自我介绍
	APPCUSTextFieldViewItem * textFieldItem0 = [APPCUSTextFieldViewItem initializeWithImg:@"" title:@"姓名" subtitle:@""];
	textFieldItem0.configJson = @{KEYBOARD_TYPE:@(UIKeyboardTypeDefault),PLACEHOLDER:@"请输入姓名",TEXT_RANGE:@[@(0),@(5)]};
	
	APPCUSTextFieldViewItem * textFieldItem1 = [APPCUSTextFieldViewItem initializeWithImg:@"" title:@"联系方式" subtitle:@""];
	textFieldItem1.configJson = @{KEYBOARD_TYPE:@(UIKeyboardTypePhonePad),PLACEHOLDER:@"请输入联系方式",TEXT_RANGE:@[@(0),@(11)]};
	APPCustomItem * customItem0 = [APPCustomItem initializeWithImg:@"" title:@"出生年月" subtitle:@"" block:^(NSString *msg, id response) {
	}];
	APPCUSTextFieldViewItem * textFieldItem2 = [APPCUSTextFieldViewItem initializeWithImg:@"" title:@"现住地址" subtitle:@""];
	textFieldItem2.configJson = @{KEYBOARD_TYPE:@(UIKeyboardTypeDefault),PLACEHOLDER:@"请填写现住地址",TEXT_RANGE:@[@(0),@(25)]};
	
	
	
	APPArrowItem * runningHourItem = [APPArrowItem initializeWithImg:@"" title:@"工作年份" subtitle:@"" class:[TableViewController class]];
	APPGroup * group2 = [APPGroup initializeWithItems:@[textFieldItem0,textFieldItem1,customItem0,textFieldItem2,runningHourItem] header:@"自我介绍" footer:@""];
	
		//教育经历
	APPCustomItem * eduItem0 = [APPCustomItem initializeWithImg:@"" title:@"最高学历" subtitle:@"" block:^(NSString *msg, id response) {
	}];
	APPArrowItem * eduItem1 = [APPArrowItem initializeWithImg:@"" title:@"毕业学校" subtitle:@"" class:[TableViewController class]];
	APPCUSTextFieldViewItem * eduItem2 = [APPCUSTextFieldViewItem initializeWithImg:@"" title:@"专业" subtitle:@""];
	eduItem2.configJson = @{KEYBOARD_TYPE:@(UIKeyboardTypeDefault),PLACEHOLDER:@"请填写专业名称",TEXT_RANGE:@[@(0),@(20)]};
	
	APPArrowItem * eduItem3 = [APPArrowItem initializeWithImg:@"" title:@"毕业时间" subtitle:@"" class:[TableViewController class]];
	APPGroup * group3 = [APPGroup initializeWithItems:@[eduItem0,eduItem1,eduItem2,eduItem3] header:@"教育经历" footer:@""];
	
		//屏蔽公司信息
	APPCUSTextFieldViewItem * comItem0 = [APPCUSTextFieldViewItem initializeWithImg:@"" title:@"公司名称" subtitle:@""];
	comItem0.configJson = @{KEYBOARD_TYPE:@(UIKeyboardTypeDefault),PLACEHOLDER:@"请填写公屏蔽公司名称",TEXT_RANGE:@[@(0),@(30)]};
	
	APPCUSTextFieldViewItem * comItem1 = [APPCUSTextFieldViewItem initializeWithImg:@"" title:@"职位" subtitle:@""];
	comItem1.configJson = @{KEYBOARD_TYPE:@(UIKeyboardTypeDefault),PLACEHOLDER:@"请填写公屏蔽公司职位",TEXT_RANGE:@[@(0),@(20)]};
	
	APPCustomItem * comItem2  = [APPCustomItem initializeWithImg:@"" title:@"起至时间" subtitle:@"" block:^(NSString *msg, id response) {
	}];
	
	APPCUSTextFieldViewItem * comItem3 = [APPCUSTextFieldViewItem initializeWithImg:@"" title:@"期望薪资" subtitle:@""];
	comItem3.configJson = @{KEYBOARD_TYPE:@(UIKeyboardTypeDefault),PLACEHOLDER:@"请输入联系邮箱",TEXT_RANGE:@[@(0),@(5)]};
	
	APPCUSTextFieldViewItem * comItem4 = [APPCUSTextFieldViewItem initializeWithImg:@"" title:@"联系邮箱" subtitle:@""];
	comItem4.configJson = @{KEYBOARD_TYPE:@(UIKeyboardTypeDefault),PLACEHOLDER:@"请输入联系邮箱",TEXT_RANGE:@[@(0),@(5)]};
	
	APPGroup * group4 = [APPGroup initializeWithItems:@[comItem0,comItem1,comItem2,comItem3,comItem4] header:@"屏蔽公司信息" footer:@""];
	self.items = @[group0,group1,group2,group3,group4].mutableCopy;
}
-(void)setConfigTitle:(NSString *)configTitle{
	NSAssert(configTitle, @"title is not nil");
	_configTitle = configTitle;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
