//
//  TX_WKGRecordFileManager.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/4/28.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>
//
@interface TX_WKGRecordFileManager : NSObject

+(instancetype)shareInstanace;
//建立在沙盒目录下文件
-(NSString *)creatDictionary:(NSString*)dictionary;

-(NSString *)creatDictionary:(NSString*)dictionary fileName:(NSString*)fileName;

-(void)deleteDictionary:(NSString*)dictionary fileName:(NSString*)fileName;

-(void)deleteDictionary:(NSString*)dictionary;

-(void)stopCameraVideoRecordPreview;

-(void)stopCameraPreview;

@end
