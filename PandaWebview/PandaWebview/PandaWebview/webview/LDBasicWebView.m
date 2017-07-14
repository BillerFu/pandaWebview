//
//  LDBasicWebView.m
//  VideoPlsIVASDK
//
//  Created by Bill on 22/05/2017.
//  Copyright © 2017 videopls.com. All rights reserved.
//

#import "LDBasicWebView.h"
#import "LDWebView.h"

#define rectStatusBar       [UIApplication sharedApplication].statusBarFrame.size.height
#define kDeviceHeight       [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth        [UIScreen mainScreen].bounds.size.width
#define kVideoAreaHeight    kDeviceWidth / 16 * 9
#define screenScale         kDeviceWidth / 414

@interface LDBasicWebView()<LDWebViewDelegate>

@property (nonatomic) LDWebView *webView;
@property (nonatomic) UIButton *backButton;
@property (nonatomic) UIButton *closeButton;
@property (nonatomic) UILabel *titleLabel;

@property (nonatomic) CGRect   storedFrame;

@property (nonatomic) NSString *linkUrl;
@property (nonatomic) NSString *htmlString;

@property (nonatomic) NSInteger screenType;
@property (nonatomic) UIView *totalCoverView;
@property (nonatomic) UITapGestureRecognizer *coverViewTapGesture;

@end

@implementation LDBasicWebView

- (id)initWithFrame:(CGRect)frame isFullScreen:(BOOL)isFullScreen screenType:(NSInteger)screenType webViewType:(NSInteger)webViewType url:(NSString *)url {
    
    if (url == nil || [url isEqualToString:@""]) {
        return nil;
    }
    _storedFrame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);

    self.screenType = 2;
    if ([self webViewTypeCheck:webViewType isFullScreen:isFullScreen]) {

        self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height + (frame.size.height - frame.size.width/16*9 - 64))];

        if(self) {
            _linkUrl = url;
            [self initViewWithType:webViewType];
        }
    }else {
        [self postWebViewNotification:url];
        return nil;
    }
    return self;
}

- (void) initViewWithType:(NSInteger)type {
    
    _webView = [LDWebView initWebViewWithFrame:CGRectMake(0,
                                                          self.frame.size.height - (kDeviceHeight - kVideoAreaHeight - rectStatusBar - 44 * screenScale),
                                                          kDeviceWidth ,
                                                          (kDeviceHeight - kVideoAreaHeight - 44 * screenScale - rectStatusBar - 55 * screenScale)) type:type];
    
    _totalCoverView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               kDeviceWidth,
                                                               self.frame.size.height - (kDeviceHeight - kVideoAreaHeight - 44 * screenScale - rectStatusBar))];
    
    _webView.delegate = self;
    
    [self addSubview:_webView];
    if(_linkUrl) {
        [_webView startLoadingWithUrl:_linkUrl];
    }
    if (self.coverViewTapGesture) {
        self.coverViewTapGesture = nil;
    }
    self.coverViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeViewTapped:)];
    [self addSubview:_totalCoverView];
    [_totalCoverView addGestureRecognizer:self.coverViewTapGesture];
    
    [UIView animateWithDuration:0.4f animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, - (kDeviceHeight - kVideoAreaHeight - 44 * screenScale - rectStatusBar));
    }completion:^(BOOL finished) {
        
    }];
}

- (void)closeViewTapped:(UITapGestureRecognizer *)sender {
    
    __weak typeof(self) weakSelf = self;
    if (self.frame.size.width > self.frame.size.height) {
        [UIView animateWithDuration:0.4f animations:^{
            weakSelf.transform = CGAffineTransformMakeTranslation(self.frame.size.width * 4/7, 0);
        }completion:^(BOOL finished) {
            [self removeBasicWebview];
            if([weakSelf.delegate respondsToSelector:@selector(removeBasicWebView)]) {
                [weakSelf.delegate removeBasicWebView];
            }
            [_webView removeCache];
        }];
    }else{
        [UIView animateWithDuration:0.4f animations:^{
            weakSelf.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height/2);
        }completion:^(BOOL finished) {
            [self removeBasicWebview];
            if([weakSelf.delegate respondsToSelector:@selector(removeBasicWebView)]) {
                [weakSelf.delegate removeBasicWebView];
            }
            [_webView removeCache];
        }];
    }
}

- (BOOL)webViewTypeCheck:(NSInteger)webViewType isFullScreen:(BOOL)isFullScreen {
    
    if (webViewType == 0) {
        return NO;
    }else if (webViewType == 1){
        if (isFullScreen) {
            return YES;
        }else {
            return NO;
        }
    }else if (webViewType == 2){
        return YES;
    }else if (webViewType == 3){
        return YES;
    }else{
        return NO;
    }
}

- (void)postWebViewNotification:(NSString *)webUrl{
    
    NSDictionary *userInfo;
    if (webUrl) {
        userInfo = [NSDictionary dictionaryWithObject:webUrl forKey:@"url"];
    }else {
        userInfo = nil;
    }
    NSNotification *openWeb =[NSNotification notificationWithName:@"LDSDKWebViewURL" object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:openWeb];
}

- (void)removeBasicWebview {
    [_totalCoverView removeFromSuperview];
    [_webView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma LDWebViewDelegate
- (void)loadComplete:(NSString *)title {
    if([_webView canGoBack]) {
        [_closeButton setHidden:NO];
    }
    else {
        [_closeButton setHidden:YES];
    }
}

- (void)didStartLoad {
    if([_webView canGoBack]) {
        [_closeButton setHidden:NO];
    }
}

@end
