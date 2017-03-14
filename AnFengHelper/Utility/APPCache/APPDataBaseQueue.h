//
//  APPDataBaseQueue.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/13.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APPDataBase;
@interface APPDataBaseQueue : NSObject
{
    NSString            *_path;
    dispatch_queue_t    _queue;
    APPDataBase          *_db;
    int                 _openFlags;
    NSString            *_vfsName;
}
@property (atomic, retain) NSString *path;
@property (atomic, readonly) int openFlags;
@property (atomic, copy) NSString *vfsName;

+ (instancetype)databaseQueueWithPath:(NSString*)aPath;
+ (instancetype)databaseQueueWithPath:(NSString*)aPath flags:(int)openFlags;
- (instancetype)initWithPath:(NSString*)aPath;
- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags;
- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags vfs:(NSString *)vfsName;
+ (Class)databaseClass;
- (void)close;
- (void)interrupt;
- (void)inDatabase:(void (^)(APPDataBase *db))block;
- (void)inTransaction:(void (^)(APPDataBase *db, BOOL *rollback))block;
- (void)inDeferredTransaction:(void (^)(APPDataBase *db, BOOL *rollback))block;
- (NSError*)inSavePoint:(void (^)(APPDataBase *db, BOOL *rollback))block;

@end
