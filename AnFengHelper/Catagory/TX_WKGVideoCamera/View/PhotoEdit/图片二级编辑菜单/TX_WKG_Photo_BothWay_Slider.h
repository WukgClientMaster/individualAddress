//
//  TX_WKG_Photo_BothWay_Slider.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/7/4.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TX_WKG_Photo_BothWay_Slider : UIControl

@property(nonatomic) float value;
@property(nonatomic) float minimumValue;
@property(nonatomic) float maximumValue;

@property (strong,readonly,nonatomic) NSMutableDictionary * jsonData;
@property(nullable, nonatomic,strong) UIColor *minimumTrackTintColor;
@property(nullable, nonatomic,strong) UIColor *maximumTrackTintColor;
@property(nullable, nonatomic,strong) UIColor *thumbTintColor;
@property(nullable, strong,nonatomic) UIColor *indicatorTintColor;

-(void)resetViews;

-(void)initSetViewsWith:(NSString*)title;

-(void)setSliderWithValue:(CGFloat)value cata:(NSString*)title;

@end
