//
//  HttpRequestTool.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/6.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequestTool : NSObject

typedef void (^OperationSuccessBlock)(NSString* msg,id response);
typedef void (^OperationFailureBlock)(NSError*error);
typedef void (^OperationProgressBlock)(int64_t progress);

@property (copy, nonatomic) NSString * MIMEType;
@property (copy, nonatomic) NSDictionary * queryKey;
// queryKey[@"query"],queryKey[@"key"],queryKey[@"value"]
/**
 *  queryKey[@"query"] = "/member/updatePerfectInfoDetails"
 *  queryKey[@"key"]   = @"token",@"callPhone",@"passWord"; 其中一个
 *  queryKey[@"value"] = @"token",@"callPhone",@"password" 其中一个键下面的value
 */



AS_SINGLETON(HttpRequestTool)
/*************  HTTPRequest主要包括了AFHTTPRequestOperationManager 和 AFHTTPSessionManager
   ***在什么时候情况下使用  AFHTTPRequestOperationManager 与  AFHTTPSessionManager
 （1）在upload 请使用AFHTTPRequestOperationManager,api自带了 setUploadProgress 方法
  (2)在download 请使用AFHTTPSessionManager 或者这个都可以动态监听下载的进度
 */

/************* AFHTTPRequestOperationManager **********/

- (void)getSessionTaskWithPath:(NSString*)path
                        params:(NSDictionary*)params
                       success:(OperationSuccessBlock)success
                       failure:(OperationFailureBlock)failure;

- (void)postSessionTaskWithPath:(NSString*)path
                         params:(NSDictionary*)params
                        success:(OperationSuccessBlock)success
                        failure:(OperationFailureBlock)failure;

- (void)uploadSessionTaskWith:(NSString*)path
                    fileDatas:(NSDictionary*)files
                      success:(OperationSuccessBlock)success
                      failure:(OperationFailureBlock)failure
                uploadProgess:(OperationProgressBlock)progress;

-(void)downloadSesssionTaskWith:(NSString*)path
                       savePath:(NSString*)save
                        success:(OperationSuccessBlock)success
                        failure:(OperationFailureBlock)failure
                  uploadProgess:(OperationProgressBlock)progress;
@end
