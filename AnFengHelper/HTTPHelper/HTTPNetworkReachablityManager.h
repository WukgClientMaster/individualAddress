//
//  HTTPNetworkReachablityManager.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/15.
//  Copyright © 2017年 AnFen. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,HTTPNetworkabilityStatus)
{
    HTTPNetworkabilityStatusUnKnown  = -1,
    HTTPNetworkabilityStatusNotReachable,
    HTTPNetworkabilityStatusReachableViaWWAN,
    HTTPNetworkabilityStatusReachableViaWiFi
};
FOUNDATION_EXPORT NSString *const HTTPNetworkingReachabilityDidChangeNotification;
FOUNDATION_EXPORT NSString *const HTTPNetworkingReachabilityNotificationStatusItem;
FOUNDATION_EXPORT NSString *HTTPStringFromNetworkReachabilityStatus(HTTPNetworkabilityStatus status);
@interface HTTPNetworkReachablityManager : NSObject
@property (readonly, nonatomic, assign) HTTPNetworkabilityStatus networkReachabilityStatus;
@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;
@property (readonly, nonatomic, assign, getter = isReachableViaWWAN) BOOL reachableViaWWAN;
@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

+ (instancetype)sharedManager;

+ (instancetype)manager;

+ (instancetype)managerForDomain:(NSString *)domain;

+ (instancetype)managerForAddress:(const void *)address;

- (instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability;

- (void)startMonitoring;

- (void)stopMonitoring;

- (NSString *)localizedNetworkReachabilityStatusString;

- (void)setReachabilityStatusChangeBlock:(nullable void (^)(HTTPNetworkabilityStatus status))block;
@end

NS_ASSUME_NONNULL_END

