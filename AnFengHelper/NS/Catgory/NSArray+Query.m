//
//  NSArray+Query.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/3/29.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "NSArray+Query.h"

@implementation NSArray (Query)

- (NSUInteger)lastObjectIndex;
{
    return [self indexOfObject:[self lastObject]];
}

- (NSArray *)reversedSourceArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator)
        [array addObject:element];
    return array;
}
@end
