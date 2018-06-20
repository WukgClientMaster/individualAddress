//
//  DataFielManager.m
//  AnFengHelper
//
//  Created by 吴可高 on 2018/5/13.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import "DataFielManager.h"
#import "IndictorView/IndicatorView.h"
NSString * APPDocumentPath(){
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,NO)firstObject];
}
NSString * APPCahcesPath(){
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,NO)firstObject];
}
NSString * APPTemporyPath(){
    return   NSTemporaryDirectory();
}

static DataFielManager * _dataFileManager = nil;

@interface DataFielManager ()
@property(nonatomic,strong) NSFileManager  * fileManager;
@end

@implementation DataFielManager

+(instancetype)shareInstance{
    if (_dataFileManager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _dataFileManager = [[DataFielManager alloc]init];
        });
    }
    return _dataFileManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}
//储存文件
-(void)creatDictionaryWithName:(NSString*)dictionaryName{
    
}

-(void)creatFileWithName:(NSString*)fileName{
    
}

-(void)deleteFileWithName:(NSString*)fileName{
    
}

-(void)deleteDictionaryWithName:(NSString*)dictionaryName{
    
}

-(NSArray*)queryDataWithDictionary:(NSString*)dictionaryName{
    return nil;
}

//储存数据到数据库
-(void)createTableWithSql:(NSString*)sql{
    
}
-(void)insetDataWith:(NSString*)sql{
    
}
-(NSArray*)queryDataWithSql:(NSString*)sql{
    return nil;
}

-(void)deleteDataWithSql:(NSString*)sql{
    
}

-(void)updateDateWithSql:(NSString*)sql{
    
}

@end
