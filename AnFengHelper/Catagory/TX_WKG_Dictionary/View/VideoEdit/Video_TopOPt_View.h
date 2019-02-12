//
//  Video_TopOPt_View.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/17.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Video_Top_Opt_CallBack)(UIButton* item,NSString* title);
@interface Video_TopOPt_View : UIView
@property (copy, nonatomic) Video_Top_Opt_CallBack opt_callback;

-(void)setSelectedStatus:(BOOL)selected opt:(NSString*)title;
-(void)setSelectedEnable:(BOOL)enable opt:(NSString*)title;


@end
