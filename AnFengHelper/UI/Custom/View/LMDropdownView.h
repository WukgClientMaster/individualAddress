//
//  LMDropdownView.h
//  LMDropdownView
//
//  Created by LMinh on 16/11/2014.
//  Copyright (c) Năm 2014 LMinh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LMDropdownViewStateWillOpen,
    LMDropdownViewStateDidOpen,
    LMDropdownViewStateWillClose,
    LMDropdownViewStateDidClose,
} LMDropdownViewState;

@protocol LMDropdownViewDelegate;

@interface LMDropdownView : NSObject

@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat closedScale;
@property (nonatomic, assign) CGFloat blurRadius;
@property (nonatomic, assign) CGFloat blackMaskAlpha;
@property (nonatomic, strong) UIView  *menuContentView;
@property (nonatomic, strong) UIColor *menuBackgroundColor;
@property(nonatomic,assign)   CGRect  dropViewFrame;

@property (nonatomic, assign, readonly) LMDropdownViewState currentState;
@property (nonatomic, assign) id <LMDropdownViewDelegate> delegate;

- (BOOL)isOpen;
- (void)showInView:(UIView *)view withFrame:(CGRect)frame;
- (void)hide;

@end


@protocol LMDropdownViewDelegate <NSObject>

- (void)dropdownViewDidTapBackgroundButton:(LMDropdownView *)dropdownView;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
