//
//  HTTPHelper.m
//  AnFengHelper
//
//  Created by anfeng on 17/3/15.
//  Copyright © 2017年 AnFen. All rights reserved.


#import <Foundation/Foundation.h>
#import "HTTPHelper.h"
#import <objc/runtime.h>

static HTTPHelper * _httpHelper = nil;
static dispatch_once_t  once;

@interface HTTPHelper()
@property(nonatomic,strong)HTTPSessionManager * sessionManager;

@end

@implementation HTTPHelper

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
-(HTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager  = [HTTPSessionManager manager];
        _sessionManager =  [_sessionManager initWithBaseURL:[NSURL URLWithString:ServletConfigPath]];
        _sessionManager.requestSerializer.timeoutInterval = 10.f;
        _sessionManager.requestSerializer  = [HTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [HTTPResponseSerializer serializer];
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
{

}

- (void)postTaskWithPath:(NSString *)path
                  params:(NSDictionary*)params
                 success:(OperationSuccessBlock)success
                 failure:(OperationFailureBlock)failure
{
    static NSString*  ANFAN_APPID = @"2";
    static NSString * TDESRSA_PRIVATE_KEY = @"ebe89a4c54f35e59ebe89a4c";
    static NSString * ANFAN_RETAILERID = @"1";
    NSString *interval = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSMutableDictionary * param = @{@"_appid":ANFAN_APPID,
                             @"_type":@"json",
                             @"_timestamp":interval,
                             @"_rid":ANFAN_RETAILERID,
                             @"_sign_type":@"md5"
                             }.mutableCopy;
    [param addEntriesFromDictionary:params];
    NSString * args = [self buildParamString:param];
    NSString * mutable_args = [NSString stringWithFormat:@"%@&key=%@",args,TDESRSA_PRIVATE_KEY];;
    NSString * md5_args = [NSString MD5Encryption:mutable_args];
    [param setValue:md5_args forKey:@"_sign"];
    [self.sessionManager POST:path parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
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

}

- (void)downloadTaskWith:(NSString *)path
                savePath:(NSString*)save
                 success:(OperationSuccessBlock)success
                 failure:(OperationFailureBlock)failure
           uploadProgess:(OperationProgressBlock)progress
{

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


-(NSString *)buildParamString:(NSMutableDictionary *) params{
    NSArray * keys= [params  allKeys];
    if(keys.count<1){
        return @"";
    }
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray * sortkeys=[keys sortedArrayUsingDescriptors: descriptors];
    int count=(int)sortkeys.count;
    NSMutableString * param_string=[[NSMutableString alloc] init];
    for(int i=0;i<count;i++){
        NSString * key=sortkeys[i];
        NSString * value= [params objectForKey:key];
        [param_string appendFormat:@"%@=%@&",key,[self urlencode: value ]];
    }
    NSString * rv=[param_string substringToIndex: (int)param_string.length-1];
    return rv;
}

-(NSString *) urlencode:(NSString *) str{
    NSData * data=[str dataUsingEncoding: NSUTF8StringEncoding ];
    Byte  * bytes =(Byte *)[data bytes];
    int bytelength=(int)[data length];
    NSMutableString * arg=[[NSMutableString alloc] init];
    for(int i=0;i< bytelength;i++){
        if( (48 <= bytes[i] && bytes[i]<=57) ||
           (65 <= bytes[i] && bytes[i]<=90) ||
           (97 <= bytes[i] && bytes[i]<=122) ||
           bytes[i]=='~' || bytes[i]=='!' || bytes[i]=='*' || bytes[i]=='\'' || bytes[i]=='(' || bytes[i]==')' || bytes[i]=='_'
           ){
            [arg appendFormat:@"%c",bytes[i]];
        }
        else{
            [arg appendFormat:@"%%%02x",bytes[i]];
        }
    }
    return  [arg copy];
}


@end
