//
//  AddBBServerViewController.m
//  iBB
//
//  Created by Ted Wexler on 8/9/10.
//  Copyright 2010. All rights reserved.
//

#import "AddBBServerViewController.h"
#import "BBServer.h"
#import "iBBAppDelegate.h"

#define DEBUG_SERVER_XML @""
#define DEBUG_SERVER_ACK @""

@implementation AddBBServerViewController

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
#ifdef DEBUG
- (void)viewDidLoad {
	appDelegate = (iBBAppDelegate*)[[UIApplication sharedApplication] delegate];
	[displayNameField setText:@"NS2"];
	[xmlURLField setText:DEBUG_SERVER_XML];
	[ackURLField setText:DEBUG_SERVER_ACK];
    [super viewDidLoad];
}
#endif

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
-(IBAction)save:(id)sender {
	BBServer *s = [[BBServer alloc] initWithNameAndURLs:[displayNameField text] 
												 xmlURL:[NSURL URLWithString:[xmlURLField text]] 
												 ackURL:[NSURL URLWithString:[ackURLField text]]];
	NSTimeInterval t = [alertTimePeriodPicker countDownDuration];
    [s setAlertPeriod:(NSUInteger)t];
	[appDelegate addBBServer:s];
	[s release];
	[self dismissModalViewControllerAnimated:YES];
	[[self delegate] BBServerAddViewControllerFinished:self didAddServer:s];
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
-(id)delegate {
	return delegate;
}
-(void)setDelegate:(id)input{
	[delegate autorelease];
	delegate = [input retain];
}
-(IBAction)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}
@end
