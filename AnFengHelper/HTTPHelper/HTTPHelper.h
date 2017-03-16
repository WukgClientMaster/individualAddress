//
//  HTTPHelper.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/15.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OperationSuccessBlock)(NSString* msg,id response);
typedef void (^OperationFailureBlock)(NSError*error);
typedef void (^OperationProgressBlock)(int64_t progress);

@interface HTTPHelper : NSObject

+(instancetype)shareInstance;

- (void)getTaskWithPath:(NSString *)path
                        params:(NSDictionary*)params
                       success:(OperationSuccessBlock)success
                failure:(OperationFailureBlock)failure
               progress:(OperationProgressBlock)progress;

- (void)postTaskWithPath:(NSString *)path
                         params:(NSDictionary*)params
                        success:(OperationSuccessBlock)success
                        failure:(OperationFailureBlock)failure
                       progress:(OperationProgressBlock)progress;

- (void)uploadTaskWith:(NSString *)path
                    fileDatas:(NSDictionary*)files
                      success:(OperationSuccessBlock)success
                      failure:(OperationFailureBlock)failure
                uploadProgess:(OperationProgressBlock)progress;

- (void)downloadTaskWith:(NSString *)path
                       savePath:(NSString*)save
                        success:(OperationSuccessBlock)success
                        failure:(OperationFailureBlock)failure
                  uploadProgess:(OperationProgressBlock)progress;
@end
