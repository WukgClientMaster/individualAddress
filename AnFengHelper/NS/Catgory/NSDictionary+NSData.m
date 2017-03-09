//
//  NSDictionary+NSData.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/13.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "NSDictionary+NSData.h"

@implementation NSDictionary (NSData)

+ (NSDictionary*)dictionaryWithContentsOfData:(NSData*)data;
{
    if (!data)  return nil;
    CFPropertyListRef list = CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (__bridge CFDataRef)data, kCFPropertyListImmutable, NULL);
    if (list &&  [(__bridge id)list  isKindOfClass:[NSDictionary class]]) {
        return (__bridge NSDictionary*)list;
    }
    else
    {
        CFRelease(list);
        return nil;
    }
}
@end
