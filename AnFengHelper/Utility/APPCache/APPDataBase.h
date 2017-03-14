//
//  APPDataBase.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/13.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class APPResultSet;

#if ! __has_feature(objc_arc)
#define FMDBAutorelease(__v) ([__v autorelease]);
#define FMDBReturnAutoreleased FMDBAutorelease

#define FMDBRetain(__v) ([__v retain]);
#define FMDBReturnRetained FMDBRetain

#define FMDBRelease(__v) ([__v release]);

#define FMDBDispatchQueueRelease(__v) (dispatch_release(__v));
#else
// -fobjc-arc
#define FMDBAutorelease(__v)
#define FMDBReturnAutoreleased(__v) (__v)

#define FMDBRetain(__v)
#define FMDBReturnRetained(__v) (__v)

#define FMDBRelease(__v)

// If OS_OBJECT_USE_OBJC=1, then the dispatch objects will be treated like ObjC objects
// and will participate in ARC.
// See the section on "Dispatch Queues and Automatic Reference Counting" in "Grand Central Dispatch (GCD) Reference" for details.
#if OS_OBJECT_USE_OBJC
#define FMDBDispatchQueueRelease(__v)
#else
#define FMDBDispatchQueueRelease(__v) (dispatch_release(__v));
#endif
#endif

#if !__has_feature(objc_instancetype)
#define instancetype id
#endif

typedef int(^DBExecuteStatementsCallbackBlock)(NSDictionary *resultsDictionary);
@interface APPDataBase : NSObject
{
    void*               _db;
    NSString*           _databasePath;
    BOOL                _logsErrors;
    BOOL                _crashOnErrors;
    BOOL                _traceExecution;
    BOOL                _checkedOut;
    BOOL                _shouldCacheStatements;
    BOOL                _isExecutingStatement;
    BOOL                _inTransaction;
    NSTimeInterval      _maxBusyRetryTimeInterval;
    NSTimeInterval      _startBusyRetryTime;
    
    NSMutableDictionary *_cachedStatements;
    NSMutableSet        *_openResultSets;
    NSMutableSet        *_openFunctions;
    
    NSDateFormatter     *_dateFormat;
}

@property (atomic, assign) BOOL traceExecution;
@property (atomic, assign) BOOL checkedOut;
@property (atomic, assign) BOOL crashOnErrors;
@property (atomic, assign) BOOL logsErrors;
@property (atomic, retain) NSMutableDictionary *cachedStatements;

+ (instancetype)databaseWithPath:(NSString*)inPath;
- (instancetype)initWithPath:(NSString*)inPath;
- (BOOL)open;
- (BOOL)openWithFlags:(int)flags;
- (BOOL)openWithFlags:(int)flags vfs:(NSString *)vfsName;
- (BOOL)close;
- (BOOL)goodConnection;
- (BOOL)executeUpdate:(NSString*)sql withErrorAndBindings:(NSError**)outErr, ...;
- (BOOL)update:(NSString*)sql withErrorAndBindings:(NSError**)outErr, ... __attribute__ ((deprecated));
- (BOOL)executeUpdate:(NSString*)sql, ...;
- (BOOL)executeUpdateWithFormat:(NSString *)format;
- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments;
- (BOOL)executeUpdate:(NSString*)sql values:(NSArray *)values error:(NSError * __autoreleasing *)error;
- (BOOL)executeUpdate:(NSString*)sql withParameterDictionary:(NSDictionary *)arguments;
- (BOOL)executeUpdate:(NSString*)sql withVAList: (va_list)args;

- (BOOL)executeStatements:(NSString *)sql;
- (BOOL)executeStatements:(NSString *)sql withResultBlock:(DBExecuteStatementsCallbackBlock)block;

- (int64_t)lastInsertRowId;
- (int)changes;
- (APPResultSet *)executeQuery:(NSString*)sql, ...;
- (APPResultSet *)executeQueryWithFormat:(NSString*)format, ...;
- (APPResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments;
- (APPResultSet *)executeQuery:(NSString *)sql values:(NSArray *)values error:(NSError * __autoreleasing *)error;

- (APPResultSet *)executeQuery:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments;
- (APPResultSet *)executeQuery:(NSString*)sql withVAList: (va_list)args;

- (BOOL)beginTransaction;
- (BOOL)beginDeferredTransaction;
- (BOOL)commit;
- (BOOL)rollback;
- (BOOL)inTransaction;
- (void)clearCachedStatements;
- (void)closeOpenResultSets;

- (BOOL)hasOpenResultSets;
- (BOOL)shouldCacheStatements;
- (void)setShouldCacheStatements:(BOOL)value;
- (BOOL)interrupt;
- (BOOL)setKey:(NSString*)key;
- (BOOL)rekey:(NSString*)key;
- (BOOL)setKeyWithData:(NSData *)keyData;
- (BOOL)rekeyWithData:(NSData *)keyData;
- (NSString *)databasePath;
- (void*)sqliteHandle;
- (NSString*)lastErrorMessage;
- (int)lastErrorCode;
- (int)lastExtendedErrorCode;
- (BOOL)hadError;
- (NSError*)lastError;

- (void)setMaxBusyRetryTimeInterval:(NSTimeInterval)timeoutInSeconds;
- (NSTimeInterval)maxBusyRetryTimeInterval;
- (BOOL)startSavePointWithName:(NSString*)name error:(NSError**)outErr;
- (BOOL)releaseSavePointWithName:(NSString*)name error:(NSError**)outErr;
- (BOOL)rollbackToSavePointWithName:(NSString*)name error:(NSError**)outErr;
- (NSError*)inSavePoint:(void (^)(BOOL *rollback))block;
+ (BOOL)isSQLiteThreadSafe;
+ (NSString*)sqliteLibVersion;
+ (NSString*)FMDBUserVersion;
+ (SInt32)FMDBVersion;
- (void)makeFunctionNamed:(NSString*)name maximumArguments:(int)count withBlock:(void (^)(void *context, int argc, void **argv))block;
+ (NSDateFormatter *)storeableDateFormat:(NSString *)format;
- (BOOL)hasDateFormatter;
- (void)setDateFormat:(NSDateFormatter *)format;
- (NSDate *)dateFromString:(NSString *)s;
- (NSString *)stringFromDate:(NSDate *)date;
@end

@interface DBStatement : NSObject {
    void *_statement;
    NSString *_query;
    long _useCount;
    BOOL _inUse;
}

@property (atomic, assign) long useCount;
@property (atomic, retain) NSString *query;
@property (atomic, assign) void *statement;
@property (atomic, assign) BOOL inUse;
- (void)close;
- (void)reset;

@end