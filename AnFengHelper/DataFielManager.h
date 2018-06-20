//
//  DataFielManager.h
//  AnFengHelper
//
//  Created by 吴可高 on 2018/5/13.
//  Copyright © 2018年 AnFen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFielManager : NSObject
+(instancetype)shareInstance;
//储存文件
-(void)creatDictionaryWithName:(NSString*)dictionaryName;
-(void)creatFileWithName:(NSString*)fileName;
-(void)deleteFileWithName:(NSString*)fileName;
-(void)deleteDictionaryWithName:(NSString*)dictionaryName;
-(NSArray*)queryDataWithDictionary:(NSString*)dictionaryName;

//储存数据到数据库
-(void)createTableWithSql:(NSString*)sql;
-(void)insetDataWith:(NSString*)sql;
-(NSArray*)queryDataWithSql:(NSString*)sql;
-(void)deleteDataWithSql:(NSString*)sql;
-(void)updateDateWithSql:(NSString*)sql;

@end
