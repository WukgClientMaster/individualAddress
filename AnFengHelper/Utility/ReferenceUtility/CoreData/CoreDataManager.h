//
//  CoreDataManager.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/9/19.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager  : NSObject
@property (strong, nonatomic,readonly) NSArray * caches;

@property (copy, nonatomic) NSString * resourceName;
@property (copy, nonatomic) NSString * entityName;
@property (strong, nonatomic,readonly) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic,readonly) NSManagedObjectModel * managedObjectModel;
@property (strong, nonatomic,readonly) NSPersistentStoreCoordinator * persistentStoreCoordinator;

+(instancetype)shareInstance;
//初始化本地存储操作
-(void)saveContext;
-(NSURL*)applicationDocumentsDirectory;

//读取操作
-(NSArray*)readCoreData;
-(void)insert:(NSObject*)object;

-(void)insertManagedObject:(NSManagedObject*)managedObejct;
-(void)deleteManagedObject:(NSManagedObject*)managedObject;
-(void)alldeleteObject;


@end
