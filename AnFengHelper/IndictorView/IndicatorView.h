//
//  IndicatorView.h
//  smarket
//
//  Created by client on 2017/7/20.
//  Copyright © 2017年 原研三品. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndicatorView : UIView

@property(nonatomic,strong) UIImageView * imgView;
@property(nonatomic,strong) UILabel * indicatorLabel;
@property(nonatomic,strong) UIView * indicator;

-(void)startAnimating;
-(void)stopAnimating;

@end
