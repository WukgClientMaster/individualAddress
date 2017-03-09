//
//  PolyActivity.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/5/4.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "PolyActivity.h"

@interface PolyActivity()
{
    PolyActivityType  _type;
    NSURL * _url;
}

@end
@implementation PolyActivity

+(instancetype)activityWithType:(PolyActivityType)type
{
    PolyActivity * polyActivity = [[PolyActivity alloc]initWithActivityType:type];
    return polyActivity;
}

-(instancetype)initWithActivityType:(PolyActivityType)type
{
    if (self = [super init])
    {
        _type = type;
    }
    return self;
}

#pragma mark - getter methods
+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryAction;
}

- (NSString *)activityType
{
    switch (_type) {
        case kPolyActivityTypeLink:           return @"com.dzn.DZNWebViewController.activity.CopyLink";
        case kPolyActivityTypeSafari:         return @"com.dzn.DZNWebViewController.activity.OpenInSafari";
        case kPolyActivityTypeChrome:         return @"com.dzn.DZNWebViewController.activity.OpenInChrome";
        case kPolyActivityTypeOpera:          return @"com.dzn.DZNWebViewController.activity.OpenInOperaMini";
        case kPolyActivityTypeDolphin:        return @"com.dzn.DZNWebViewController.activity.OpenInDolphin";
    }
}

- (NSString *)activityTitle
{
    switch (_type) {
        case kPolyActivityTypeLink:           return NSLocalizedString(@"Copy Link", nil);
        case kPolyActivityTypeSafari:         return NSLocalizedString(@"Open in Safari", nil);
        case kPolyActivityTypeChrome:         return NSLocalizedString(@"Open in Chrome", nil);
        case kPolyActivityTypeOpera:          return NSLocalizedString(@"Open in Opera", nil);
        case kPolyActivityTypeDolphin:        return NSLocalizedString(@"Open in Dolphin", nil);
    }
}

- (UIImage *)activityImage
{
    switch (_type) {
        case kPolyActivityTypeLink:           return [UIImage imageNamed:@"Link7"];
        case kPolyActivityTypeSafari:         return [UIImage imageNamed:@"Safari7"];
        case kPolyActivityTypeChrome:         return [UIImage imageNamed:@"Chrome7"];
        case kPolyActivityTypeOpera:          return [UIImage imageNamed:@"Opera7"];
        case kPolyActivityTypeDolphin:        return [UIImage imageNamed:@"Dolphin7"];
        default:                                return nil;
    }
}

- (NSURL *)chromeURLWithURL:(NSURL *)URL
{
    return [self customURLWithURL:URL andType:kPolyActivityTypeChrome];
}

- (NSURL *)operaURLWithURL:(NSURL *)URL
{
    return [self customURLWithURL:URL andType:kPolyActivityTypeOpera];
}

- (NSURL *)dolphinURLWithURL:(NSURL *)URL
{
    return [self customURLWithURL:URL andType: kPolyActivityTypeDolphin];
}

- (NSURL *)customURLWithURL:(NSURL *)URL andType:(PolyActivityType)type
{
    // Replaces the URL Scheme with the type equivalent.
    NSString *scheme = nil;
    if ([URL.scheme isEqualToString:@"http"]) {
        if (type == kPolyActivityTypeChrome) scheme = @"googlechrome";
        if (type == kPolyActivityTypeOpera) scheme = @"ohttp";
        if (type == kPolyActivityTypeDolphin) scheme = @"dolphin";
    }
    else if ([URL.scheme isEqualToString:@"https"]) {
        if (type == kPolyActivityTypeChrome) scheme = @"googlechromes";
        if (type == kPolyActivityTypeOpera) scheme = @"ohttps";
        if (type == kPolyActivityTypeDolphin) scheme = @"dolphin";
    }
    // Proceeds only if a valid URI Scheme is available.
    if (scheme) {
        NSRange range = [[URL absoluteString] rangeOfString:@":"];
        NSString *urlNoScheme = [[URL absoluteString] substringFromIndex:range.location];
        return [NSURL URLWithString:[scheme stringByAppendingString:urlNoScheme]];
    }
    return nil;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (UIActivity *item in activityItems) {
        
        if ([item isKindOfClass:[NSString class]]) {
            
            NSURL *URL = [NSURL URLWithString:(NSString *)item];
            if (!URL) continue;
            
            if (_type == kPolyActivityTypeLink) {
                return URL ? YES : NO;
            }
            if (_type == kPolyActivityTypeSafari) {
                return [[UIApplication sharedApplication] canOpenURL:URL];
            }
            if (_type == kPolyActivityTypeChrome) {
                return [[UIApplication sharedApplication] canOpenURL:[self chromeURLWithURL:URL]];
            }
            if (_type == kPolyActivityTypeOpera) {
                return [[UIApplication sharedApplication] canOpenURL:[self operaURLWithURL:URL]];
            }
            if (_type == kPolyActivityTypeDolphin) {
                return [[UIApplication sharedApplication] canOpenURL:[self dolphinURLWithURL:URL]];
            }
            
            break;
        }
    }
    
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id item in activityItems) {
        
        if ([item isKindOfClass:[NSString class]]) {
            _url = [NSURL URLWithString:(NSString *)item];
            if (!_url) continue;
            else break;
        }
    }
}

- (void)performActivity
{
    BOOL completed = NO;
    
    if (!_url) {
        [self activityDidFinish:completed];
        return;
    }
    switch (_type) {
        case kPolyActivityTypeLink:
            [[UIPasteboard generalPasteboard] setURL:_url];
            completed = YES;
            break;
        case kPolyActivityTypeSafari:
            completed = [[UIApplication sharedApplication] openURL:_url];
            break;
        case kPolyActivityTypeChrome:
            completed = [[UIApplication sharedApplication] openURL:[self chromeURLWithURL:_url]];
            break;
        case kPolyActivityTypeOpera:
            completed = [[UIApplication sharedApplication] openURL:[self operaURLWithURL:_url]];
            break;
        case kPolyActivityTypeDolphin:
            completed = [[UIApplication sharedApplication] openURL:[self dolphinURLWithURL:_url]];
            break;
    }
    
    [self activityDidFinish:completed];
}

@end
