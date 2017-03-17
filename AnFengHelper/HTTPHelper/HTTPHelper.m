//
//  HTTPHelper.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/15.
//  Copyright © 2017年 AnFen. All rights reserved.

#import <Foundation/Foundation.h>
#import "HTTPHelper.h"
#import <objc/runtime.h>

static NSString * const ANFAN_APPID = @"2";
static NSString * const ANFAN_RETAILERID = @"1";
static NSString * const DESRSA_PRIVATE_KEY = @"ebe89a4c54f35e59ebe89a4c";

@interface HTTPArgs : NSObject

@property(nonatomic,copy) NSString * _appid;
@property(nonatomic,copy) NSString * _type;
@property(nonatomic,copy) NSString * _timestamp;
@property(nonatomic,copy) NSString * _rid;
@property(nonatomic,copy) NSString * _sign_type;

@end

static HTTPArgs * _httpArgs = nil;
static dispatch_once_t onceToken;

@implementation HTTPArgs

+(instancetype)shareInstance
{
    @synchronized(self) {
        dispatch_once(&onceToken, ^{
            if (!_httpArgs) {
                _httpArgs = [[HTTPArgs alloc]init];
            }
            
        });
    }
    return _httpArgs;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:1000.f];
        NSInteger index = [date timeIntervalSinceNow];
        self._appid = ANFAN_APPID;
        self._type  = @"json";
        self._timestamp = [NSString stringWithFormat:@"%@",@(labs(index))];
        self._rid = ANFAN_RETAILERID;
        self._sign_type = @"md5";
    }
    return self;
}

@end

static HTTPHelper * _httpHelper = nil;
static dispatch_once_t  once;

@interface HTTPHelper()
@property(nonatomic,strong)HTTPSessionManager * sessionManager;

@end

@implementation HTTPHelper

static NSDictionary * QueryFormateWithParameter(NSDictionary * params)
{
    HTTPArgs * httpArgs = [HTTPArgs shareInstance];
    NSMutableDictionary * param = [[httpArgs keyValues]mutableCopy];
    [param addEntriesFromDictionary:params];
    NSString * pair = [HTTPQueryPair HTTPQueryStringFromParameters:param];
    NSString * args = [NSString stringWithFormat:@"%@&key=%@",pair,DESRSA_PRIVATE_KEY];
    [param setValue:args forKey:@"_sign"];
    return  param;
}

-(HTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager  = [HTTPSessionManager manager];
        _sessionManager  = [_sessionManager initWithBaseURL:[NSURL URLWithString:ServleteConfigPath]];
        _sessionManager.requestSerializer.timeoutInterval = 8.f;
        _sessionManager.requestSerializer  = [HTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [HTTPJSONResponseSerializer serializer];
    }
    return _sessionManager;
}

+(instancetype)shareInstance
{
    @synchronized(self) {
        dispatch_once(&once, ^{
            if (!_httpHelper) {
                _httpHelper = [[HTTPHelper alloc]init];
            }
        });
    }
    return _httpHelper;
}

- (void)getTaskWithPath:(NSString *)path
                 params:(NSDictionary*)params
                success:(OperationSuccessBlock)success
                failure:(OperationFailureBlock)failure
               progress:(OperationProgressBlock)progress
{
    NSDictionary * args =QueryFormateWithParameter(params);
    [self.sessionManager GET:path parameters:args progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"status"]boolValue] ==0) {
                success(@"",ooDetailRecursionAboutJson(responseObject));
            }
            else
            {
                [[OOAlertView shareInstance]pushDialogueType:kDialogueErrorType dialogueText:responseObject[@"msg"]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)postTaskWithPath:(NSString *)path
                  params:(NSDictionary*)params
                 success:(OperationSuccessBlock)success
                 failure:(OperationFailureBlock)failure
                progress:(OperationProgressBlock)progress
{
    NSDictionary * agrs = QueryFormateWithParameter(params);
    [self.sessionManager POST:path parameters:agrs progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"status"]boolValue] ==0) {
                success(@"",ooDetailRecursionAboutJson(responseObject));
            }
            else
            {
                [[OOAlertView shareInstance]pushDialogueType:kDialogueErrorType dialogueText:responseObject[@"msg"]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)uploadTaskWith:(NSString *)path
             fileDatas:(NSDictionary*)files
               success:(OperationSuccessBlock)success
               failure:(OperationFailureBlock)failure
         uploadProgess:(OperationProgressBlock)progress
{
    [self.sessionManager POST:path parameters:nil constructingBodyWithBlock:^(id<HTTPMultipartFormData> formData) {
        if (files){
            [files enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * stop) {
                if ([key isEqualToString:@"file"]) {
                    NSString * fileName =[NSString stringWithFormat:@"file.jpg"];
                    [formData appendPartWithFileData:obj name:key fileName:fileName mimeType:@"image/jpeg"];
                }
                else
                {
                    
                    NSData * jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];
                    [formData appendPartWithFormData:jsonData name:key];
                }
            }];
        }
    } progress:^(NSProgress * uploadProgress) {
        
    } success:^(NSURLSessionDataTask * task, id responseObject) {
        if ([responseObject[@"status"]boolValue]==0) {
            
            success(responseObject[@"msg"],ooDetailRecursionAboutJson(responseObject));
        }
        else
        {
            [[OOAlertView shareInstance]pushDialogueType:kDialogueErrorType dialogueText:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        
    }];

    
}

- (void)downloadTaskWith:(NSString *)path
                savePath:(NSString*)save
                 success:(OperationSuccessBlock)success
                 failure:(OperationFailureBlock)failure
           uploadProgess:(OperationProgressBlock)progress
{
    HTTPRequestSerializer * serializer = [HTTPRequestSerializer serializer];
    self.sessionManager.requestSerializer = serializer;
    NSMutableURLRequest * request =[self.sessionManager.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:path relativeToURL:self.sessionManager.baseURL]absoluteString] parameters:nil error:nil];
    
    __block NSURL * appropriateUrl = [NSURL URLWithString:save];
    
    NSURLSessionDownloadTask * task = [self.sessionManager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
            {
                NSURL * documentDirectoryURL = [[NSFileManager defaultManager]URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:appropriateUrl create:NO error:nil];
                      return [documentDirectoryURL URLByAppendingPathComponent:save];
                    }completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
                    {
                        success([NSString stringWithFormat:@"%@",response.URL],filePath);
                }];
    [self.sessionManager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite)
     {
         progress(bytesWritten/totalBytesExpectedToWrite);
     }];
    [task resume];
}

static id ooDetailRecursionAboutJson(id object);
static id ooDetailRecursionAboutJson(id object)
{
    // 判断json数据返回的是什么类型： NSString ｜ NSArray ｜ NSDictionary
    // 判断json数据的类型是NSString时：
    id filterNullContrainerObject;
    if (![object isKindOfClass:[NSArray class]]
        &&![object isKindOfClass:[NSDictionary class]])
    {
        id  result = object;
        if ([result isKindOfClass:[NSNull class]])
        {
            result = @"";
        }
        else if ([result isKindOfClass:[NSString class]]
                  &&(!result||[result isEqualToString:@""]))
        {
            result = @"";
        }
        filterNullContrainerObject  = (NSString*)result;
    }
    // 判断json数据的类型是NSArray时：
    else if ([object isKindOfClass:[NSArray class]])
    {
        NSArray * sourceArray =(NSArray*)object;
        if (sourceArray.count ==0 || !sourceArray)
        {
            filterNullContrainerObject = @[];
        }
        NSMutableArray *filterArray  = [NSMutableArray array];
        [sourceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
              NSString * filter = ooDetailRecursionAboutJson(obj);
             [filterArray addObject:filter];
         }];
        filterNullContrainerObject  = filterArray;
    }
    // 判断json数据的类型是NSDictionary时：
    else if ([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *sourceDictionary = (NSDictionary*)object;
        NSMutableDictionary *sourcefilterDictionary = [NSMutableDictionary dictionary];
        if (!sourceDictionary || sourceDictionary.count ==0)
        {
            filterNullContrainerObject = @{};
        }
        [sourceDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop)
         {
             id object = ooDetailRecursionAboutJson(obj);
             [sourcefilterDictionary setValue:object forKey:key];
         }];
        filterNullContrainerObject  = sourcefilterDictionary;
    }
    return filterNullContrainerObject;
}
@end
