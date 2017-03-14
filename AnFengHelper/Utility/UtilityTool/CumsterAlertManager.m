//
//  CumsterAlertManager.m
//  SleepWell
//
//  Created by 苏荷 on 16/8/2.
//  Copyright © 2016年 BM. All rights reserved.
//

#import "CumsterAlertManager.h"
@interface CumsterAlertManager ()

@property (copy, nonatomic) NSString * titleMessage;
@property (strong, nonatomic) NSArray * options;

@property (strong, nonatomic) UIAlertController * alertController;

@property (copy, nonatomic) AppAlertCompleteHandleBlock completeHandleBlock;
@property (assign, nonatomic) UIAlertControllerStyle preferredStyle;
@end

@implementation CumsterAlertManager

-(UIAlertController*)alertViewWithTitle:(NSString *)title options:(NSArray *)items withColor:(UIColor*)color  completeHandle:(AppAlertCompleteHandleBlock)block preferredStyle:(UIAlertControllerStyle)preferredStyle ;
{
    _titleMessage = title;
    _options = items;
    _Color=color;
    _completeHandleBlock = block;
    _preferredStyle  = preferredStyle;
    return self.alertController;
}

-(UIAlertController *)alertController
{
    _alertController =({
        UIAlertControllerStyle style = _preferredStyle  ? UIAlertControllerStyleAlert : _preferredStyle;
        _alertController = [UIAlertController alertControllerWithTitle:nil message:_titleMessage preferredStyle:style];
        for (int i = 0; i < _options.count; i++) {
            UIAlertActionStyle  actionStyle =  i == _options.count -1  ?  UIAlertActionStyleCancel : UIAlertActionStyleDefault;
            UIAlertAction * action = [UIAlertAction actionWithTitle:_options[i] style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
                _completeHandleBlock(action);
            }];
            [action setValue:_Color forKey:@"titleTextColor"];
            [_alertController addAction:action];
        }
        _alertController;
    });
    
    return _alertController;
}

@end
