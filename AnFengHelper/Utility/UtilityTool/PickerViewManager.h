//
//  PickerViewManager.h
//  SleepWell
//
//  Created by 吴可高 on 16/7/27.
//  Copyright © 2016年 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^PickerViewResponseBlock)(NSString* item1);

@interface PickerViewManager : NSObject
@property (strong, nonatomic,readonly) UIPickerView *pickerView;
@property (strong, nonatomic) NSArray * items;

-(instancetype)initWithPickerViewWithSources:(NSArray*)sources andFrame:(CGRect)frame block:(PickerViewResponseBlock)block;
@end
