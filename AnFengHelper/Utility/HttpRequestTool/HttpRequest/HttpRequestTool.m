
//
//  HttpRequestTool.m
//  LearnObjectiveC
//  Created by 吴可高 on 16/4/6.
//  Copyright © 2016年 吴可高. All rights reserved.

#import "HttpRequestTool.h"
#import "AFHTTPSessionManager.h"
#import "AFURLRequestSerialization.h"
#import <objc/runtime.h>

@interface HttpRequestTool ()
@property (strong, nonatomic) AFHTTPSessionManager * sessionManager;
@property (strong, nonatomic) AFHTTPRequestSerializer * serializer;
@end

@implementation HttpRequestTool
DEF_SINGLETON(HttpRequestTool)

-(void)setMIMEType:(NSString *)MIMEType
{
    objc_setAssociatedObject(self, @selector(setMIMEType:), MIMEType, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)setQueryKey:(NSDictionary *)queryKey
{
    objc_setAssociatedObject(self, @selector(setQueryKey:), queryKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSString *)MIMEType
{
  return  objc_getAssociatedObject(self, @selector(setMIMEType:));
}
-(NSDictionary *)queryKey
{
    return objc_getAssociatedObject(self, @selector(setQueryKey:));
}
/*************  AFHTTPSessionManager  **********/
- (void)getSessionTaskWithPath:(NSString*)path
                        params:(NSDictionary*)params
                       success:(OperationSuccessBlock)success
                       failure:(OperationFailureBlock)failure;
{
    /*
    [self.sessionManager GET:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"status"]boolValue]==0) {
            success(@"",ooDetailRecursionAboutJson(responseObject));
        }
        else
        {
            [[OOAlertView shareInstance]pushDialogueType:kDialogueErrorType dialogueText:responseObject[@"msg"]];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);

    }];
    */
}

- (void)postSessionTaskWithPath:(NSString*)path
                         params:(NSDictionary*)params
                        success:(OperationSuccessBlock)success
                        failure:(OperationFailureBlock)failure;
{
    NSString * MIMEType = [self valueForKey:@"MIMEType"];
    NSString * urlString;
    if ([MIMEType isEqualToString:@"application/json"])
    {
        NSDictionary * queryKey = [self valueForKey:@"queryKey"];
        if (queryKey) {
           urlString = [NSString stringWithFormat:@"%@%@?%@=%@",path,queryKey[@"query"],queryKey[@"key"],queryKey[@"value"]];
        }
    }
    else
    {
        urlString = path;
    
    }
 
    [self.sessionManager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
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

- (void)uploadSessionTaskWith:(NSString*)path
                    fileDatas:(NSDictionary*)files
                      success:(OperationSuccessBlock)success
                      failure:(OperationFailureBlock)failure
                uploadProgess:(OperationProgressBlock)progress;
{
    [self.sessionManager POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         if (files){
             [files enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
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
      } progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         if ([responseObject[@"status"]boolValue]==0) {
             
             success(responseObject[@"msg"],ooDetailRecursionAboutJson(responseObject));
         }
         else
         {
              [[OOAlertView shareInstance]pushDialogueType:kDialogueErrorType dialogueText:responseObject[@"msg"]];
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
     }];
}

-(void)downloadSesssionTaskWith:(NSString*)path
                       savePath:(NSString*)save
                        success:(OperationSuccessBlock)success
                        failure:(OperationFailureBlock)failure
                  uploadProgess:(OperationProgressBlock)progress;
{
    AFHTTPRequestSerializer * serializer = [AFHTTPRequestSerializer serializer];
    self.sessionManager.requestSerializer = serializer;
    NSMutableURLRequest * request =[self.sessionManager.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:path relativeToURL:self.sessionManager.baseURL]absoluteString] parameters:nil error:nil];
    
    __block NSURL * appropriateUrl = [NSURL URLWithString:save];

    NSURLSessionDownloadTask * task = [self.sessionManager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
    {
        NSURL * documentDirectoryURL = [[NSFileManager defaultManager]URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:appropriateUrl create:NO error:nil];
        return [documentDirectoryURL URLByAppendingPathComponent:save];
    }completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        success([NSString stringWithFormat:@"%@",response.URL],filePath);
    }];
    [self.sessionManager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite)
    {
        progress(bytesWritten/totalBytesExpectedToWrite);
    }];
    [task resume];
}
-(AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager  = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer.timeoutInterval = 10.f;
        _sessionManager.requestSerializer  = [AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    NSString * MIMEType = [self valueForKey:@"MIMEType"];
    if ([MIMEType isEqualToString:@"application/json"]) {
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSString * MIMEType = @"html/text";
        [self setValue:MIMEType forKey:@"MIMEType"];
    }
    else
    {
        _sessionManager =  [_sessionManager initWithBaseURL:[NSURL URLWithString:ServletConfigPath]];

    }
    return _sessionManager;
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
        if ([result isKindOfClass:[NSNumber class]]
            &&
            ([result integerValue]==0
            ||[result floatValue] ==0.0f))
        {
            result =@(0);
        }
        else if ([result isKindOfClass:[NSNull class]])
        {
            result = @"";
        }
        else  if ([result isKindOfClass:[NSString class]]
                 &&
            (!result
            ||[result isEqualToString:@""]
            ))
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
