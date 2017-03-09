//
//  APPAlertManager.m
//  AttractionsVoice
//
//  Created by 吴可高 on 16/7/17.
//  Copyright © 2016年 com.BlueMobi.Lqw. All rights reserved.
//

#import "APPAlertManager.h"


@interface APPAlertManager ()

@property (copy, nonatomic) NSString * titleMessage;
@property (strong, nonatomic) NSArray * options;

@property (strong, nonatomic) UIAlertController * alertController;

@property (copy, nonatomic) AppAlertCompleteHandleBlock completeHandleBlock;
@property (assign, nonatomic) UIAlertControllerStyle preferredStyle;
@end
@implementation APPAlertManager

-(UIAlertController*)alertViewWithTitle:(NSString*)title options:(NSArray*)items completeHandle:(AppAlertCompleteHandleBlock)block ;
{
    _titleMessage = title;
    _options = items;

    _completeHandleBlock = block;
    _preferredStyle  = UIAlertControllerStyleAlert;
    return self.alertController;
}
-(UIAlertController *)alertViewWithTitle:(NSString *)title options:(NSArray *)items  completeHandle:(AppAlertCompleteHandleBlock)block preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    _titleMessage = title;
    _options = items;
    _completeHandleBlock = block;
    _preferredStyle =  preferredStyle;
    return self.alertController;
}

-(UIAlertController *)alertController
{
    _alertController =({
            UIAlertControllerStyle style = _preferredStyle  ? UIAlertControllerStyleAlert : _preferredStyle;
            _alertController = [UIAlertController alertControllerWithTitle:nil message:_titleMessage preferredStyle:style];
            for (int i = 0; i < _options.count; i++) {
                UIAlertActionStyle  actionStyle =  i == _options.count -1  ?  UIAlertActionStyleCancel : UIAlertActionStyleDefault;
                UIAlertAction * action = [UIAlertAction actionWithTitle:_options[i] style:actionStyle handler:^(UIAlertAction *  action) {
                    _completeHandleBlock(action);
                    
                }];
                if ([action valueForKey:@"titleTextColor"]) {
                    [action setValue:_Color forKey:@"titleTextColor"];
                }
                [_alertController addAction:action];
            }
        _alertController;
    });
    
    return _alertController;
}
@end
