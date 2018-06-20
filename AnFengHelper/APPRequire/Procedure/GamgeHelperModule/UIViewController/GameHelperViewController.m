//
//  GameHelperViewController.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "GameHelperViewController.h"
#import "HorizontalLayOut.h"
#import "CollectionViewCell.h"
#import "CollectionModel.h"

@interface GameHelperViewController ()
@property(nonatomic,strong) UIView * contentView;
@property(nonatomic,strong) UIScrollView *  scrollView;
@property(nonatomic,strong) NSMutableArray *  items;
@property(nonatomic,strong) NSMutableArray *  labelContainers;
@end

@implementation GameHelperViewController

#pragma mark - getter methods
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
-(UIScrollView *)scrollView{
    _scrollView = ({
        if (!_scrollView) {
            _scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
            _scrollView.pagingEnabled = YES;
            _scrollView.showsHorizontalScrollIndicator = NO;
        }
        _scrollView;
    });
    return _scrollView;
}

-(UIView *)contentView{
    _contentView = ({
        if (!_contentView) {
            _contentView = [[UIView alloc]initWithFrame:CGRectZero];
            _contentView.backgroundColor = [UIColor whiteColor];
        }
        _contentView;
    });
    return _contentView;
}
#pragma mark - IBOut Events
-(void)loadData{
    for (int i = 0; i < 5; i++) {
        NSString * title = @"'呐喊'是沈从文的代表作，入选20世纪中文小说100强，排名第二位，仅次于鲁迅的'呐喊'。它以20世纪30年代川湘交界的边城小镇茶峒为背景，以兼具抒情诗和小品文的优美笔触，描绘了湘西地区特有的风土人情；借船家少女翠翠的纯爱故事";
        [self.items addObject:title];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self)weakSelf = self;
    [self loadData];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(weakSelf.view.mas_top).with.offset(0.f);
    }];
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.scrollView).insets(UIEdgeInsetsZero);
        make.width.mas_equalTo(weakSelf.scrollView.mas_width);
    }];
    //
    for (int i = 0; i < self.items.count; i++) {
        UILabel * label = [UILabel new];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        label.text = self.items[i];
        label.numberOfLines = 0.f;
        [label sizeToFit];
        [self.contentView addSubview:label];
        [self.labelContainers addObject:label];
    }
   
    __block UILabel * anchor = nil;
    __block CGFloat padding = 16.f;
    dispatch_queue_t queue = dispatch_queue_create("com.wkg.cn", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        [self.labelContainers enumerateObjectsUsingBlock:^(UILabel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(16);
                make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-padding);
                if (anchor == nil) {
                    make.top.mas_equalTo(weakSelf.contentView.mas_top).with.offset(padding);
                }else{
                    make.top.mas_equalTo(anchor.mas_bottom).with.offset(padding);
                }
            }];
            anchor = obj;
        }];
        dispatch_barrier_async(dispatch_get_main_queue(), ^{
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(anchor.mas_bottom).with.offset(40.f);
            }];
        });
    });
}

#pragma mark - UICollectionViewDelegateFlowLayout


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
