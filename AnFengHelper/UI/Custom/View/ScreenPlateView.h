//
//  ScreenPlateView.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/14.
//  Copyright © 2016年 吴可高. All rights reserved.
//  筛选器主视图容器

#import <UIKit/UIKit.h>
@class ScreenPlateView;
@protocol ScreenPlateDelegate <NSObject>

-(void)screenPlate:(ScreenPlateView*)screenPlate clickedItemIndex:(NSInteger)idx;
@end

@interface ScreenPlateView : UIView

@property (assign, nonatomic,readonly) NSInteger itemDidSelectedIdx;
@property (copy, nonatomic,readonly) NSString * title;

@property (weak, nonatomic)  id <ScreenPlateDelegate> delegate;

/*
 * 初始化方法
 * @brief 初始的时候指定标题以及按钮
 * @param others传入一个数组，数组内容为NSString
 */
-(instancetype)initWithTitle:(NSString*)title destoryItemTitle:(NSString*)destoryTitle otherItems:(NSArray*)others;

///显示
- (void)showInSuperView;
//
-(NSString*) itemTitleWithAtIndex:(NSInteger)index;

@end
