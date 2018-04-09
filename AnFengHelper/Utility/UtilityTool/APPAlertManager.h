//
//  APPAlertManager.h
//  AttractionsVoice
//
//  Created by 吴可高 on 16/7/17.
//  Copyright © 2016年 com.BlueMobi.Lqw. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^AppAlertCompleteHandleBlock)(UIAlertAction* action);

@interface APPAlertManager : NSObject

@property (strong, nonatomic) UIColor * Color;
@property (strong, nonatomic,readonly) UIAlertController * alertController;
// preferredStyle
-(UIAlertController*)alertViewWithTitle:(NSString*)title options:(NSArray*)items completeHandle:(AppAlertCompleteHandleBlock)block ;

-(UIAlertController *)alertViewWithTitle:(NSString *)title options:(NSArray *)items completeHandle:(AppAlertCompleteHandleBlock)block preferredStyle:(UIAlertControllerStyle)preferredStyle;

@end
