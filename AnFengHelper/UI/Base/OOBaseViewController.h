//
//  OOBaseViewController.h
//  Learn_ObjectiveC
//
//  Created by 吴可高 on 16/3/21.
//  Copyright (c) 2016年 吴可高. All rights reserved.
//  OOBaseViewController
//  自定义UINavigationBar
//  只针对通用UIBarButtonItem数目为1;(left - right)数据和视图重构
#import <UIKit/UIKit.h>

typedef void (^OOBaseUIBarButtonItemCallBackBlock)(NSInteger idx,UIButton* parameter);

@interface OOBaseViewController : UIViewController
//
@property (copy, nonatomic)   NSString * navigationItemTitle;
@property (strong, nonatomic) NSArray  * leftBarItems;
@property (strong, nonatomic) NSArray  * rightBarItems;

/**
 *  @param leftBarItems     例如:leftBarItems = (item.title, item.img)
 *  @param title
 *  @param rightItems       例如:rightBarItems = (item.title, item.img)
 *  @param leftBarItemBlock
 *  @param rightBarBlock
 */
-(void)customNavigationBarStyleWithleftBarItems:(NSArray*)leftBarItems
        navigationItemTitle:(NSString*)title
                         andRightBarButtonItems:(NSArray*)rightItems
                      leftBarItemHandleComplete:(OOBaseUIBarButtonItemCallBackBlock)leftBarItemBlock
                     rightBarItemHanbleComplete:(OOBaseUIBarButtonItemCallBackBlock)rightBarBlock;

-(void)normalNavigationBarStyle;

@end
