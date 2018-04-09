//
//  LearnObjectiveC_TypeDefiner.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/9/8.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectAppConfiguration.h"

#define __M_PI 3.1415926

#define __UIColorFromRGB(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                     blue:((float)(rgbValue & 0xFF))/255.0 \
                    alpha:(float)1.0]
/*
#ifdef  DEBUG
#define __NSLog(format, ...) do {      \
    fprintf(stderr,"===================\n");\
    fprintf(stderr,"{[%s : %d]\n %s}\n" ,\
    [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __func__);\
    NSLog((format),##__VA_ARGS__);  \
    fprintf(stderr,"===================\n");\
    } while ( 0 )
#else
#define __NSLog(...)
#endif
*/
//Custom Debug
#ifdef  Release
    #define __NSLog(...)
    #else
    #define __NSLog(format, ...) do {      \
    fprintf(stderr,"===================\n");\
    fprintf(stderr,"{[%s : %d]\n %s}\n" ,\
    [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __func__);\
    NSLog((format),##__VA_ARGS__);  \
    fprintf(stderr,"===================\n");\
    } while ( 0 )
#endif


#undef  __AS_SINGLETON
#define __AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;
#undef  __DEF_SINGLETON
#define __DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
    static dispatch_once_t once; \
    static __class * __singleton__; \
    dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
    return __singleton__; \
}
//简单函数宏学习
#define  SELF(param) [NSString stringWithFormat:@"__testClass :%@",param]

#undef  __M_PI
#define __M_PI 3.1415926
#define  PLUS(a,b)  __M_PI * (a + b)

//version 1.0
#define  __Min(a,b) ((a) < (b) ? (a) : (b))
//version 2.0
#define  __MIN(A,B)({ __typeof__ (A)  __a= (A); __typeof__ (B)  __b=(B);__a < __b ? __a : __b;})

// Rect Size Point
#define  __NSLogRect(rect) __NSLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect))

#define  __NSLogSize(size)  __NSLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)

#define  __NSLogPoint(point) __NSLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)



#define System_Simulator_iPad   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define System_Simulator_iPhone (UI_USER_INTERFACE_IDIOM() ==UIUserInterfaceIdiomPhone)

static inline float  APPAdapterScaleFontFamily(float iphone6FontSize);
static inline float  APPAdapterScaleFontFamily(float iphone6FontSize)
{
    // {768, 1024}}
    if (System_Simulator_iPhone) {
        return [UIScreen mainScreen].bounds.size.width / 375.f * iphone6FontSize;
    }
    else
        return [UIScreen mainScreen].bounds.size.width / 768.f  * iphone6FontSize;
}

static inline float APPAdapterScaleWith(float iphone6Width);
static inline float APPAdapterScaleWith(float iphone6Width)
{
    if (System_Simulator_iPhone) {
        return [UIScreen mainScreen].bounds.size.width / 375.f * iphone6Width *1.0;
    }
    else
        return [UIScreen mainScreen].bounds.size.width / 768.0f * iphone6Width;
}

static inline float APPAdapterAdjustHeight(float iphone6Height);
static inline float APPAdapterAdjustHeight(float iphone6Height)
{
    if (System_Simulator_iPhone) {
        return [UIScreen mainScreen].bounds.size.height / 667.f * iphone6Height *1.0;
    }
    else
        return [UIScreen mainScreen].bounds.size.height / 1024.f * iphone6Height * 1.0f;
}
/*
static inline float  APPAdapterScaleFontFamily(float iphone6FontSize);
static inline float  APPAdapterScaleFontFamily(float iphone6FontSize)
{
    return [UIScreen mainScreen].bounds.size.width / 375.f * iphone6FontSize;
}

static inline float APPAdapterScaleWith(float iphone6Width);
static inline float APPAdapterScaleWith(float iphone6Width)
{
    return [UIScreen mainScreen].bounds.size.width / 375.f * iphone6Width *1.0;
}

static inline float APPAdapterAdjustHeight(float iphone6Height);
static inline float APPAdapterAdjustHeight(float iphone6Height)
{
    return [UIScreen mainScreen].bounds.size.height / 667.f * iphone6Height *1.0;
}
*/
/*
NSMutableDictionary * _mutableDictionary;\
if (!_mutableDictionary) {\
    _mutableDictionary = [[NSMutableDictionary alloc] init];\
#define OA_DEFINE_TYPE_ECODE_CASE(__name,__type) \
[_name setObject:[NSString stringWithUTF8String:@encode(__type)] forKey:@#__type];\
    OA_DEFINE_TYPE_ECODE_CASE(id)
    OA_DEFINE_TYPE_ECODE_CASE(BOOL)
    OA_DEFINE_TYPE_ECODE_CASE(int)
    OA_DEFINE_TYPE_ECODE_CASE(void)
    OA_DEFINE_TYPE_ECODE_CASE(char)
    OA_DEFINE_TYPE_ECODE_CASE(short)
*/

/*
#define OAOBJECT_INITIALIZE(_name, _prep, _type) \
+(instancetype)_name:(_type)prep \
{   \
OAObject * obj = [[OAObject alloc]init]; \
obj._prep = prep; \
return obj;\
}

OAOBJECT_INITIALIZE(obj, obj , id)
OAOBJECT_INITIALIZE(pointer, pointerObj, void*)
OAOBJECT_INITIALIZE(weakObj, weakObj, id)
OAOBJECT_INITIALIZE(assignObj, assignObj, id)
*/
@interface LearnObjectiveC_TypeDefiner : NSObject
@end
