//
//  TX_WKG_Photo_PasterContentView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/8.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TX_WKG_Paster_Node.h"

typedef void (^TX_WKG_Photo_PasterContentViewCallback)(NSString* optional);

@interface TX_WKG_Photo_PasterContentView : UIView
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (strong, nonatomic) TX_WKG_Paster_Node * pasterNode;
@property (copy, nonatomic) TX_WKG_Photo_PasterContentViewCallback pasterContentClickCallback;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
- (instancetype)copyWithScaleFactor:(CGFloat)factor relativedView:(UIView *)imageView;

- (void)hideToolBar;
- (void)showToolBar;
- (BOOL)isToolBarHidden;

@end
