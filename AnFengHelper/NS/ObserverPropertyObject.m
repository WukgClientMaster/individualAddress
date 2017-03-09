//
//  ObserverPropertyObject.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/3/31.
//  Copyright © 2016年 吴可高. All rights reserved.

// 定义静态常量字符串
#define uxy_staticConstString(__string)               static const char * __string = #__string;

#import "ObserverPropertyObject.h"
#import <objc/runtime.h>
#import <objc/message.h>


typedef int (*FUN)(int,int);


typedef NSString* (*PFUNC)(NSString* args,id object);
// 函数指针作为函数返回值
// 函数是：staticConstStringName(char*staticName) 返回值的类型是：int(*)(int,int); || 简单的来说，他就是一个返回值为int，参数列表是 （int，int）一个函数指针
int (*staticConstStringName(char* staticName))(int ,int);
// 21行函数的声明等等价于
FUN  staticConstStringWithName(char*staticName);

// 函数指针 －指针指向的数据类型是   void(*)(id,SEL,id,id)
//void (*KFUNC)(id,SEL,id,id) = (void(*)(id,SEL,id,id))objc_msgSend;


void (*KVO_Observer_New)(id,SEL,id,id) = (void(*)(id,SEL,id,id))objc_msgSend;
void (*KVO_Observer_Old)(id,SEL,id,id,id) = (void(*)(id,SEL,id,id,id))objc_msgSend;

typedef NS_OPTIONS(NSInteger,KVOPropertyType)
{
    kKVOPropertyType_NEW,
    kKVOPropertyType_OLD
};

@interface ObserverPropertyObject()
@property (nonatomic, assign) KVOPropertyType type;      // 观察者的类型

@property (nonatomic, weak) id target;                  // 被观察的对象的值改变时后的响应方法所在的对象
@property (nonatomic, assign) SEL selector;             // 被观察的对象的值改变时后的响应方法
@property (nonatomic, copy) KVOObjectPropertyNewOldBlock block;        // 值改变时执行的block

@property (nonatomic, assign) id sourceObject;         // 被观察的对象
@property (nonatomic, copy) NSString *keyPath;        // 被观察的对象的keyPath

- (instancetype)initWithSourceObject:(id)sourceObject keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector type:(KVOPropertyType)type;

- (instancetype)initWithSourceObject:(id)sourceObject keyPath:(NSString*)keyPath block:(KVOObjectPropertyNewOldBlock)block;

@end


@implementation ObserverPropertyObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithSourceObject:(id)sourceObject keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector type:(KVOPropertyType)type
{
    self = [super init];
    if (self)
    {
        _target       = target;
        _selector     = selector;
        _sourceObject = sourceObject;
        _keyPath      = keyPath;
        _type         = type;
        NSKeyValueObservingOptions options = (_type == kKVOPropertyType_NEW) ? NSKeyValueObservingOptionNew : (NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld);
        [_sourceObject addObserver:self forKeyPath:keyPath options:options context:nil];
    }
    return self;
}

- (instancetype)initWithSourceObject:(id)sourceObject keyPath:(NSString*)keyPath block:(KVOObjectPropertyNewOldBlock)block
{
    self = [super init];
    if (self)
    {
        _sourceObject = sourceObject;
        _keyPath      = keyPath;
        _block        = block;
        [_sourceObject addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}


- (void)dealloc
{
    if (_sourceObject)
        [_sourceObject removeObserver:self forKeyPath:_keyPath];
}

#pragma mark NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if (_block)
    {
        _block(change[NSKeyValueChangeNewKey], change[NSKeyValueChangeOldKey]);
        return;
    }
    if (_type == kKVOPropertyType_NEW)
    {
        KVO_Observer_New(_target,_selector,_sourceObject,change[NSKeyValueChangeNewKey]);
    }
    else if (_type == kKVOPropertyType_OLD)
    {
        KVO_Observer_Old(_target,_selector,_sourceObject,change[NSKeyValueChangeNewKey],change[NSKeyValueChangeOldKey]);
    }
}

@end

#pragma mark - NSObject (XYKVOPrivate)
@interface NSObject (KVOPrivate)

- (void)observeWithObject:(id)sourceObject keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector type:(KVOPropertyType)type;
@end


@implementation NSObject(ObserverPropertyObject)

uxy_staticConstString(NSObject_observers)

-(id)kvoDictionary
{
    return objc_getAssociatedObject(self, NSObject_observers) ?: ({
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
        objc_setAssociatedObject(self, NSObject_observers, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        dic;
    });
}
- (void)observeWithObject:(id)object property:(NSString*)property
{
    SEL aSel = nil;
    
    aSel = NSSelectorFromString([NSString stringWithFormat:@"handleKVO_%@_in:new:", property]);
    if ([self respondsToSelector:aSel])
    {
        [self observeWithObject:object
                        keyPath:property
                         target:self
                       selector:aSel
                           type:kKVOPropertyType_NEW];
        return;
    }
    
    aSel = NSSelectorFromString([NSString stringWithFormat:@"handleKVO_%@_in:new:old:", property]);
    if ([self respondsToSelector:aSel])
    {
        [self observeWithObject:object
                        keyPath:property
                         target:self
                       selector:aSel
                           type:kKVOPropertyType_OLD];
        return;
    }
}
- (void)observeWithObject:(id)object property:(NSString*)property block:(KVOObjectPropertyNewOldBlock)block
{
    [self observeWithObject:object keyPath:property block:block];
}
- (void)observeWithObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector type:(KVOPropertyType)type
{
    NSAssert([target respondsToSelector:selector], @"selector 必须存在");
    NSAssert(keyPath.length > 0, @"property 必须存在");
    NSAssert(object, @"被观察的对象object 必须存在");
    NSString *key = [NSString stringWithFormat:@"%@_%@", object, keyPath];
    ObserverPropertyObject *ob     = [[ObserverPropertyObject alloc] initWithSourceObject:object keyPath:keyPath target:target selector:selector type:type];
    
    self.kvoDictionary[key] = ob;
}
- (void)observeWithObject:(id)object keyPath:(NSString*)keyPath block:(KVOObjectPropertyNewOldBlock)block
{
    NSAssert(block, @"block 必须存在");
    NSString *key = [NSString stringWithFormat:@"%@_%@", object, keyPath];
    ObserverPropertyObject *ob     = [[ObserverPropertyObject alloc] initWithSourceObject:object keyPath:keyPath block:block];
    
    self.kvoDictionary[key] = ob;
}
- (void)removeObserverWithObject:(id)object property:(NSString *)property
{
    NSString *key = [NSString stringWithFormat:@"%@_%@", object, property];
    [self.kvoDictionary removeObjectForKey:key];
}
- (void)removeObserverWithObject:(id)object
{
    NSString *prefix = [NSString stringWithFormat:@"%@", object];
    [self.kvoDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key hasPrefix:prefix])
        {
            [self.kvoDictionary removeObjectForKey:key];
        }
    }];
}
- (void)removeAllObserver
{
    [self.kvoDictionary removeAllObjects];
}
@end
