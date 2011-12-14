//
//  SHWebBrowser.h
//  ShadowChat
//
//  Created by Max Shavrick on 12/13/11.
//  Copyright (c) 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHWebBrowser : UIViewController <UIWebViewDelegate> {
	UIWebView *_browser;
}
- (void)setURLToLoad:(NSURL *)aURL;
@end
