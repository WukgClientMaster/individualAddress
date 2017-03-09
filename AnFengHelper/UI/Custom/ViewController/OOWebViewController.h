//
//  OOWebViewController.h
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/5/4.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "OOBaseViewController.h"

//  OOWebViewController ActionType
typedef NS_OPTIONS(NSUInteger, OOWebViewControllerActionType)
{
    kOOWebViewControllerActionAll = -1,
    kOOWebViewControllerActionNone = 0,
    kOOWebViewControllerActionShareLink = (1 << 0),
    kOOWebViewControllerActionCopyLink = (1 << 1),
    kOOWebViewControllerActionReadLater = (1 << 2),
    kOOWebViewControllerActionOpenSafari = (1 << 3),
    kOOWebViewControllerActionOpenChrome = (1 << 4),
    kOOWebViewControllerActionOpenOperaMini = (1 << 5),
    kOOWebViewControllerActionOpenDolphin = (1 << 6)
};

// OOWebViewController ActivityIndicator Style
typedef NS_OPTIONS(NSUInteger, OOWebViewControllerLoadingStyle)
{
    OOWebViewControllerLoadingStyleNone,
    OOWebViewControllerLoadingStyleProgressView,
    OOWebViewControllerLoadingStyleActivityIndicator
};

@interface OOWebViewController : OOBaseViewController

@property (strong, nonatomic) UIWebView * webView;
@property (strong, nonatomic) NSURL * url;
@property (assign, nonatomic) OOWebViewControllerActionType supportedAction;
@property (assign, nonatomic) OOWebViewControllerLoadingStyle loadingStyle;
@property (strong, nonatomic) UIColor * progressViewTinBarColor;

@property (strong, nonatomic) UIFont * titleFont;

@property (strong, nonatomic) UIColor * titleColor;

-(instancetype)initWithURL:(NSURL *)URL;
@end
