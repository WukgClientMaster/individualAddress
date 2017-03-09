//
//  ActionSheetView.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/18.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionSheetView : UIView

@property (nonatomic, copy) void (^Click)(NSInteger clickIndex);

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr;

- (void)hiddenSheet;
@end

