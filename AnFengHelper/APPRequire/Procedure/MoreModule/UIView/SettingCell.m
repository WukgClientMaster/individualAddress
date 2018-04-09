//
//  SettingCell.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/10.
//  Copyright © 2017年 AnFen. All rights reserved.

#import "SettingCell.h"
#import "APPItemConfig.h"
#import "YYTextFieldManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SettingCell ()

@property(nonatomic,strong) UISwitch * switchItem;
@property(nonatomic,readwrite,strong) APPTextField * textField;
@property(nonatomic,strong) UILabel * label;

@end

@implementation SettingCell
-(UILabel *)label{
    _label = ({
        if (!_label) {
            _label = [UILabel new];
            _label.textColor = [UIColor darkGrayColor];
            _label.textAlignment = NSTextAlignmentLeft;
            _label.font = [UIFont systemFontOfSize:APPAdapterScaleFontFamily(14.f)];
            
        }
        _label;
    });
    return _label;
}

-(APPTextField *)textField{
    _textField = ({
        if (!_textField) {
            _textField = [[APPTextField alloc]initWithFrame:CGRectZero];
            _textField.textColor = [UIColor darkGrayColor];
            _textField.font = [UIFont systemFontOfSize:APPAdapterScaleFontFamily(14.f)];
            _textField.layer.cornerRadius = APPAdapterAdjustHeight(6.f);
            _textField.layer.borderColor = AdapterColor(220, 220, 220).CGColor;
            _textField.layer.borderWidth = 1.f;
            _textField.layer.masksToBounds = YES;
            _textField.backgroundColor = [UIColor whiteColor];
        }
        _textField;
    });
    return _textField;
}


-(UISwitch *)switchItem{
    _switchItem = ({
        if (!_switchItem) {
             _switchItem  = [[UISwitch alloc]initWithFrame:CGRectZero];
            [_switchItem addTarget:self action:@selector(changedValue:) forControlEvents:UIControlEventValueChanged];
        }
        _switchItem;
    });
    return _switchItem;
}

-(void)changedValue:(UISwitch*)sw{
    if (self.cellData && [self.cellData isKindOfClass:[APPSwitchItem class]]) {
        APPSwitchItem * switchItem = (APPSwitchItem*)self.cellData;
        sw.on = !sw.on;
        NSString * onOff = [NSString stringWithFormat:@"%d",sw.on];
        [[NSUserDefaults standardUserDefaults]setObject:onOff forKey:switchItem.title];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

-(void)buildContentView{
    [super buildContentView];
    __weak  typeof(self)weakSelf = self;
    [self.label setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(APPAdapterScaleWith(20.f));
    make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY).with.offset(0.f);
    }];
}

-(void)setContentViewStyle{
    [super setContentViewStyle];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)removeSubViewConditionCellData{
    if ([self.cellData isKindOfClass:[APPArrowItem class]]) {
        [self.textField removeFromSuperview];
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        [self.switchItem removeFromSuperview];
    }else if ([self.cellData isKindOfClass:[APPSwitchItem class]]){
        [self.textField removeFromSuperview];
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
        self.accessoryType = UITableViewCellAccessoryNone;
    }else if ([self.cellData isKindOfClass:[APPCustomItem class]]){
        [self.switchItem removeFromSuperview];
        self.accessoryType = UITableViewCellAccessoryNone;
        [self.textField removeFromSuperview];
        [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        }];
    }else if ([self.cellData isKindOfClass:[APPCUSTextFieldViewItem class]]){
        [self.switchItem removeFromSuperview];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

-(void)loadContentData{
    if (!self.cellData) return;
    __weak  typeof(self)weakSelf = self;
    [self removeSubViewConditionCellData];
    if ([self.cellData isKindOfClass:[APPArrowItem class]]){
        APPArrowItem * item = (APPArrowItem*)self.cellData;
        self.label.text = item.title;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   else if ([self.cellData isKindOfClass:[APPSwitchItem class]]){
        APPSwitchItem * item = (APPSwitchItem*)self.cellData;
        self.label.text = item.title;
        NSString * onOff =[[NSUserDefaults standardUserDefaults]objectForKey:item.title];
        self.switchItem.on = [onOff integerValue];
        [self.contentView addSubview:self.switchItem];
        [self.switchItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY).with.offset(0.f);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-APPAdapterScaleWith(20.f));
        }];
    }
   else if ([self.cellData isKindOfClass:[APPCustomItem class]]) {
        APPCustomItem * item = (APPCustomItem*)self.cellData;
        self.label.text = item.title;
    }
   else if ([self.cellData isKindOfClass:[APPCUSTextFieldViewItem class]]){
        APPCUSTextFieldViewItem * item = (APPCUSTextFieldViewItem*)self.cellData;
        self.label.text = item.title;
        self.textField.placeholder = item.configJson[PLACEHOLDER];
        self.textField.keyboardType = [item.configJson[KEYBOARD_TYPE]integerValue];
        self.textField.text = (item.text.length == 0) ? @"": item.text;
        [self.contentView addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(APPAdapterAdjustHeight(35.f)));
            make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
            make.left.mas_equalTo(weakSelf.contentView. mas_left).with.offset(APPAdapterScaleWith(120.f));
         make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-APPAdapterScaleWith(40.f));
        }];
       [self.textField addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
    }
}

-(void)valueChange:(APPTextField*)textField{
    NSString * text = textField.text;
    NSInteger  length = text.length;
    NSInteger minimum = 0;
    NSInteger maximum = 0;
    if ([self.cellData isKindOfClass:[APPCUSTextFieldViewItem class]]) {
        APPCUSTextFieldViewItem * item = (APPCUSTextFieldViewItem*)self.cellData;
        NSArray * rangs = item.configJson[TEXT_RANGE];
        minimum = [rangs[0]integerValue];
        maximum = [[rangs lastObject]integerValue];
        if (length >= maximum){
            NSString * text = textField.text;
            textField.text = [text substringWithRange:NSMakeRange(0, maximum)];
        item.text = textField.text;
        }
    }
}

@end
