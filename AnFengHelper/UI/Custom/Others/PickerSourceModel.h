//
//  PickerSourceModel.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/5/11.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickerSourceModel : NSObject

@property (copy, nonatomic) NSString * name;
@property (copy, nonatomic) NSString * enName;
@property (copy, nonatomic) NSString * next;
@property (assign, nonatomic) NSInteger idx;
@property (strong, nonatomic) NSArray * twoLevels;
@property (strong, nonatomic) NSArray * threeLevels;
@end
