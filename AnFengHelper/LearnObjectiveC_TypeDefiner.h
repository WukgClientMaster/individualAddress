//
//  LearnObjectiveC_TypeDefiner.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/9/8.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __M_PI 3.1415926

#define __kColor(r,g,b,p)[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:p/1.f];

#define __UIColorFromRGB(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                     blue:((float)(rgbValue & 0xFF))/255.0 \
                    alpha:(float)1.0]

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

@interface LearnObjectiveC_TypeDefiner : NSObject


@end
