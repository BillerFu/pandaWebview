//
//  LDBasicWebView.h
//  VideoPlsIVASDK
//
//  Created by Bill on 22/05/2017.
//  Copyright © 2017 videopls.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LDBasicWebViewCloseDelegate <NSObject>

@optional

- (void)removeBasicWebView;

@end

@interface LDBasicWebView : UIView

@property (nonatomic,weak) id<LDBasicWebViewCloseDelegate> delegate;

/**
 * SCREEN TYPE
 * 1:land screen
 * 2:stand screen
 */

/**
 * webView TYPE
 * 0:open platform webview anyway
 * 1:open video++ webview when isFullScreen is TURE
 * 2:open video++ webview anyway
 */
- (id)initWithFrame:(CGRect)frame isFullScreen:(BOOL)isFullScreen screenType:(NSInteger)screenType webViewType:(NSInteger)webViewType url:(NSString *)url;

@end
