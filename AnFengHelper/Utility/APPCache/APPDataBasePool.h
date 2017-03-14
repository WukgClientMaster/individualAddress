//
//  APPDataBasePool.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/13.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APPDataBase;

@interface APPDataBasePool : NSObject
{
    NSString            *_path;
    dispatch_queue_t    _lockQueue;
    NSMutableArray      *_databaseInPool;
    NSMutableArray      *_databaseOutPool;
    __unsafe_unretained id _delegate;
    NSUInteger          _maximumNumberOfDatabasesToCreate;
    int                 _openFlags;
    NSString            *_vfsName;
}

@property (atomic, retain) NSString *path;
@property (atomic, assign) id delegate;
@property (atomic, assign) NSUInteger maximumNumberOfDatabasesToCreate;
@property (atomic, readonly) int openFlags;
@property (atomic, copy) NSString *vfsName;

+ (instancetype)databasePoolWithPath:(NSString*)aPath;
+ (instancetype)databasePoolWithPath:(NSString*)aPath flags:(int)openFlags;
- (instancetype)initWithPath:(NSString*)aPath;
- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags;
- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags vfs:(NSString *)vfsName;
+ (Class)databaseClass;
- (NSUInteger)countOfCheckedInDatabases;
- (NSUInteger)countOfCheckedOutDatabases;
- (NSUInteger)countOfOpenDatabases;
- (void)releaseAllDatabases;
- (void)inDatabase:(void (^)(APPDataBase *db))block;
- (void)inTransaction:(void (^)(APPDataBase *db, BOOL *rollback))block;
- (void)inDeferredTransaction:(void (^)(APPDataBase *db, BOOL *rollback))block;
- (NSError*)inSavePoint:(void (^)(APPDataBase *db, BOOL *rollback))block;

@end

@interface NSObject (APPDatabasePoolDelegate)
- (BOOL)databasePool:(APPDataBasePool*)pool shouldAddDatabaseToPool:(APPDataBase*)database;
- (void)databasePool:(APPDataBasePool*)pool didAddDatabase:(APPDataBase*)database;
@end



