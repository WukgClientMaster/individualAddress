//
//  TX_WKGRecordFileManager.m
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/28.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import "TX_WKGRecordFileManager.h"
#import <TXLiteAVSDK_Professional/TXUGCRecord.h>

static TX_WKGRecordFileManager * _recordFileManager = nil;

@interface TX_WKGRecordFileManager()
@property (copy, nonatomic) NSString * documentPath;
@property (strong, nonatomic) NSFileManager * fileManager;
@end

@implementation TX_WKGRecordFileManager

+(instancetype)shareInstanace{
    if (_recordFileManager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _recordFileManager = [[TX_WKGRecordFileManager alloc]init];
        });
    }
    return _recordFileManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        self.documentPath = documentsDirectory;
        self.fileManager = [NSFileManager defaultManager];
    }
    return self;
}
//
-(void)stopCameraVideoRecordPreview{
    [[TXUGCRecord shareInstance]stopCameraPreview];
    [[TXUGCRecord shareInstance]stopRecord];
    [[TXUGCRecord shareInstance]stopBGM];
}

-(void)stopCameraPreview{
    [[TXUGCRecord shareInstance]stopCameraPreview];
}

-(NSString *)creatDictionary:(NSString*)dictionary{
    NSString * path = [self.documentPath stringByAppendingPathComponent:dictionary];
    if (![self.fileManager fileExistsAtPath:path]) {
        [self.fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

-(NSString *)creatDictionary:(NSString*)dictionary fileName:(NSString*)fileName{
   NSString * path = [self.documentPath stringByAppendingPathComponent:dictionary];
    if (![self.fileManager fileExistsAtPath:path]) {
        [self.fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *cachePath =  [path stringByAppendingPathComponent:fileName];
    return cachePath;
}

-(void)deleteDictionary:(NSString*)dictionary fileName:(NSString*)fileName{
    NSArray *contents = [self.fileManager contentsOfDirectoryAtPath:dictionary error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        if ([fileName isEqualToString:filename]) {
            [self.fileManager removeItemAtPath:[dictionary stringByAppendingPathComponent:filename] error:NULL];
            break;
        }
    }
}

-(void)deleteDictionary:(NSString*)dictionary{
    NSArray *contents = [self.fileManager contentsOfDirectoryAtPath:dictionary error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [self.fileManager removeItemAtPath:[dictionary stringByAppendingPathComponent:filename] error:NULL];
    }
}

@end
