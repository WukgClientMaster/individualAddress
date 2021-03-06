//
//  UIViewController+Transitioning.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/4/19.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "UIViewController+Transitioning.h"
#import <objc/runtime.h>
#import "ModalTransition.h"
#import "ModalTransitionController.h"

@implementation UIViewController (Transitioning)

#pragma mark Object LifeStyle

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // Swizzle implementation of presentViewController with a custom one that detects custom transition types
        Method presentViewControllerMethod = class_getInstanceMethod(self, @selector(presentViewController:animated:completion:));
        Method customPresentViewControllerMethod = class_getInstanceMethod(self, @selector(customPresentViewController:animated:completion:));
        method_exchangeImplementations(presentViewControllerMethod, customPresentViewControllerMethod);
        
        // Swizzle implementation of dismissViewController with a custom one that will free up memory
        Method dismissViewControllerMethod = class_getInstanceMethod(self, @selector(dismissViewControllerAnimated:completion:));
        Method customDismissViewControllerMethod = class_getInstanceMethod(self, @selector(customDismissViewControllerMethod:completion:));
        method_exchangeImplementations(dismissViewControllerMethod, customDismissViewControllerMethod);
        
    });
}

#pragma mark - Transition types
- (void)registerClass:(Class)transitionClass forTransitionType:(NSInteger)transitionType
{
    [self.registeredTransitionTypes setObject:[transitionClass description] forKey:@(transitionType)];
}

- (void)unregisterClassForTransitionType:(NSInteger)transitionType
{
    [self.registeredTransitionTypes removeObjectForKey:@(transitionType)];
}


#pragma mark - Modal transition hook
- (void)customPresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion
{
    // Retrieve transition from view controller modalTransitionStyle property
    NSString *transitionClassName = [self.registeredTransitionTypes objectForKey:@(viewControllerToPresent.modalTransitionStyle)];
    if (!transitionClassName)
    {
        // Undefined transition? Present modal view normaly
        [self customPresentViewController:viewControllerToPresent animated:animated completion:completion];
        return;
    }
    
    // Build transition
    ModalTransition *transition = [[NSClassFromString(transitionClassName) alloc] init];
    self.transitionController = [[ModalTransitionController alloc] initWithModalTransition:transition];
    
    // Set self as transitioning delegate
    viewControllerToPresent.transitioningDelegate = self.transitionController;
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationCustom;
    
    // Call initial method
    [self customPresentViewController:viewControllerToPresent animated:animated completion:completion];
}

- (void)customDismissViewControllerMethod:(BOOL)flag completion:(void (^)(void))completion
{
    // Free up memory
    self.transitionController = nil;
    
    // Call initial method
    [self customDismissViewControllerMethod:flag completion:completion];
}

#pragma mark - Private getters and setters

static void * transitionControllerKey = &transitionControllerKey;
static void * registeredTransitionTypesKey = &registeredTransitionTypesKey;

- (ModalTransitionController *)transitionController
{
    return objc_getAssociatedObject(self, &transitionControllerKey);
}

- (void)setTransitionController:(ModalTransitionController *)transitionController
{
    objc_setAssociatedObject(self, &transitionControllerKey, transitionController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)registeredTransitionTypes
{
    NSMutableDictionary *registeredTransitionTypes = objc_getAssociatedObject(self, &registeredTransitionTypesKey);
    if (!registeredTransitionTypes)
    {
        // Initialize transition types
        registeredTransitionTypes = [NSMutableDictionary dictionary];
        
        // Built-in transitions
        [registeredTransitionTypes setObject:@"PopUpModelTransition" forKey:@(kModalTranstioningTypePopUp)];
        [registeredTransitionTypes setObject:@"TopSliderModalTransition" forKey:@(kModalTranstioningTypeNotification)];
        
        // Store created dictionary
        objc_setAssociatedObject(self, &registeredTransitionTypesKey, registeredTransitionTypes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return registeredTransitionTypes;
}

- (void)setRegisteredTransitionTypes:(NSMutableDictionary *)dic
{
    objc_setAssociatedObject(self, &registeredTransitionTypesKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
