//
//  Dazzle_PhotoPresentContainerView.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "Dazzle_PhotoPresentContainerView.h"
#import "CategoryCell.h"
@interface Dazzle_PhotoPresentContainerView () <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView * tableView;
@end
@implementation Dazzle_PhotoPresentContainerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    [self addSubview:self.tableView];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsZero);
    }];
}
-(void)setDatas:(NSArray *)datas{
    _datas = datas;
    if (_datas.count == 0 || _datas == nil)return;
    [self.tableView reloadData];
}

#pragma mark - IBOutlet Events
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        if (@available(ios 11.0,*)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryCell * cell = [CategoryCell cellWithTableView:tableView];
    cell.model = self.datas[indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.callback) {
        self.callback(self.datas[indexPath.row]);
    }
}

@end
