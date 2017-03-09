//
//  AutoBannerView.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/29.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSInteger,AutoBannerScrollPageContolAliment)
{
    AutoBannerScrollPageContolAlimentRight,
    AutoBannerScrollPageContolAlimentCenter,
};

@interface AutoBannerView : UIView

/**
 *  初始化
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;
/**
 *  用于下拉图片放大效果
 *
 *  @param offset             offset
 */
- (void)cycleScrollViewStretchingWithOffset:(CGFloat)offset;

@property (copy, nonatomic) void(^autoBannerItemCallBack)(NSInteger idx ,id model);

#pragma mark - require
//图片数组
@property (nonatomic, strong) NSArray *cycleImageArray;
//图片路径数组
@property (nonatomic, strong) NSArray *cycleImageUrlArray;

#pragma mark - optional
//预防点击做一些动作 增添这个属性  应与图片数组的数量一致并且一一对应
@property (nonatomic, strong) NSArray *modelArray;
//设定加载失败次数(范围内尝试重新加载)
@property (nonatomic, assign) NSInteger networkFailedCount;
//是否显示pageControl   默认显示
@property(nonatomic, assign) BOOL showPageControl;
//pageControl显示位置
@property (nonatomic, assign) AutoBannerScrollPageContolAliment cycleScrollPageControlAliment;

//pageControl当前颜色
@property (nonatomic, strong) UIColor *cycleCurrentPageIndicatorTintColor;
//pageControl平常颜色
@property (nonatomic, strong) UIColor *cyclePageIndicatorTintColor;

//是否允许拉伸效果  默认无效果
@property (nonatomic, assign) BOOL enbleStretch;

@end
