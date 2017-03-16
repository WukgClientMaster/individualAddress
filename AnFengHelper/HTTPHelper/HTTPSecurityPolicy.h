//
//  HTTPSecurityPolicy.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/15.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,HTTPSSLPiningMode)
{
    HTTPSSLPiningModeNone,
    HTTPSSLPiningModePublickey,
    HTTPSSLPiningModeCertifivate,
};

@interface HTTPSecurityPolicy : NSObject <NSSecureCoding,NSCopying>
@property(nonatomic,assign) HTTPSSLPiningMode SSLPinningMode;
@property(nonatomic,strong,readonly) NSSet <NSData*> *pinnedCertificates;

@property (nonatomic, assign) BOOL allowInvalidCertificates;
@property (nonatomic, assign) BOOL validatesDomainName;

+ (NSSet <NSData *> *)certificatesInBundle:(NSBundle *)bundle;
+ (instancetype)defaultPolicy;

+ (instancetype)policyWithPinningMode:(HTTPSSLPiningMode)pinningMode;
+ (instancetype)policyWithPinningMode:(HTTPSSLPiningMode)pinningMode withPinnedCertificates:(NSSet <NSData *> *)pinnedCertificates;

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(NSString *)domain;
@end
