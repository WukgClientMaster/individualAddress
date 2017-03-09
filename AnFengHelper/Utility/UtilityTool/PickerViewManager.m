//
//  PickerViewManager.m
//  SleepWell
//
//  Created by 吴可高 on 16/7/27.
//  Copyright © 2016年 BM. All rights reserved.
//

#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width  [UIScreen mainScreen].bounds.size.width

#import "PickerViewManager.h"

static PickerViewManager * _pickerViewManager = nil;

@interface PickerViewManager ()<UIPickerViewDataSource,UIPickerViewDelegate,UIPickerViewAccessibilityDelegate>
{
     CGRect _pickerViewFrame;
}
@property (strong, nonatomic,readwrite) UIPickerView *pickerView;
@property (copy, nonatomic) PickerViewResponseBlock  block;

@end

@implementation PickerViewManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        if (!_pickerViewManager) {
            _pickerViewManager  = [[PickerViewManager alloc]init];
        }
    }
    return self;
}

-(instancetype)initWithPickerViewWithSources:(NSArray*)sources andFrame:(CGRect)frame block:(PickerViewResponseBlock)block;
{
    if (self = [super init]) {
        _block = block;
        _pickerViewFrame = frame;
        _items = sources;
        [self setUp];
    }
    return self;
}

-(void)setUp
{
    [_pickerView selectRow:0 inComponent:0 animated:YES];
    [_pickerView reloadAllComponents];
}

-(UIPickerView *)pickerView
{
    _pickerView = ({
        if (!_pickerView) {
            _pickerView  = [[UIPickerView alloc]initWithFrame:_pickerViewFrame];
            _pickerView.delegate   = self;
            _pickerView.dataSource = self;
            _pickerView.accessibilityNavigationStyle = UIAccessibilityNavigationStyleSeparate;
        }
        _pickerView;
    });
    return _pickerView;
}
-(void)setItems:(NSArray *)items
{
    _items = items;
    [_pickerView reloadAllComponents];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (component ==0) {
        return _items.count;
    }
    return 0;
}

#pragma mark -UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kScreen_Width/2.f;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35.f;
}
- ( NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    if (component ==0)
    {
        return _items[row];
    }
    return nil;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:( UIView *)view;
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment=NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        pickerLabel.textColor = [UIColor grayColor];
        pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    }
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    UIView * selectedView = [pickerView viewForRow:row forComponent:component];
    if ([selectedView isKindOfClass:[UILabel class]]) {
        UILabel * selectedLabel  = (UILabel*)selectedView;
        selectedLabel.textColor  = [UIColor whiteColor];
    }
    if (component ==0) {
        [_pickerView selectRow:0 inComponent:1 animated:YES];
    }
}

-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary * attrDic = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                            NSFontAttributeName:[UIFont systemFontOfSize:14.f]};
    NSAttributedString * attrString =[[NSAttributedString alloc]initWithString:_items[row+1]attributes:attrDic] ;
    return attrString;
}
@end
