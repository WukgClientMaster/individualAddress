//
//  CAlertView.h
//  AlertView
//
//  Created by 上海 on 14-11-13.
//  Copyright (c) 2014年 wumeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CAlertView;
@protocol CAlertViewDelegate <NSObject>
@optional
-(void)didRotationToInterfaceOrientation:(BOOL)Landscape view:(UIView*)view alertView:(CAlertView*)aletView;
@end

@interface CAlertView : UIView{
@private
    BOOL   _beShow;
//    UIInterfaceOrientation _orientation;
    UIDeviceOrientation _orientation;
    BOOL   _bePresented;
}
@property(nonatomic,retain)UIView*  backGroundView;
@property(nonatomic,retain)UIView*  contentView;
//距离上面的高度
@property(nonatomic,assign)float  offHeight;
@property(nonatomic, readonly)BOOL  visible;
@property(nonatomic,assign)id<CAlertViewDelegate> delegate;

- (id)initWithView:(UIView*)view;
-(void)show;
-(void)dismissAlertViewWithAnimated:(BOOL)animated;

@end