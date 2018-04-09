//
//  IndicatorViewManager.h
//  smarket
//
//  Created by client on 2017/7/20.
//  Copyright © 2017年 原研三品. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndicatorViewManager : NSObject
@property(nonatomic,strong) NSArray *indicatorImages;
@property(nonatomic,assign) CGRect  frame;
@property(nonatomic,strong) UIColor *backgroudColor;
@property(nonatomic,assign) CGFloat autoAnimationInterval;



+(instancetype)shareInstance;

-(void)diagnosticPush:(NSString*)type;

-(void)diagnosticPop:(NSString *)type;


@end
