//
//  LDWebView.m
//  VideoPlsIVASDK
//
//  Created by Bill on 16/10/10.
//  Copyright © 2016年 videopls.com. All rights reserved.
//

#import "LDWebView.h"
#import "LDWKWebView.h"

//#ifdef __IPHONE_8_0
//#define ISIPHONE8 1
//#else
//#define ISIPHONE8 0
//#endif

#ifndef ISIPHONE8
#define ISIPHONE8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0))
#endif

@interface LDWebView()<UIWebViewDelegate>

@property (nonatomic) UIWebView *webView;

@end

@implementation LDWebView

+ (LDWebView *)initWebViewWithFrame:(CGRect)frame type:(NSInteger)type{
    id dgWebView;
    if(type == 3) {
        dgWebView = [[LDWebView alloc] initWithFrame:frame];
    }
    else if (type == 1) {
        dgWebView = [[LDWKWebView alloc] initWithFrame:frame];
    }
    return dgWebView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initWebView];
    }
    return self;
}

- (void)initWebView {
    _webView = [[UIWebView alloc] initWithFrame:self.bounds];
    _webView.delegate = self;
    [_webView setAllowsInlineMediaPlayback:YES];
    [_webView setScalesPageToFit:YES];
//    [_webView setBackgroundColor:[UIColor clearColor]];
//    [_webView setOpaque:NO];
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
    return [_webView canGoBack];
}

- (void)goBack {
    [_webView goBack];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [_webView setFrame:self.bounds];
}

- (void)removeCache {
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView reload];
    [_webView stopLoading];
    _webView.delegate = nil;
    [_webView removeFromSuperview];
    _webView = nil;
    [_webView removeFromSuperview];
    [self removeFromSuperview];
    self.delegate = nil;
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    // new for memory cleanup
    //        [[NSURLCache sharedURLCache] setMemoryCapacity: 0];
    //        NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    //        [NSURLCache setSharedURLCache:sharedCache];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}


#pragma WebView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(self.delegate) {
        if([self.delegate respondsToSelector:@selector(loadComplete:)]) {
            NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
            [self.delegate loadComplete:title];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    // new for memory cleanup
    //    [[NSURLCache sharedURLCache] setMemoryCapacity: 0];
    //    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    //    [NSURLCache setSharedURLCache:sharedCache];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if(self.delegate) {
        if([self.delegate respondsToSelector:@selector(didStartLoad)]) {
            [self.delegate didStartLoad];
        }
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
