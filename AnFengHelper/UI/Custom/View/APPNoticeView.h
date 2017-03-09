//
//  APPNoticeView.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/14.
//  Copyright © 2016年 吴可高. All rights reserved.
//  APP数据信息 Verify Failure 视图

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSInteger,APPNoticeType){
    kAPPNoticeAsynRequestType,//数据请求失败
    kAPPNoticeInterfaceOperationType,// 用户界面编辑不满足条件
};

@interface APPNoticeView : UIView

@property(nonatomic,strong)   UIView  *backgroundView ;
@property (strong, nonatomic) UIButton * titleItemButton;
@property (strong, nonatomic) UILabel  * lineLabel, *descTextLabel;
@property(nonatomic,strong) UIButton *leftBtn,*rightBTn;

+(instancetype)shareInstance;
-(instancetype)initWithTitle:(NSString *)title appNoticeType:(APPNoticeType)type andDesText:(NSString *)textStr;

-(void)appNoticeShow;
-(void)appNoticeRemove;
@end
