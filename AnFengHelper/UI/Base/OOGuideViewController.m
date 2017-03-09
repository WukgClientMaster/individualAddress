//
//  OOGuideViewController.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/5/6.
//  Copyright © 2016年 吴可高. All rights reserved.

#import "OOGuideViewController.h"
@interface OOGuideViewController()<UIScrollViewDelegate>
{
    UIImageView*_guideImageView;
}

@property(nonatomic,strong)UIScrollView *guideScrollView;
@property(nonatomic,strong)UIPageControl *scrollViewPageControl;
@property(nonatomic,strong)UIButton *immediatelyButton;
@property(nonatomic,strong)NSMutableArray * guideImageArray;

@property (nonatomic,strong)NSArray *guideImgArray;
@property (nonatomic,strong)NSArray *indictorArray;
@property (nonatomic,strong)UIButton *button;

@end
@implementation OOGuideViewController

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
-(NSMutableArray *)guideImageArray
{
    if (!_guideImageArray) {
        _guideImageArray = [NSMutableArray array];
    }
    return _guideImageArray;
}

-(void)loadScrollViewUI
{
    _guideScrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    _guideScrollView.contentSize  = CGSizeMake(kScreen_Width*(self.guideImageArray.count), kScreen_Height);
    _guideScrollView.showsHorizontalScrollIndicator = NO;
    _guideScrollView.showsVerticalScrollIndicator   = NO;
    _guideScrollView.pagingEnabled  = YES;
    _guideScrollView.delegate  = self;
    _guideScrollView.bounces  =  NO;
    //
    _scrollViewPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,0, 0,0)];
    _scrollViewPageControl.backgroundColor  = [UIColor clearColor];
    _scrollViewPageControl.numberOfPages = [self.guideImageArray count];
    _scrollViewPageControl.currentPage  = 0;
    
    [self.view addSubview:_guideScrollView];
    [self.view addSubview:_scrollViewPageControl];
    [self loadingGuideImageDataSource];
    
    if (_guideImageView.tag == self.guideImageArray.count-1)
    {
        _guideImageView.userInteractionEnabled = YES;
    }
}
#pragma mark - GuideImageDataSource
-(void)loadingGuideImageDataSource
{
    for (int guideImgIndex = 0;guideImgIndex < self.guideImageArray.count; guideImgIndex ++)
    {
        _guideImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0+kScreen_Width *guideImgIndex, 0,kScreen_Width, kScreen_Height)];
        _guideImageView.contentMode = UIViewContentModeScaleToFill;
        
    }
}
-(UIButton*)immediatelyButton
{
    if (!_immediatelyButton)
    {
        _immediatelyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _immediatelyButton.frame  = CGRectMake(kScreen_Width/3,kScreen_Height- 100,kScreen_Width/3, 60);
        [_immediatelyButton addTarget:self action:@selector(immediatelyViewClicked:) forControlEvents:UIControlEventTouchDown];
        [_immediatelyButton setTitle:@"立即体验" forState:UIControlStateNormal];
        _immediatelyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _immediatelyButton;
}
#pragma  mark - 引导页最后一页促发 去到载入界面
#pragma  mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{

}

-(void)immediatelyViewClicked:(UIButton*)immediatelyButton
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
