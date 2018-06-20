//
//  TEST1ViewController.m
//  AnFengHelper
//
//  Created by 吴可高 on 2018/5/8.
//  Copyright © 2018年 AnFen. All rights reserved.
//
typedef enum {
    ENUM_KCCDefiner_Type_A =1 <<0,
    ENUM_KCCDefiner_Type_B =1 <<1,
    ENUM_KCCDefiner_Type_C =1 <<2
}ENUM_KCCDefiner_Type;

typedef NS_OPTIONS(NSInteger, Class_Definer_Type){
    KClass_Definer_Type_A = 1 << 0,
    KClass_Definer_Type_B = 1 << 1,
    KClass_Definer_Type_C = 1 << 2,
    KClass_Definer_Type_D = 1 << 3,
};

#import "TEST1ViewController.h"
#import "CGContentView.h"
@interface TEST1ViewController ()
@property(nonatomic,assign) Class_Definer_Type  class_definer_type;
@property(nonatomic,assign) ENUM_KCCDefiner_Type  enum_ccDefiner_Type;
@property(nonatomic,strong) CGContentView * contentView;
@end
@implementation TEST1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadObjectViews];
}

-(void)loadObjectViews{
    _contentView = ({
        _contentView = [[CGContentView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64.f)];
        _contentView;
    });
    [self.view addSubview:_contentView];
}

- (void) logAllFilters {
   
}
-(void)dealloc{
    
}

@end
