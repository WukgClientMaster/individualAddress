//
//  CAEffectTransition.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/19.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EffectTransitionConfig;
@interface CAEffectTransition : NSObject

+(CATransition*) effectTransitionConfig:(EffectTransitionConfig* )effectConfig;

@end
