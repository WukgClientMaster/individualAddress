//
//  OOWebViewProgess.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/5/4.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OOWebViewProgess;

extern const float kInitialProgressValue;
extern const float kInteractiveProgressValue;
extern const float kFinalProgressValue;

typedef void (^OOWebViewProgressBlock)(float progress);
//
@protocol OOWebViewProgressDelegate;

@interface OOWebViewProgess : NSObject

@property (nonatomic, weak) id <OOWebViewProgressDelegate> progressDelegate;

@property (weak, nonatomic) id <UIWebViewDelegate> webProxyDelegate;

@property (nonatomic, copy) OOWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0
- (void)reset;
@end

@protocol OOWebViewProgressDelegate <NSObject>

- (void)webViewProgress:(OOWebViewProgess *)webViewProgress updateProgress:(float)progress;
@end
