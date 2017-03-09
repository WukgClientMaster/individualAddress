//
//  OOBaseTableViewController.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/5/6.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^OOBaseUIBarButtonItemCallBackBlock)(NSInteger idx,UIButton* parameter);

@interface OOBaseTableViewController : UITabBarController
//
@property (copy, nonatomic)   NSString * navigationItemTitle;
@property (strong, nonatomic) NSArray * leftBarItems;
@property (strong, nonatomic) NSArray * rightBarItems;

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

@end
