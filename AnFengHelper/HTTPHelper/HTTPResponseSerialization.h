//
//  HTTPResponseSerialization.h
//  AnFengHelper
//
//  Created by anfeng on 17/3/15.
//  Copyright © 2017年 AnFen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HTTPURLResponseSerialization <NSObject,NSSecureCoding,NSCopying>

- (id)responseObjectForResponse:( NSURLResponse *)response
                           data:( NSData *)data
                          error:(NSError *  __autoreleasing *)error ;
@end

@interface HTTPResponseSerializer : NSObject<HTTPURLResponseSerialization>
@property (nonatomic, assign) NSStringEncoding stringEncoding;
@property (nonatomic, copy, nullable) NSIndexSet *acceptableStatusCodes;
@property (nonatomic, copy, nullable) NSSet <NSString *> *acceptableContentTypes;

- (instancetype)init;

+ (instancetype)serializer;

- (BOOL)validateResponse:(nullable NSHTTPURLResponse *)response
                    data:(nullable NSData *)data
                   error:(NSError * _Nullable __autoreleasing *)error;
@end


@interface HTTPJSONResponseSerializer :HTTPResponseSerializer

@property (nonatomic, assign) NSJSONReadingOptions readingOptions;

@property (nonatomic, assign) BOOL removesKeysWithNullValues;

- (instancetype)init;

+ (instancetype)serializerWithReadingOptions:(NSJSONReadingOptions)readingOptions;

@end


NS_ASSUME_NONNULL_END

