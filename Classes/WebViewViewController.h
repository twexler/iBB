//
//  WebViewViewController.h
//  iBB
//
//  Created by Ted Wexler on 8/24/10.
//  Copyright 2010  . All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *webView;
	NSURL *locUrl;
}

@end
