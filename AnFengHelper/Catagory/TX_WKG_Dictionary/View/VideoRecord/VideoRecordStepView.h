//
//  VideoRecordStepView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/3/26.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^VideoRecordStepElectBlock)(NSString* title);
@interface VideoRecordStepView : UIView
@property (copy, nonatomic) VideoRecordStepElectBlock block;
-(void)autolayoutScrollViewContentViewOffSet;

@end
