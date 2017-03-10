//
//  SettingCell.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "SettingCell.h"
#import "APPItemConfig.h"

@interface SettingCell ()

@property(nonatomic,strong) UISwitch * switchItem;
@end

@implementation SettingCell


-(UISwitch *)switchItem
{
    _switchItem = ({
        if (!_switchItem) {
            _switchItem  = [[UISwitch alloc]initWithFrame:CGRectZero];
            [_switchItem addTarget:self action:@selector(changedValue:) forControlEvents:UIControlEventValueChanged];
            _switchItem.frame = CGRectMake(CGRectGetMidX(self.contentView.frame) + kScreen_Width/3.0f, CGRectGetMinY(self.contentView.frame) + 8, 0, 0);
        }
        _switchItem;
    });
    return _switchItem;
}
-(void)changedValue:(UISwitch*)sw
{
    

}

-(void)buildContentView
{
    
}
-(void)setContentViewStyle
{

}

-(void)loadContentData
{
    if (!self.cellData) return;
    if ([self.cellData isKindOfClass:[APPArrowItem class]])
    {
        APPArrowItem * item = (APPArrowItem*)self.cellData;
        self.textLabel.text = item.title;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if ([self.cellData isKindOfClass:[APPSwitchItem class]])
    {
        APPSwitchItem * item = (APPSwitchItem*)self.cellData;
        self.textLabel.text = item.title;
        [self.contentView addSubview:self.switchItem];
    }
    else if ([self.cellData isKindOfClass:[APPItem class]]) {
        APPItem * item = (APPItem*)self.cellData;
        self.textLabel.text = item.title;
    }
}
@end
