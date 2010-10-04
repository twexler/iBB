//
//  WebViewViewController.m
//  iBB
//
//  Created by Ted Wexler on 8/24/10.
//  Copyright 2010  . All rights reserved.
//

#import "WebViewViewController.h"


@implementation WebViewViewController

- (id)initWithURL:(NSURL*)url {
	if ((self = [super init]) != NULL){
		locUrl = [url retain];
		return self;
	}
	return nil;
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.navigationItem.title = @"History";
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(void)viewDidAppear:(BOOL)animated {
	[webView setDelegate:self];
	[webView loadRequest:[NSURLRequest requestWithURL:locUrl]];
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv {
	NSString *r = [wv stringByEvaluatingJavaScriptFromString:@"var a=document.getElementsByTagName(\"center\");a[0].innerHTML=\"\";a[3].innerHTML=\"\";a[4].innerHTML=\"\";var b=a[1].getElementsByTagName(\"table\");b[0].innerHTML=\"\";b[1].innerHTML=\"\";"];
	NSLog(@"js result %@", r);
}
@end
