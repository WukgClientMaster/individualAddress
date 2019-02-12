//
//  TX_WKG_Photo_TextEdit_PopOverView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/6/6.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TX_WKG_TEXT_EDIT_POP_Optional_Callback)(NSString * type, NSString * text);
@interface TX_WKG_Photo_TextEdit_PopOverView : UIView
@property (strong,readonly,nonatomic) UITextView  * textView;
@property (copy, nonatomic) TX_WKG_TEXT_EDIT_POP_Optional_Callback  optionalCallback;

- (instancetype)initWithFrame:(CGRect)frame text:(NSString*)text;

@end
