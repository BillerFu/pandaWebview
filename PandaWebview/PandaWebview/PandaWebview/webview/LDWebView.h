//
//  LDWebView.h
//  VideoPlsIVASDK
//
//  Created by Bill on 16/10/10.
//  Copyright © 2016年 videopls.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@protocol LDWebViewDelegate <NSObject>
@optional
- (void)loadComplete:(NSString *)title;
- (void)didStartLoad;

@end

@interface LDWebView : UIView

@property (nonatomic,weak) id<LDWebViewDelegate> delegate;

+ (LDWebView *)initWebViewWithFrame:(CGRect)frame type:(NSInteger)type;

- (void)initWebView;

- (void)startLoadingWithUrl:(NSString *)url;
- (void)startLoadingWithHtmlString:(NSString *)htmlString;

- (BOOL)canGoBack;
- (void)goBack;

- (void)removeCache;


@end
