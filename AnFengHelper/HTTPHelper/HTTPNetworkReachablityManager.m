//
//  HTTPNetworkReachablityManager.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/15.
//  Copyright © 2017年 AnFen. All rights reserved.

#import "HTTPNetworkReachablityManager.h"
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

NSString * const HTTPNetworkingReachabilityDidChangeNotification = @"com.alamofire.networking.reachability.change";
NSString * const HTTPNetworkingReachabilityNotificationStatusItem = @"AFNetworkingReachabilityNotificationStatusItem";

typedef void (^HTTPNetworkReachabilityStatusBlock)(HTTPNetworkabilityStatus status);

NSString * HTTPStringFromNetworkReachabilityStatus(HTTPNetworkabilityStatus status) {
    switch (status) {
        case HTTPNetworkabilityStatusNotReachable:
            return NSLocalizedStringFromTable(@"Not Reachable", @"AFNetworking", nil);
        case HTTPNetworkabilityStatusReachableViaWWAN:
            return NSLocalizedStringFromTable(@"Reachable via WWAN", @"AFNetworking", nil);
        case HTTPNetworkabilityStatusReachableViaWiFi:
            return NSLocalizedStringFromTable(@"Reachable via WiFi", @"AFNetworking", nil);
        case HTTPNetworkabilityStatusUnKnown:
        default:
            return NSLocalizedStringFromTable(@"Unknown", @"AFNetworking", nil);
    }
}

static HTTPNetworkabilityStatus HTTPNetworkReachabilityStatusForFlags(SCNetworkReachabilityFlags flags) {
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
    BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
    BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));
    HTTPNetworkabilityStatus status = HTTPNetworkabilityStatusUnKnown;
    if (isNetworkReachable == NO) {
        status = HTTPNetworkabilityStatusNotReachable;
    }
#if	TARGET_OS_IPHONE
    else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
        status = HTTPNetworkabilityStatusReachableViaWWAN;
    }
#endif
    else {
        status = HTTPNetworkabilityStatusReachableViaWiFi;
    }
    return status;
}

static void HTTPPostReachabilityStatusChange(SCNetworkReachabilityFlags flags, HTTPNetworkReachabilityStatusBlock block) {
    HTTPNetworkabilityStatus status = HTTPNetworkReachabilityStatusForFlags(flags);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block(status);
        }
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSDictionary *userInfo = @{ HTTPNetworkingReachabilityNotificationStatusItem: @(status) };
        [notificationCenter postNotificationName:HTTPNetworkingReachabilityDidChangeNotification object:nil userInfo:userInfo];
    });
}

static void HTTPNetworkReachabilityCallback(SCNetworkReachabilityRef __unused target, SCNetworkReachabilityFlags flags, void *info) {
    HTTPPostReachabilityStatusChange(flags, (__bridge HTTPNetworkReachabilityStatusBlock)info);
}


static const void * HTTPNetworkReachabilityRetainCallback(const void *info) {
    return Block_copy(info);
}

static void HTTPNetworkReachabilityReleaseCallback(const void *info) {
    if (info) {
        Block_release(info);
    }
}

@interface HTTPNetworkReachablityManager ()
@property (readwrite, nonatomic, strong) id networkReachability;
@property (readwrite, nonatomic, assign) HTTPNetworkabilityStatus networkReachabilityStatus;
@property (readwrite, nonatomic, copy) HTTPNetworkReachabilityStatusBlock networkReachabilityStatusBlock;

@end

@implementation HTTPNetworkReachablityManager
+ (instancetype)sharedManager {
    static HTTPNetworkReachablityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [self manager];
    });
    
    return _sharedManager;
}

#ifndef __clang_analyzer__
+ (instancetype)managerForDomain:(NSString *)domain {
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [domain UTF8String]);
    
    HTTPNetworkReachablityManager *manager = [[self alloc] initWithReachability:reachability];
    
    return manager;
}
#endif

#ifndef __clang_analyzer__
+ (instancetype)managerForAddress:(const void *)address {
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)address);
    HTTPNetworkReachablityManager *manager = [[self alloc] initWithReachability:reachability];
    
    return manager;
}
#endif

+ (instancetype)manager
{
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000) || (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    struct sockaddr_in6 address;
    bzero(&address, sizeof(address));
    address.sin6_len = sizeof(address);
    address.sin6_family = AF_INET6;
#else
    struct sockaddr_in address;
    bzero(&address, sizeof(address));
    address.sin_len = sizeof(address);
    address.sin_family = AF_INET;
#endif
    return [self managerForAddress:&address];
}

- (instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.networkReachability = CFBridgingRelease(reachability);
    self.networkReachabilityStatus = HTTPNetworkabilityStatusUnKnown;
    
    return self;
}

- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

- (void)dealloc {
    [self stopMonitoring];
}

#pragma mark -

- (BOOL)isReachable {
    return [self isReachableViaWWAN] || [self isReachableViaWiFi];
}

- (BOOL)isReachableViaWWAN {
    return self.networkReachabilityStatus == HTTPNetworkabilityStatusReachableViaWWAN;
}

- (BOOL)isReachableViaWiFi {
    return self.networkReachabilityStatus == HTTPNetworkabilityStatusReachableViaWiFi;
}

#pragma mark -
- (void)startMonitoring {
    [self stopMonitoring];
    
    if (!self.networkReachability) {
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    HTTPNetworkReachabilityStatusBlock callback = ^(HTTPNetworkabilityStatus status) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.networkReachabilityStatus = status;
        if (strongSelf.networkReachabilityStatusBlock) {
            strongSelf.networkReachabilityStatusBlock(status);
        }
    };
    id networkReachability = self.networkReachability;
    SCNetworkReachabilityContext context = {0, (__bridge void *)callback, HTTPNetworkReachabilityRetainCallback, HTTPNetworkReachabilityReleaseCallback, NULL};
    SCNetworkReachabilitySetCallback((__bridge SCNetworkReachabilityRef)networkReachability, HTTPNetworkReachabilityCallback, &context);
    SCNetworkReachabilityScheduleWithRunLoop((__bridge SCNetworkReachabilityRef)networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags((__bridge SCNetworkReachabilityRef)networkReachability, &flags)) {
             HTTPPostReachabilityStatusChange(flags, callback);
        }
    });
}

- (void)stopMonitoring {
    if (!self.networkReachability) {
        return;
    }
    SCNetworkReachabilityUnscheduleFromRunLoop((__bridge SCNetworkReachabilityRef)self.networkReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
}
#pragma mark -
- (NSString *)localizedNetworkReachabilityStatusString {
    return HTTPStringFromNetworkReachabilityStatus(self.networkReachabilityStatus);
}
#pragma mark -
- (void)setReachabilityStatusChangeBlock:(void (^)(HTTPNetworkabilityStatus status))block {
    self.networkReachabilityStatusBlock = block;
}
#pragma mark - NSKeyValueObserving
+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key isEqualToString:@"reachable"] || [key isEqualToString:@"reachableViaWWAN"] || [key isEqualToString:@"reachableViaWiFi"]) {
        return [NSSet setWithObject:@"networkReachabilityStatus"];
    }
    return [super keyPathsForValuesAffectingValueForKey:key];
}

@end
