//
//  PolyActivity.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/5/4.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, PolyActivityType)
{
    kPolyActivityTypeLink,
    kPolyActivityTypeSafari,
    kPolyActivityTypeChrome,
    kPolyActivityTypeOpera,
    kPolyActivityTypeDolphin
};

@interface PolyActivity : UIActivity

- (instancetype)initWithActivityType:(PolyActivityType)type;
+ (instancetype)activityWithType:(PolyActivityType)type;

@end
