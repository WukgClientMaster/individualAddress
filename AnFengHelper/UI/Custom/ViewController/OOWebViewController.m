//
//  OOWebViewController.m
//  LearnObjectiveC
//
//  Created by 吴可高 on 16/5/4.
//  Copyright © 2016年 吴可高. All rights reserved.
//

#import "OOWebViewController.h"
#import "OOWebViewProgess.h"
#import "OOWebViewProgressView.h"

#define kOOWebViewControllerContentTypeImage @"image"
#define kOOWebViewControllerContentTypeLink @"link"

@interface OOWebViewController()<UIWebViewDelegate,OOWebViewProgressDelegate>
{
    OOWebViewProgess *  _progressProxy;
    int _loadBalance;
    BOOL _didLoadContent;
}

@property (nonatomic, strong) OOWebViewProgressView *progressView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation OOWebViewController

- (id)init
{
    self = [super init];
    if (self) {
        _loadingStyle = OOWebViewControllerLoadingStyleProgressView;
        _supportedAction = kOOWebViewControllerActionAll;
    }
    return self;
}

-(instancetype)initWithURL:(NSURL *)URL
{
    NSParameterAssert(URL);
    NSAssert(URL != nil, @"Invalid URL");
    NSAssert(URL.scheme != nil, @"URL.scheme is nil");
    self = [self init];
    if (self) {
        self.url = URL;
    }
    return self;
}
#pragma mark - View lifecycle
-(void)loadView
{
    [super loadView];
    self.view = self.webView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_didLoadContent) {
        [self startRequestWithURL:self.url];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self clearProgressViewAnimated:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self stopLoading];
}


#pragma mark - Getter methods

- (UIWebView *)webView
{
    if (!_webView)
    {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.backgroundColor = [UIColor whiteColor];
        
        if (_loadingStyle == OOWebViewControllerLoadingStyleProgressView)
        {
            _progressProxy = [[OOWebViewProgess alloc] init];
            _webView.delegate = (id)_progressProxy;
            _progressProxy.webProxyDelegate = self;
            _progressProxy.progressDelegate = self;
        }
        else {
            _webView.delegate = self;
        }
    }
    return _webView;
}

- (OOWebViewProgressView *)progressView
{
    if (!_progressView && _loadingStyle == OOWebViewControllerLoadingStyleProgressView)
    {
        CGFloat progressBarHeight = 2.5f;
        CGSize navigationBarSize = self.navigationController.navigationBar.bounds.size;
        CGRect barFrame = CGRectMake(0, navigationBarSize.height - progressBarHeight, navigationBarSize.width, progressBarHeight);
        _progressView = [[OOWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.tintBarColor =  self.progressViewTinBarColor;
        [self.navigationController.navigationBar addSubview:_progressView];
    }

    return _progressView;
}

- (UIActivityIndicatorView *)activityIndicatorView
{
    if (!_activityIndicatorView)
    {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.hidesWhenStopped = YES;
    }
    return _activityIndicatorView;
}

- (UIFont *)titleFont
{
    if (!_titleFont) {
        return [[UINavigationBar appearance].titleTextAttributes objectForKey:NSFontAttributeName];
    }
    
    return _titleFont;
}

- (UIColor *)titleColor
{
    if (!_titleColor) {
        return [[UINavigationBar appearance].titleTextAttributes objectForKey:NSForegroundColorAttributeName];
    }
    
    return _titleColor;
}

- (NSString *)pageTitle
{
    NSString *js = @"document.body.style.webkitTouchCallout = 'none'; document.getElementsByTagName('title')[0].textContent;";
    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:js];
    return [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (BOOL)supportsAllActions
{
    return (_supportedAction == kOOWebViewControllerActionAll) ? YES : NO;
}


#pragma mark - Setter methods
- (void)setViewTitle:(NSString *)title
{
    UILabel *label = (UILabel *)self.navigationItem.titleView;
    
    if (!label || ![label isKindOfClass:[UILabel class]]) {
        label = [UILabel new];
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = self.titleFont;
        label.textColor = self.titleColor;
        self.navigationItem.titleView = label;
    }
    
    if (title) {
        label.text = title;
        [label sizeToFit];
        
        CGRect frame = label.frame;
        frame.size.height = self.navigationController.navigationBar.frame.size.height;
        label.frame = frame;
    }
}

/*
 * Sets the request errors with an alert view.
 */
- (void)setLoadingError:(NSError *)error
{
    switch (error.code) {
            //        case NSURLErrorTimedOut:
        case NSURLErrorUnknown:
        case NSURLErrorCancelled:
            return;
    }
    [self setActivityIndicatorsVisible:NO];
}

/*
 * Toggles the activity indicators on the status bar & footer view.
 */
- (void)setActivityIndicatorsVisible:(BOOL)visible
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = visible;
    if (_loadingStyle != OOWebViewControllerLoadingStyleActivityIndicator) {
        return;
    }
    if (visible) [_activityIndicatorView startAnimating];
    else [_activityIndicatorView stopAnimating];
}
#pragma mark - OOWebViewController methods
- (void)startRequestWithURL:(NSURL *)URL
{
    NSLog(@"self.webView.request.url = %@",self.webView.request.URL);
    _loadBalance = 0;
    if (![self.webView.request.URL isFileURL]) {
        [_webView loadRequest:[[NSURLRequest alloc] initWithURL:URL]];
    }
    else {
        NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
        NSString *HTMLString = [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy];
        
        [_webView loadHTMLString:HTMLString baseURL:nil];
    }
}

- (void)clearProgressViewAnimated:(BOOL)animated
{
    if (!_progressView) {
        return;
    }
    [UIView animateWithDuration:animated ? 0.25 : 0.0
                     animations:^{
                         _progressView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [_progressView removeFromSuperview];
                     }];
}

- (void)stopLoading
{
    [self.webView stopLoading];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
#pragma mark - UIWebViewDelegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (request.URL)
    {
        return YES;
    }
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _loadBalance++;
    if (_loadBalance == 1) {
        [self setActivityIndicatorsVisible:YES];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_loadBalance >= 1) _loadBalance--;
    else if (_loadBalance < 0) _loadBalance = 0;
    
    if (_loadBalance == 0) {
        _didLoadContent = YES;
        [self setActivityIndicatorsVisible:NO];
    }
    [self setViewTitle:[self pageTitle]];
    
    if ([webView.request.URL isFileURL] && _loadingStyle == OOWebViewControllerLoadingStyleProgressView) {
        [_progressView setProgress:1.0 animated:YES];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _loadBalance = 0;
    [self setLoadingError:error];
}

#pragma mark - OOWebViewProgressDelegate methods
- (void)webViewProgress:(OOWebViewProgess *)webViewProgress updateProgress:(float)progress
{
    [self.progressView setProgress:progress animated:YES];
}

#pragma mark - View lifeterm

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    _activityIndicatorView = nil;
    _webView = nil;
}

#pragma mark - View Auto-Rotation
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
- (BOOL)shouldAutorotate
{
    return NO;
}

@end
