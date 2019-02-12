//
//  VideoRecordNoficationManager.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/13.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^VideoRecordNoficationAPPProcess)(BOOL foreground);

@interface VideoRecordNoficationManager : NSObject
@property (assign,readonly,nonatomic) BOOL foreground;
@property (copy,readonly,nonatomic) VideoRecordNoficationAPPProcess callback;

+(instancetype)shareInstance;

-(void)runingProcessMonopolizeCallback:(VideoRecordNoficationAPPProcess)callback;

-(void)addObserverNotifications;

-(void)removeAllObserverNotifications;

@end
