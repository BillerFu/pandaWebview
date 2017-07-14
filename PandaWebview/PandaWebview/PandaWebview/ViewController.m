//
//  ViewController.m
//  PandaWebview
//
//  Created by Bill on 13/07/2017.
//  Copyright © 2017 Bill. All rights reserved.
//

#import "ViewController.h"
#import "LDBasicWebView.h"
#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>

#define rectStatusBar       [UIApplication sharedApplication].statusBarFrame.size.height
#define kDeviceHeight       [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth        [UIScreen mainScreen].bounds.size.width
#define kVideoAreaHeight    kDeviceWidth / 16 * 9
#define screenScale         kDeviceWidth / 414

@interface ViewController ()<LDBasicWebViewCloseDelegate>{
    
    LDBasicWebView  *webview;
    LDBasicWebView  *basicWebview;
    UITextField     *urlTextField;
}

@property (nonatomic) UITapGestureRecognizer *tapGes;
@property (nonatomic) BOOL isShow;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _isShow = NO;
    
    [self initVideoView];
    [self initTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openWebview:)
                                                 name:@"LDSDKWebViewURL"
                                               object:nil];
}

- (void)openWebview:(NSNotification *)noti {

    NSString *webUrl = [noti.userInfo objectForKey:@"url"];
    if (![webUrl isEqualToString:@"about:blank"]) {
        if (!_isShow) {
            basicWebview = [[LDBasicWebView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)
                                                    isFullScreen:YES
                                                      screenType:1
                                                     webViewType:3
                                                             url:webUrl];
            basicWebview.delegate = self;
            [self.view addSubview:basicWebview];
            _isShow = YES;
        }
    }
}

- (void)initVideoView {
    
    UIImage       *image            = [UIImage imageNamed:@"1"];
    UIImageView   *fakeImageView    = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [fakeImageView setImage:image];
    [self.view addSubview:fakeImageView];
    
    UIView *videoAreaView = [[UIView alloc] initWithFrame:CGRectMake(0, rectStatusBar, kDeviceWidth, kVideoAreaHeight)];
    [videoAreaView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:videoAreaView];
    
    UIView *switchView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(videoAreaView.frame), kDeviceWidth, 44 * screenScale)];
    [switchView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:switchView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight - 55 * screenScale, kDeviceWidth, 55 * screenScale)];
    [bottomView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:bottomView];
    
    _tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoPlsAdTapped:)];
    [videoAreaView addGestureRecognizer:_tapGes];
}

- (void)videoPlsAdTapped:(UITapGestureRecognizer *)sender {
    
    NSString *webUrl = urlTextField.text.copy;
    
    webview = [[LDBasicWebView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) isFullScreen:YES screenType:1 webViewType:1 url:webUrl];
    webview.delegate = self;
    
    [self.view addSubview:webview];
}

- (void)initTextField {
    
    urlTextField                    = [[UITextField alloc] initWithFrame:CGRectMake(10,
                                                                             kVideoAreaHeight + rectStatusBar - 40,
                                                                             kDeviceWidth - 20,
                                                                             30)];
    urlTextField.backgroundColor    = [UIColor whiteColor];
    urlTextField.font               = [UIFont systemFontOfSize:11.f];
    urlTextField.textColor          = [UIColor grayColor];
    urlTextField.text               = @"http://sdkcdn.videojj.com/liveos-sdk/webview.html?platformId=556c38e7ec69d5bf655a0fb2&platformUserId=81&env=test";
    
    [self.view addSubview:urlTextField];
}

- (void)removeBasicWebView {
    _isShow = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (![urlTextField isExclusiveTouch]) {
        CGFloat duration = 0.5;
        [UIView animateWithDuration:duration animations:^{
            self.view.transform = CGAffineTransformIdentity;
            [urlTextField resignFirstResponder];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
}

@end
