//
//  LDWKWebView.m
//  VideoPlsIVASDK
//
//  Created by Bill on 16/10/10.
//  Copyright © 2016年 videopls.com. All rights reserved.
//

#import <Availability.h>
#import <WebKit/WebKit.h>

#import "LDWKWebView.h"

@interface LDWKWebView() <WKNavigationDelegate,WKUIDelegate>

@property (nonatomic) WKWebView *webView;

@end

@implementation LDWKWebView

- (void)initWebView {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.allowsInlineMediaPlayback = YES;
    
    _webView                    = [[WKWebView alloc] initWithFrame:self.bounds configuration:configuration];
    _webView.UIDelegate         = self;
    _webView.navigationDelegate = self;

    [self addSubview:_webView];
}

- (void)startLoadingWithUrl:(NSString *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:100];
    [_webView loadRequest:request];
}

- (void)startLoadingWithHtmlString:(NSString *)htmlString {
    [_webView loadHTMLString:htmlString baseURL:nil];
}

- (BOOL)canGoBack {
    return ([_webView canGoBack] && ([_webView.backForwardList.backList count] > 0));
}

- (void)goBack {
    [_webView goBack];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [_webView setFrame:self.bounds];
}

- (void)removeCache {
    
    [_webView stopLoading];
    [_webView removeFromSuperview];
    _webView.UIDelegate = nil;
    _webView.navigationDelegate = nil;
    _webView = nil;
    [self removeFromSuperview];
    self.delegate = nil;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}

#pragma WeKitDelegate

- (void) webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if(self.delegate) {
        if([self.delegate respondsToSelector:@selector(didStartLoad)]) {
            [self.delegate didStartLoad];
        }
    }
}

- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation  {
    if(self.delegate) {
        if([self.delegate respondsToSelector:@selector(loadComplete:)]) {
            NSString *title = webView.title;
            [self.delegate loadComplete:title];
        }
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    if ([strRequest rangeOfString:@"videojj"].location == NSNotFound) {
        // 拦截点击链接
        [self handleCustomAction:strRequest];
        // 不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        // 允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}


- (void)handleCustomAction:(NSString *)webUrl{
    
    if (![webUrl isEqualToString:@"about:blank"]) {        
        NSDictionary *userInfo;
        if (webUrl) {
            userInfo = [NSDictionary dictionaryWithObject:webUrl forKey:@"url"];
        }else {
            userInfo = nil;
        }
        NSNotification *openWeb =[NSNotification notificationWithName:@"LDSDKWebViewURL" object:nil userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:openWeb];
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if(navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
