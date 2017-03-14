//
//  APPSqliteManager.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/13.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import "OOBaseObject.h"

@interface APPSqliteManager : NSObject

+(instancetype)shareInstance;

-(void)executeOpenDB:(NSString*)DBPath;

-(void)executeSql:(NSString*)sql;

-(instancetype)executeQuerySql:(NSString*)sql;


@end
