//
//  IndicatorAnimationProtocol.h
//  smarket
//
//  Created by client on 2017/7/20.
//  Copyright © 2017年 原研三品. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IndicatorAnimationProtocol <NSObject>

- (void)configAnimationAtLayer:(CALayer *)layer withTintColor:(UIColor *)color size:(CGSize)size;

- (void)removeAnimation;

@end
