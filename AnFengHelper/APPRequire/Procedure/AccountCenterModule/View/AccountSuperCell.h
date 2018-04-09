//
//  AccountSuperCell.h
//  AnFengHelper
//
//  Created by 智享城市iOS开发 on 2018/4/7.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "OOTableCell.h"
#import "CellViewModel.h"

@interface AccountSuperCell : OOTableCell

@property(nonatomic,readonly,strong) UIImageView * avatarImageView;
@property(nonatomic,readonly,strong) UILabel * desc_label;
@property(nonatomic,readonly,strong) UILabel * price_label;

-(void)buildContentView;

-(void)setContentViewStyle;

-(void)loadContentData;

@end
