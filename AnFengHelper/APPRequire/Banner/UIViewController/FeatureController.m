//
//  FeatureController.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/9.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "FeatureController.h"
#import "AnFengTabBarController.h"

static FeatureController * _featureController = nil;
static dispatch_once_t once;
@interface FeatureController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)NSMutableArray * banners;
@property(nonatomic,strong)UIButton * useingAPPItem;
@property(nonatomic,strong)AnFengTabBarController * anFengTabBarController;

@end

@implementation FeatureController

+(instancetype)shareInstance;
{
    @synchronized(self) {
        dispatch_once(&once, ^{
            if (!_featureController) {
                _featureController  = [[FeatureController alloc]init];
            }
        });
    };
    return _featureController;
}
-(UIButton *)useingAPPItem
{
    _useingAPPItem = ({
        if (!_useingAPPItem) {
            _useingAPPItem  = [UIButton buttonWithType:UIButtonTypeCustom];
            [_useingAPPItem setTitle:@"进入APP" forState:UIControlStateNormal];
             _useingAPPItem.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [_useingAPPItem setBackgroundColor:[UIColor whiteColor]];
            [_useingAPPItem setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_useingAPPItem addTarget:self action:@selector(useingAPP:) forControlEvents:UIControlEventTouchUpInside];
        }
        _useingAPPItem;
    });
    return _useingAPPItem;
}
-(NSMutableArray *)banners
{
    _banners = ({
        if (!_banners) {
             _banners = [NSMutableArray array];
            for (int i = 0; i < 3; i++) {
                [_banners addObject:@(i)];
            }
        }
    _banners;
    });
    return _banners;
}

-(UIScrollView *)scrollView
{
    _scrollView = ({
        if (!_scrollView) {
            _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            _scrollView.pagingEnabled = YES;
            _scrollView.bounces = NO;
            _scrollView.showsHorizontalScrollIndicator = NO;
            _scrollView.showsVerticalScrollIndicator = NO;
            _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
            _scrollView.delegate = self;
        }
        _scrollView;
    });
    return _scrollView;
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)setObjectView
{
     self.scrollView.contentSize = CGSizeMake(kScreen_Width * self.banners.count,kScreen_Height);
    [self.view addSubview:self.scrollView];
     for (int i = 0; i < self.banners.count; i++) {
         UIImageView * imageView = [[UIImageView alloc]init];
         imageView.frame = CGRectMake(i*kScreen_Width, 0, kScreen_Width, kScreen_Height);
         imageView.backgroundColor = [UIColor colorWithRed:arc4random()%255 / 255.0 green:arc4random()%255 / 255.0 blue:arc4random()%255 / 255.0 alpha:1.0f];
         [self.scrollView addSubview:imageView];
         imageView.userInteractionEnabled = YES;
         if (i == self.banners.count -1) {
             self.useingAPPItem.frame = CGRectMake(CGRectGetMidX(self.view.frame) -kScreen_Width/6.0f, CGRectGetHeight(self.view.frame) - kScreen_Width/4.0f, kScreen_Width/3.0f, 30.0f),
             [imageView addSubview:self.useingAPPItem];
         }
     }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setObjectView];
}

#pragma mark -UIScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

-(void)useingAPP:(id)sender
{
    AnFengTabBarController * anFengTabBarController = [AnFengTabBarController shareInstance];
    [UIApplication sharedApplication].keyWindow.rootViewController = anFengTabBarController;
}
@end
