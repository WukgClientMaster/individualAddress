//
//  GameHelperViewController.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "GameHelperViewController.h"
#import "TableViewCell.h"
#import "VideoPlayerView.h"

@interface GameHelperViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSMutableArray *  items;
@property(nonatomic,strong) NSMutableArray *  labelContainers;
@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) VideoPlayerView * playerView;
@property(nonatomic,assign) NSInteger  currentIdx;
@end

@implementation GameHelperViewController

#pragma mark - getter methods
-(VideoPlayerView *)playerView{
    _playerView = ({
        if (!_playerView) {
            _playerView = [[VideoPlayerView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        }
        _playerView;
    });
    return _playerView;
}

-(UITableView *)tableView{
    _tableView = ({
        if (!_tableView) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectZero];
            _tableView.pagingEnabled = YES;
            _tableView.delegate = self;
            _tableView.dataSource = self;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _tableView.backgroundColor = UIColorFromRGB(0x00000);
        }
        _tableView;
    });
    return _tableView;
}

-(NSMutableArray *)labelContainers{
    _labelContainers = ({
        if (!_labelContainers) {
            _labelContainers = [NSMutableArray array];
        }
        _labelContainers;
    });
    return _labelContainers;
}

-(NSMutableArray *)items{
    _items = ({
        if (!_items) {
            _items = [NSMutableArray array];
        }
        _items;
    });
    return _items;
}
#pragma mark - IBOut Events
-(void)loadData{
    NSString * cover_0 = @"http://oss-cn-hangzhou.aliyuncs.com/tsnrhapp/shop/videos/hx152713344842561c1cd7afe0944047b655c4044abf76ff.jpeg";
    NSString * video_0 = @"http://oss-cn-hangzhou.aliyuncs.com/tsnrhapp/shop/videos/c17b82db474148f373e41f81708d5f002013.mp4";
    //
    NSString * cover_1 = @"http://oss-cn-hangzhou.aliyuncs.com/tsnrhapp/31cef146-a974-488d-a7d7-08b4c2593c8f.jpg";
    NSString * video_1 = @"http://oss-cn-hangzhou.aliyuncs.com/tsnrhapp/c26fb673-5672-4c5d-b168-46c0d8ecc21e.mp4";;
    //
    NSString * cover_2 = @"http://zxcity-app.oss-cn-hangzhou.aliyuncs.com/user-dir/zx7RMCmYB3aiwJayh7Hs56RGMn.png";
    NSString * video_2 = @"http://zxcity-app.oss-cn-hangzhou.aliyuncs.com/user-dir/zxek4tTtwjiF7fC5ZFaMzbWxM7.mp4";
    //
    NSString * cover_3 = @"http://oss-cn-hangzhou.aliyuncs.com/tsnrhapp/shop/videos/919017d9e3c22a7fb6ad0efd984761d8.jpeg";
    NSString * video_3 = @"http://oss-cn-hangzhou.aliyuncs.com/tsnrhapp/shop/videos/d5cba3816e3d0ce400886ba8aefaa5f5.mp4";
    //
    NSString * cover_4 = @"http://oss-cn-hangzhou.aliyuncs.com/tsnrhapp/shop/videos/hx15183515541515.jpeg";
    NSString * video_4 = @"http://oss-cn-hangzhou.aliyuncs.com/tsnrhapp/shop/videos/1518351550.mp4";
    
    NSArray * covers = @[cover_0,cover_1,cover_2,cover_3,cover_4];
    NSArray * videos = @[video_0,video_1,video_2,video_3,video_4];

    for (int i = 0; i < covers.count; i++) {
        VideoJsonModel * model = [VideoJsonModel videoJsonWithCoverUrl:covers[i] video:videos[i]];
        [self.items addObject:model];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0   ];
    TableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [cell videoConfigPlayerView:self.playerView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self loadSubObjects];
}

-(void)loadSubObjects{
    __weak typeof(self)weakSelf = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(weakSelf.view).insets(UIEdgeInsetsZero);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell * cell = [TableViewCell tableViewCellWithTableView:tableView];
    cell.jsonModel = self.items[indexPath.row];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
   self.currentIdx = scrollView.contentOffset.y / kScreen_Height;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    UITableView * tableView = (UITableView*)scrollView;
    NSIndexPath * indexPath = [tableView indexPathForRowAtPoint:tableView.contentOffset];
    TableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell resetPlayerViews];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    UITableView * tableView = (UITableView*)scrollView;
    NSIndexPath * indexPath = [tableView indexPathForRowAtPoint:tableView.contentOffset];
    TableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell videoConfigPlayerView:self.playerView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScreen_Height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
