//
//  OOWebViewProgressView.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/5/4.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OOWebViewProgressView : UIView

@property (assign, nonatomic) float progress;
@property (nonatomic) UIView *progressBarView;
@property (nonatomic) NSTimeInterval barAnimationDuration; // default 0.1
@property (nonatomic) NSTimeInterval fadeAnimationDuration; // default 0.27
@property (nonatomic) NSTimeInterval fadeOutDelay; // default 0.1
- (void)setProgress:(float)progress animated:(BOOL)animated;

@property (strong, nonatomic) UIColor * tintBarColor;


@end
