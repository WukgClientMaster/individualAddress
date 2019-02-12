//
//  TX_ParentOptionalView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/25.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TX_ParentOptionalCallback)(NSString* title);

@interface TX_ParentOptionalView : UIView

@property (copy, nonatomic) TX_ParentOptionalCallback block;
-(void)autolayoutScrollViewContentViewOffSet;

-(void)scrollToIndex:(NSInteger)index;

@end
