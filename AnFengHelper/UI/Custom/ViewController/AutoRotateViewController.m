//
//  AutoRotateViewController.m
//  Learn_ObjectiveC
//
//  Created by 吴可高 on 16/3/21.
//  Copyright (c) 2016年 吴可高. All rights reserved.
//

#import "AutoRotateViewController.h"
#import "PreviousMenuViewController.h"
#import "PresentMenuViewController.h"
#import "NextMenuViewController.h"

@interface AutoRotateViewController ()<UIScrollViewDelegate>
{
    CGRect _childViewPositionFrame;
}
@property (strong, nonatomic) UIScrollView * mainScrollView;
@property (strong, nonatomic) NSArray * itemArray;
@property (copy, nonatomic) RotateReponseBlcok  rotateBlcok;
@property (assign, nonatomic) int idxShow;
// init attribute
@property (strong, nonatomic) PreviousMenuViewController * previousMenuVC;
@property (strong, nonatomic) PresentMenuViewController * presentMenuVC;
@property (strong, nonatomic) NextMenuViewController * nextMenuVC;

@end

@implementation AutoRotateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(instancetype)initWithRotateCustomViewArray:(NSArray *)targetArray rotateReponseBlcok:(RotateReponseBlcok)block
{
    if (self = [super init])
    {
        _rotateBlcok = [block copy];
        _itemArray = targetArray;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        CGRect childViewFrame  = [UIScreen mainScreen].bounds;
        _childViewPositionFrame = CGRectMake(0, 40, childViewFrame.size.width, childViewFrame.size.height - 40.f);
        
        [self addChildViewController:self.previousMenuVC];
        [self addChildViewController:self.presentMenuVC];
        [self addChildViewController:self.nextMenuVC];
        [self.view addSubview:self.mainScrollView];
        [self.mainScrollView addSubview:self.previousMenuVC.view];
        [self.mainScrollView addSubview:self.presentMenuVC.view];
        [self.mainScrollView addSubview:self.nextMenuVC.view];
        [self reloadImages];
    }
    return self;
}

#pragma mark -  initialize SubViewsObject
-(PreviousMenuViewController *)previousMenuVC
{
    _previousMenuVC = ({
        if (!_previousMenuVC)
        {
            _previousMenuVC  = [[PreviousMenuViewController alloc]init];
        }
        _previousMenuVC;
    });
    return _previousMenuVC;
}

-(PresentMenuViewController *)presentMenuVC
{
    _presentMenuVC  = ({
        if (!_presentMenuVC) {
            _presentMenuVC  = [[PresentMenuViewController alloc]init];
        }
        _presentMenuVC;
    });
    return _presentMenuVC;
}
-(NextMenuViewController *)nextMenuVC
{
    _nextMenuVC  = ({
        if (!_nextMenuVC) {
            _nextMenuVC  = [[NextMenuViewController alloc]init];
        }
        _nextMenuVC;
    });
    return _nextMenuVC;
}

- (void)reloadImages {
    
    if (_idxShow >= _itemArray.count)
        _idxShow =0;
    if (_idxShow <0)
        _idxShow = (int)_itemArray.count -1;
    
    int prev = _idxShow -1;
    if (prev <0)
        prev = (int)_itemArray.count -1;
    
    int next = _idxShow + 1;
    if (next > _itemArray.count -1)
        next = 0;
}

#pragma mark - ViewController Getter Methods
-(UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:_childViewPositionFrame];
        _mainScrollView.showsHorizontalScrollIndicator =NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
    }
    _mainScrollView.contentSize = CGSizeMake(_childViewPositionFrame.size.width *3.0f, _childViewPositionFrame.size.height);
    return _mainScrollView;
}

#pragma mark - UIScrollView Delegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.x >=_childViewPositionFrame.size.width*2)
        _idxShow++;
    else if (scrollView.contentOffset.x < _childViewPositionFrame.size.width)
        _idxShow--;
    [self reloadImages];
}

@end
