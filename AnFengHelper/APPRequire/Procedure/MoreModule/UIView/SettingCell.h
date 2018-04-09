//
//  SettingCell.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "OOTableCell.h"

@interface SettingCell : OOTableCell
@property(nonatomic,readonly,strong) APPTextField * textField;

-(void)buildContentView;

-(void)setContentViewStyle;

-(void)loadContentData;

@end
