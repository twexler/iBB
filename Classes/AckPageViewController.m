//
//  AckPageViewController.m
//  iBB
//
//  Created by Ted Wexler on 8/7/10.
//  Copyright 2010  . All rights reserved.
//

#import "AckPageViewController.h"
#import "iBBAppDelegate.h"
#import "BBServer.h"
@implementation AckPageViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        UIImage *ackTabImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"117-todo.png" ofType:nil]];
		UITabBarItem *tbItem = [[UITabBarItem alloc] initWithTitle:@"Acknowledge" image:ackTabImage tag:2];
		self.tabBarItem = tbItem;
		appDelegate = (iBBAppDelegate*)[[UIApplication sharedApplication] delegate];
		bbServers = (NSArray*)appDelegate.bbServers;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hasURL"]) {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasURL"];
		NSURL *u = [[NSUserDefaults standardUserDefaults] URLForKey:@"url"];
		[[NSUserDefaults standardUserDefaults] setURL:nil forKey:@"url"];
		for (int i=0; i < [bbServers count]; i++) {
			BBServer *s = (BBServer*)[bbServers objectAtIndex:i];
			NSRange r = [[s.ackURL absoluteString] rangeOfString:u.host];
			if (r.length > 0) {
				acknowledgeURL = [s.ackURL absoluteString];
				[serverButton setTitle:s.displayName forState:UIControlStateNormal];
				NSString *code = [[[u query] componentsSeparatedByString:@"="] objectAtIndex:1];
				codeField.text = code;
			}
		}
	}
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
-(IBAction)goButtonClicked:(id)sender {
	if (acknowledgeURL.length == 0) {
		UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"You need to select a server!" 
													message:@"Select a server before clicking Go!" 
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[a show];
		[a release];
	}
	else {
		[self ackPage:[codeField text] duration:[durationField text]];
		[codeField resignFirstResponder];
		[durationField resignFirstResponder];
	}
}
-(IBAction)chooseButtonClicked:(id)sender
{
	[self showPicker:sender];
}
-(void)ackPage:(NSString*)secretCode duration:(NSString*)duration {
	NSString *query = [NSString stringWithFormat:@"%@ACTION=Ack&DELAY=%@&NUMBER=%@", acknowledgeURL, duration, secretCode];
	NSURL *url = [NSURL URLWithString:query];
	NSString *ret = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	NSRange foo = [ret rangeOfString:@"Acknowledgement Sent"];
	UIAlertView *alert = [[UIAlertView alloc] init];
	NSLog(@"ret was %@", ret);
	if (foo.length != 0) {
		alert.title = @"Acknowledgement Succesful";
		NSString *message = [NSString stringWithFormat:@"The event %@ was acknowledged for %@ minutes", secretCode, duration];
		alert.message = message;
		[alert addButtonWithTitle:@"OK"];
		[alert show];
	}
	else {
		alert.title = @"Acknowledgement Unsuccesful";
		alert.message = @"Something went wrong, please try again later";
		[alert addButtonWithTitle:@"OK"];
		[alert show];
	}
	[alert release];
	
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	if (row == 0) {
		return @"None";
	}
	else {
		BBServer *s = [bbServers objectAtIndex:row-1];
		return [s displayName];
	}
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return [bbServers count]+1;
}
- (void) showPicker:(id)sender {
    [codeField resignFirstResponder];
    [durationField resignFirstResponder];
	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:nil
													  delegate:self
											 cancelButtonTitle:@"Done"
										destructiveButtonTitle:nil
											 otherButtonTitles:nil];
	// Add the picker
	UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,75,0,0)];
	
	pickerView.delegate = self;
	pickerView.showsSelectionIndicator = YES;    // note this is default to NO
	
	[menu addSubview:pickerView];
	//[menu showInView:self.view];
	[menu showFromTabBar:self.tabBarController.tabBar];
	[menu setBounds:CGRectMake(0,0,320, 500)];
	
	[pickerView release];
	[menu release];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];

}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (row !=0) {
		BBServer *s = (BBServer*)[bbServers objectAtIndex:row-1];
		acknowledgeURL = [s.ackURL absoluteString];
		[serverButton setTitle:s.displayName forState:UIControlStateNormal];
	}
	else {
		acknowledgeURL = nil;
		[serverButton setTitle:@"Choose..." forState:UIControlStateNormal];
	}

}
-(IBAction)dismissKeyboard:(id)sender {
    [sender resignFirstResponder];
}
@end
