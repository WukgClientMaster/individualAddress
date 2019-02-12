//
//  AssetOptionalTopView.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/9/22.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AssertOptionalCallback)(NSString* title);
@interface AssetOptionalTopView : UIView
@property (copy, nonatomic) AssertOptionalCallback callback;
-(void)setCategoryWithString:(NSString*)string;
-(void)setCategoryViewsHidden:(BOOL)hidden;

@end
