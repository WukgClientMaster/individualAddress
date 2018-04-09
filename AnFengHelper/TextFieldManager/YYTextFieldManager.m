//
//  YYTextFieldManager.m
//  smarket
//
//  Created by client on 2017/6/23.
//  Copyright © 2017年 原研三品. All rights reserved.
//

#import "YYTextFieldManager.h"

@interface YYTextFieldManager()<UITextFieldDelegate>
@property (nonatomic, assign) CGFloat minimumValue;
@property (nonatomic, assign) CGFloat maximumValue;
@property (nonatomic, strong) APPTextField * textField;
@property (nonatomic, copy) ComplateHander hander;
@property (nonatomic, strong) NSMutableArray * observers;
@end
static YYTextFieldManager * _manager = nil;
void * kTextFieldManagerKeyPath = &kTextFieldManagerKeyPath;

dispatch_once_t  once;
@implementation YYTextFieldManager

+(instancetype)shareInstance;
{
    dispatch_once(&once, ^{
        if (!_manager) {
            _manager  = [[YYTextFieldManager alloc]init];
        }
    });
    return _manager;
}

-(NSMutableArray *)observers{
    _observers = ({
        if (!_observers) {
            _observers  = [NSMutableArray array];
        }
        _observers;
    });
    return _observers;
}

-(void)removeObserverTextField:(APPTextField*)textField keypath:(NSString*)path{
    if (textField == nil)return;
    if (![self.observers containsObject:textField])return;
    [self.observers removeObject:textField];
}

-(void)textFieldObserverConditionMinimum:(NSInteger)minimumValue maximumValue:(NSInteger)maximum{
    self.minimumValue = minimumValue;
    self.maximumValue = maximum;
}

-(void)addobserverTextField:(APPTextField*)textField keypath:(NSString*)path complateHander:(ComplateHander)hander{
    if (!textField){return;}
    _hander = hander;
    textField.delegate = self;
    NSArray * item = @[textField,@(self.minimumValue),@(self.maximumValue)];
    if (self.observers.count == 0) {
        [self.observers addObject:item];
    }
    for (int i = 0; i < self.observers.count; i++) {
        NSArray * items  = self.observers[i];
        APPTextField * tf = (APPTextField*)items[0];
        if ([tf isEqual:textField]) {
            continue;
        }else if (![tf isEqual:textField] && i ==    self.observers.count-1){
            [self.observers addObject:item];
        }
    }
    [textField addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)valueChange:(APPTextField*)textField{
    NSString * text = textField.text;
    NSInteger  length = text.length;
    __weak  typeof(self)weakSelf = self;
    __block NSInteger minimum = 0;
    __block NSInteger maximum = 0;
    [self.observers enumerateObjectsUsingBlock:^(NSArray* items , NSUInteger idx, BOOL * _Nonnull stop) {
        __strong  typeof(weakSelf)strongSelf = weakSelf;
        APPTextField * tf = items[0];
        if ([tf isEqual:textField]) {
            strongSelf.textField = textField;
            minimum = [items[1]integerValue];
            maximum = [items[2]integerValue];
            *stop = YES;
        }
    }];
    if (length > minimum && length < maximum) {
        __strong  typeof(weakSelf)strongSelf = weakSelf;
        if (_hander) {
            _hander(strongSelf.textField,@"YES",@"");
        }
    }
    else if (length < minimum){
        if (_hander){
            __strong typeof(weakSelf)strongSelf = weakSelf;
            _hander(strongSelf.textField,@"NO",@"minimum");
        }
    }
    else if (length >= maximum){
        __strong typeof(weakSelf)strongSelf = weakSelf;
        NSString * text = strongSelf.textField.text;
        strongSelf.textField.text = [text substringWithRange:NSMakeRange(0, maximum)];
        _hander(strongSelf.textField,@"NO",@"maximum");
    }
}

-(void)textFieldDidBeginEditing:(APPTextField *)textField{

}

-(void)textFieldDidEndEditing:(APPTextField *)textField{
    //这个方法是待优化：1提供接口让外部帮忙实现。 2内部虚拟调用：提供json数据{字段和方法名}。
}

-(void)clearAllObservers{
    [self.observers removeAllObjects];
}

@end
