//
//  CumsterAlertManager.h
//  SleepWell
//
//  Created by 苏荷 on 16/8/2.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^AppAlertCompleteHandleBlock)(UIAlertAction* action);
@interface CumsterAlertManager : NSObject

@property (strong, nonatomic) UIColor * Color;
@property (strong, nonatomic,readonly) UIAlertController * alertController;
// preferredStyle

-(UIAlertController *)alertViewWithTitle:(NSString *)title options:(NSArray *)items withColor:(UIColor*)color  completeHandle:(AppAlertCompleteHandleBlock)block preferredStyle:(UIAlertControllerStyle)preferredStyle;

@end
