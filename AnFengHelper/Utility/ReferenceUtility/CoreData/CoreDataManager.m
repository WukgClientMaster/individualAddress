//
//  CoreDataManager.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/9/19.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import <objc/runtime.h>
#import "User.h"

static  CoreDataManager * _coreDataManager = nil;

@interface CoreDataManager ()

@property (strong, nonatomic,readwrite) NSArray * caches;
@end

@implementation CoreDataManager

@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
//数据存储操作
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.resourceName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSString * storeName = [NSString stringWithFormat:@"%@.sqlite",self.resourceName];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:storeName];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        abort();
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

-(void)saveContext;
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(NSURL*)applicationDocumentsDirectory;
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//数据基本操作
+(instancetype)shareInstance
{
    static dispatch_once_t once ;
    dispatch_once(&once, ^{
        if (!_coreDataManager) {
            _coreDataManager   = [[CoreDataManager alloc]init];
        }
    });
    return _coreDataManager;
}
#pragma mark Setter Method View Style
-(void)setObjectType:(id)objectType
{
    objc_setAssociatedObject(self, @selector(setObjectType:),objectType, OBJC_ASSOCIATION_RETAIN);
}
-(void)setResourceName:(NSString *)resourceName
{
    NSAssert(resourceName != nil, @"ResourceName CoreData 仓库不能为空");
    objc_setAssociatedObject(self, @selector(setResourceName:), resourceName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setEntityName:(NSString *)entityName
{
    NSAssert(entityName != nil, @"entity 实体类对象的不能为空");
    objc_setAssociatedObject(self, @selector(setEntityName:), entityName, OBJC_ASSOCIATION_COPY);
}

#pragma mark Getter Method View Style
-(id)objectType
{
    return objc_getAssociatedObject(self, @selector(setObjectType:));
}

-(NSString *)entityName
{
   return objc_getAssociatedObject(self, @selector(setEntityName:));
}

-(NSString *)resourceName
{
    return objc_getAssociatedObject(self, @selector(setResourceName:));
}
//读取操作
-(NSArray*)readCoreData;
{
    NSAssert(self.resourceName != nil, @"ResourceName CoreData 仓库不能为空");
    NSAssert(self.entityName != nil, @"entity 实体类对象的不能为空");
    NSManagedObjectContext * managedObjectContext =self.managedObjectContext;
    NSFetchRequest  * fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    NSError * error = nil;
    self.caches = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return  self.caches;
}

-(void)insert:(NSObject*)object
{
    const char * formatClassName = "User";
    User * className =  objc_getClass(formatClassName);
    className =[NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    className.userID = @"";
    className.userName  = @"userName";
    className.avatar = @"avatar";
    [self.managedObjectContext insertObject:className];
    __block NSError * error = nil;
    [self.managedObjectContext save:&error];
}

-(void)insertManagedObject:(NSManagedObject*)managedObejct;
{
    NSAssert(self.resourceName != nil, @"ResourceName CoreData 仓库不能为空");
    NSAssert(self.entityName != nil, @"entity 实体类对象的不能为空");
    User * user = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    user.userID = @"10";
    user.userName = @"wukg___";
    user.avatar = @"https://www.baidu.com___";
    
    User * user1 = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.managedObjectContext];
    user1.userID = @"100";
    user1.userName = @"wukg___";
    user1.avatar = @"https://www.baidu.com___";
    
    [self.managedObjectContext insertObject:user];
    [self.managedObjectContext insertObject:user1];
    __block NSError * error = nil;
    [self.managedObjectContext save:&error];
    
}

-(void)deleteManagedObject:(NSManagedObject*)managedObject;
{
     __block NSError * error = nil;
    [self.managedObjectContext save:&error];
}

-(void)alldeleteObject
{
    NSArray * caches = [self readCoreData];
    [caches enumerateObjectsUsingBlock:^(NSManagedObject *  obj, NSUInteger idx, BOOL *  stop) {
        [self.managedObjectContext deleteObject:obj];
    }];
    __block NSError * error = nil;
    [self.managedObjectContext save:&error];
}
@end

