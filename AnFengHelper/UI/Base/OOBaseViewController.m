//
//  OOBaseViewController.m
//  Learn_ObjectiveC
//
//  Created by 吴可高 on 16/3/21.
//  Copyright (c) 2016年 吴可高. All rights reserved.

#import "OOBaseViewController.h"
#import "UtilityTool.h"

const NSInteger kBarButtonItemIndex = 1000;

@interface OOBaseViewController ()<UINavigationControllerDelegate>
{
    UINavigationItem * _navigationItem;
}

@property (copy, nonatomic) OOBaseUIBarButtonItemCallBackBlock leftBarButtonBlock;
@property (copy, nonatomic) OOBaseUIBarButtonItemCallBackBlock rightBarButtonBlock;

@property (strong, nonatomic) UINavigationBar * navigationBar;

@end

@implementation OOBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.edgesForExtendedLayout  = UIRectEdgeAll;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(UINavigationBar *)navigationBar
{
    _navigationBar = ({
        if (!_navigationBar) {
            _navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0,0, kScreen_Width, kNavigationBarHeight)];
        }
        _navigationBar;
    });
    return _navigationBar;
}

-(void)normalNavigationBarStyle
{
    [self.view addSubview:self.navigationBar];
}

-(void)customNaviagtionBarConfigItems:(NSArray*)items
{
    [self.view addSubview:self.navigationBar];
    UINavigationItem * navigationItem = [[UINavigationItem alloc]init];
    [self.navigationBar pushNavigationItem:navigationItem animated:YES];
    _navigationItem = navigationItem;
    [self navigationBarButtonItemConfig:_navigationItem andItems:items];
}

-(void)navigationBarButtonItemConfig:(UINavigationItem*)navigationItem
                            andItems:(NSArray*)items
{
    for (int index = 0; index < items.count; index ++)
    {
        UIButton * buttonItem = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonItem.frame  = CGRectMake(0, 0, kNavigationBarHeight-20, kNavigationBarHeight -20);
        buttonItem.tag = kBarButtonItemIndex + index;
        //
        UIImage * itemImg = [UIImage imageNamed:items[index][1]];
        [buttonItem setImage:itemImg forState:UIControlStateNormal];
        [buttonItem setTitle:items[index][0]  forState:UIControlStateNormal];
        [buttonItem addTarget:self action:@selector(popOrPushStackTop:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:buttonItem];
        if (index ==0) {
            navigationItem.leftBarButtonItem = barButtonItem;
        }
        else
            navigationItem.rightBarButtonItem = barButtonItem;
    }
}

-(void)customNavigationBarStyleWithleftBarItems:(NSArray *)leftBarItems
                            navigationItemTitle:(NSString *)title
                         andRightBarButtonItems:(NSArray *)rightItems
                      leftBarItemHandleComplete:(OOBaseUIBarButtonItemCallBackBlock)leftBarItemBlock
                     rightBarItemHanbleComplete:(OOBaseUIBarButtonItemCallBackBlock)rightBarBlock
{
    _leftBarButtonBlock   = leftBarItemBlock;
    _rightBarButtonBlock  = rightBarBlock;
    //
     NSArray * configArrays = @[leftBarItems,rightItems];
    [self customNaviagtionBarConfigItems:configArrays];
     self.navigationItemTitle = title;

}

-(void)popOrPushStackTop:(UIButton* )parameter
{
    if (_leftBarButtonBlock && parameter.tag-kBarButtonItemIndex ==0) {
        
        _leftBarButtonBlock(parameter.tag - kBarButtonItemIndex,parameter);
    }
    if (_rightBarButtonBlock && parameter.tag-kBarButtonItemIndex ==1) {
        
        _rightBarButtonBlock(parameter.tag - kBarButtonItemIndex,parameter);
    }
}

-(void)setNavigationItemTitle:(NSString *)navigationItemTitle
{
    _navigationItemTitle = navigationItemTitle;
    _navigationItem.title = [UtilityTool matchingIsEmpity:_navigationItemTitle]? @"":_navigationItemTitle;
}

-(void)setLeftBarItems:(NSArray *)leftBarItems
{
    _leftBarItems = leftBarItems;
    if (!_leftBarItems && _leftBarItems.count == 0)return;
    UIView * leftBatButtonView = _navigationItem.leftBarButtonItem.customView;
    if ([leftBatButtonView isKindOfClass:[UIButton class]])
    {
        UIButton * leftBarButton =(UIButton*)leftBatButtonView;
        [leftBarButton setTitle:_leftBarItems[0] forState:UIControlStateNormal];
        UIImage * leftBarImg = [UIImage imageNamed:_leftBarItems[1]];
        [leftBarButton setImage:leftBarImg forState:UIControlStateNormal];
    }
}

-(void)setRightBarItems:(NSArray *)rightBarItems
{
    _rightBarItems = rightBarItems;
    if (!_rightBarItems && _rightBarItems.count == 0)return;
    UIView * rightBatButtonView = _navigationItem.rightBarButtonItem.customView;
    if ([rightBatButtonView isKindOfClass:[UIButton class]])
    {
        UIButton * rightBarButton =(UIButton*)rightBatButtonView;
        [rightBarButton setTitle:_rightBarItems[0] forState:UIControlStateNormal];
        UIImage * leftBarImg = [UIImage imageNamed:_leftBarItems[1]];
        [rightBarButton setImage:leftBarImg forState:UIControlStateNormal];
    }
}
@end
