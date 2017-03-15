//
//  HTTPSessionManager.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/15.
//  Copyright © 2017年 AnFen. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <TargetConditionals.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "HTTPURLSessionManager.h"
#import "HTTPResponseSerialization.h"
#import "HTTPRequestSerialization.h"

NS_ASSUME_NONNULL_BEGIN
@interface HTTPSessionManager : HTTPURLSessionManager<NSSecureCoding,NSCopying>
@property (readonly, nonatomic, strong) NSURL *baseURL;
@property(nonatomic,strong)HTTPRequestSerializer <HTTPURLRequestSerialization> * requestSerializer;

+ (instancetype)manager;

- (instancetype)initWithBaseURL:(NSURL *)url;

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration;

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:( id)parameters
                      success:( void (^)(NSURLSessionDataTask *task, id  responseObject))success
                      failure:( void (^)(NSURLSessionDataTask *  task, NSError *error))failure;


- (NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:( id)parameters
                              progress:( void (^)(NSProgress *downloadProgress)) downloadProgress
                               success:( void (^)(NSURLSessionDataTask *task, id  responseObject))success
                               failure:( void (^)(NSURLSessionDataTask * task, NSError *error))failure;

- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                             parameters:( id)parameters
                                success:( void (^)(NSURLSessionDataTask *task))success
                                failure:( void (^)(NSURLSessionDataTask *  task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:( id)parameters
                                success:( void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:( void (^)(NSURLSessionDataTask *  task, NSError *error))failure DEPRECATED_ATTRIBUTE;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:( id)parameters
                               progress:( void (^)(NSProgress *uploadProgress)) uploadProgress
                                success:( void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:( void (^)(NSURLSessionDataTask * task, NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:( id)parameters
              constructingBodyWithBlock:( void (^)(id <HTTPMultipartFormData> formData))block
                                success:( void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:( void (^)(NSURLSessionDataTask * task, NSError *error))failure DEPRECATED_ATTRIBUTE;

- ( NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:( id)parameters
              constructingBodyWithBlock:( void (^)(id <HTTPMultipartFormData> formData))block
                               progress:( void (^)(NSProgress *uploadProgress)) uploadProgress
                                success:( void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:( void (^)(NSURLSessionDataTask * task, NSError *error))failure;

- ( NSURLSessionDataTask *)PUT:(NSString *)URLString
                            parameters:( id)parameters
                               success:( void (^)(NSURLSessionDataTask *task, id  responseObject))success
                               failure:( void (^)(NSURLSessionDataTask *  task, NSError *error))failure;


- ( NSURLSessionDataTask *)PATCH:(NSString *)URLString
                              parameters:( id)parameters
                                 success:( void (^)(NSURLSessionDataTask *task, id  responseObject))success
                                 failure:( void (^)(NSURLSessionDataTask *  task, NSError *error))failure;

- ( NSURLSessionDataTask *)DELETE:(NSString *)URLString
                               parameters:( id)parameters
                                  success:( void (^)(NSURLSessionDataTask *task, id  responseObject))success
                                  failure:( void (^)(NSURLSessionDataTask *  task, NSError *error))failure;
@end
NS_ASSUME_NONNULL_END

