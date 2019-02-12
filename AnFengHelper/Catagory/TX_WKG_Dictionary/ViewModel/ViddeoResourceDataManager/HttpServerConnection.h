//
//  HttpServerConnection.h
//  SmartCity
//
//  Created by 智享城市iOS开发 on 2018/7/10.
//  Copyright © 2018年 NRH. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HttpServerConnection;
@protocol HttpServerConnectionDelegate <NSObject>
@optional
- (void)loader:(HttpServerConnection *)loader loading:(BOOL)loading;
- (void)loader:(HttpServerConnection *)loader failLoadingWithError:(NSError *)error;
- (void)loader:(HttpServerConnection *)loader complete:(BOOL)complete;
- (void)loader:(HttpServerConnection *)loader shouldPlay:(BOOL)play;
@end


@interface HttpServerConnection : NSObject
@property (weak, nonatomic)id <HttpServerConnectionDelegate> httpServerDelegate;

-(void)startConnectionWithURL:(NSString*)urlString;

@end
