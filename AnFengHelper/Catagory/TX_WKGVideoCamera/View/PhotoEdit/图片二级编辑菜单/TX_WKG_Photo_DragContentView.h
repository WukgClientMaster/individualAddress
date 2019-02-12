//
//  TX_WKG_Photo_DragContentView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/5.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TX_WKG_Photo_DragContentViewCallback)(NSString* optional);

@interface TX_WKG_Photo_DragContentView : UIView
@property (nonatomic, strong, readonly) UILabel * contentLabel;
@property (strong,readonly,nonatomic) UIColor * textColor;
@property (nonatomic,copy)TX_WKG_Photo_DragContentViewCallback dragContentCallback;

- (instancetype)initWithFrame:(CGRect)frame text:(NSString*)text;
-(void)setConfigWithContentText:(NSString*)text;
-(void)setConfigWithContentTextColor:(UIColor*)textColor;

- (void)hideToolBar;
- (void)showToolBar;

@end
