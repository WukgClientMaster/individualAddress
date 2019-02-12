//
//  HttpServerConnection.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/7/10.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "HttpServerConnection.h"
#import "RequestTaskManager.h"
#import "HTTPServerCacheManager.h"

@interface HttpServerConnection()<NSURLSessionDataDelegate>

@property (nonatomic ,strong) NSURLSession  *session;
@property (nonatomic ,strong) NSString *filePath;
@property (nonatomic ,strong) NSString * videoPath;
@property (strong, nonatomic) NSOperationQueue * operationQueue;
@property (strong, nonatomic) NSURLSessionDataTask * sessionTask;
@end

@implementation HttpServerConnection

-(void)startConnectionWithURL:(NSString*)urlString{
    if (urlString.length == 0 || urlString == nil)return;
    self.videoPath = urlString;
    if (_filePath == nil) {
        _filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:urlString.lastPathComponent];
    }
    //
    NSURL * requestURL = [NSURL URLWithString:self.videoPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:15.f];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [request setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [self.session invalidateAndCancel];
    self.operationQueue = [NSOperationQueue new];           //自定义队列
    self.operationQueue.maxConcurrentOperationCount = 1;    //1表示串行队列
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.operationQueue];
    self.sessionTask = [self.session dataTaskWithRequest:request];
    [self.sessionTask resume];
    [[RequestTaskManager sharedInstance] setTask:self.sessionTask forURL:requestURL];
    
}

#pragma mark - NSURLSessionDataDelegate
//服务器响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    [[NSUserDefaults standardUserDefaults ] setValue:[NSNumber numberWithLongLong:response.expectedContentLength] forKey:@"fileSize"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
//服务器返回数据 可能会调用多次
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:_filePath error:nil] fileSize];
    if (fileSize < 10000) {
        if (self.httpServerDelegate && [self.httpServerDelegate respondsToSelector:@selector(loader:loading:)]) {
            [self.httpServerDelegate loader:self loading:YES];
        }
    }else if (fileSize > 10000){
        if (self.httpServerDelegate && [self.httpServerDelegate respondsToSelector:@selector(loader:shouldPlay:)]) {
            [self.httpServerDelegate loader:self shouldPlay:YES];
        }
    }
    [self writeFile:data];
}

- (void)writeFile:(NSData *)data {
    FILE *fp = fopen([self.filePath UTF8String], "a+");
    if (fp ) {
        fwrite([data bytes], data.length, 1, fp);
        fflush(fp);
    }
    fclose(fp);
}
//请求完成会调用该方法，请求失败则error有值
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        if (self.httpServerDelegate && [self.httpServerDelegate respondsToSelector:@selector(loader:failLoadingWithError:)]) {
            [self.httpServerDelegate loader:self failLoadingWithError:nil];
        }
    }
    else{
        [self cacheTempFileWithURL];
        if (self.httpServerDelegate && [self.httpServerDelegate respondsToSelector:@selector(loader:complete:)]) {
            [self.httpServerDelegate loader:self complete:YES];
        }
    }
}
// 最终下载完的文件
- (void)cacheTempFileWithURL{
    NSString *cacheFilePath = [HTTPServerCacheManager getResourceCachePathByURL:self.videoPath];
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFilePath]) {
        NSLog(@"******cache file %@ already exist, remove it first", cacheFilePath);
        [[NSFileManager defaultManager] removeItemAtPath:cacheFilePath error:&error];
    }
    BOOL success = [[NSFileManager defaultManager] moveItemAtPath:self.filePath  toPath:cacheFilePath error:&error];
    if (!success || error) {
        NSLog(@"******cache file error: %@", error);
    } else {
        NSLog(@"******success cache file : %@", [NSURL URLWithString:cacheFilePath].lastPathComponent);
    }
}


@end
