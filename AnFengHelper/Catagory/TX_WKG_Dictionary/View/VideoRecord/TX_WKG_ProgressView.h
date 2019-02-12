//
//  TX_WKG_ProgressView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/3/27.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  TX_WKG_ProgressView : UIView
@property (assign,readonly,nonatomic) float progressValue;
@property (assign, nonatomic) float  maximumValue;
@property (assign, nonatomic) float  minimumValue;
@property (assign,readonly,nonatomic) BOOL pause;
@property (strong,readonly,nonatomic) NSMutableArray * videofragmentViews;
@property (strong, nonatomic) UIColor *trackTintColor;
@property (strong, nonatomic) UIColor *indicatorColor;
@property (strong, nonatomic) UIColor *thumbColor;

- (void)removelastProgressView;
- (void)setVideoRecordPause:(BOOL)pause;

@end

