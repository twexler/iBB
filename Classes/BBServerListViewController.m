//
//  BBServerListViewController.m
//  iBB
//
//  Created by Ted Wexler on 8/10/10.
//  Copyright 2010  . All rights reserved.
//

#import "BBServerListViewController.h"
#import "BBServer.h"
#import "iBBAppDelegate.h"
#import "AddBBServerViewController.h"
#import "RootViewController.h"

@implementation BBServerListViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	UIImage *ncTabImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"69-display.png" ofType:nil]];
	UITabBarItem *tbItem = [[UITabBarItem alloc] initWithTitle:@"Status" image:ncTabImage tag:1];
	self.tabBarItem = tbItem;
	self.navigationItem.title = @"Big Brother Servers";
	//tView.hidden = YES;
    [super viewDidLoad];
	tView = (UITableView*)self.view;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated {
	colorArray = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor],@"green",[UIColor blueColor],@"blue",
				  [UIColor purpleColor],@"purple",[UIColor blackColor],@"black",[UIColor yellowColor],@"yellow",[UIColor redColor],@"red", nil];
	[colorArray retain];
	iBBAppDelegate *appDelegate = (iBBAppDelegate*)[[UIApplication sharedApplication] delegate];
	bbServers = appDelegate.bbServers;
	if ([bbServers count] > 0) {
		//this is self.view because of weirdness in navigation controllers
		[editButton setEnabled:YES];
		[tView reloadData];
	}
	else {
		AddBBServerViewController *addVC = [[AddBBServerViewController alloc] init];
		[self presentModalViewController:addVC animated:YES];
		[editButton setEnabled:YES];
	}
	
    [super viewWillAppear:animated];
}
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [bbServers count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if ([indexPath indexAtPosition:1] == 0) {
		cell.textLabel.text = @"All Servers";
	}
	else {
		BBServer *s = (BBServer*)[bbServers objectAtIndex:[indexPath indexAtPosition:1]-1];
		cell.textLabel.text = s.displayName;
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	if ([indexPath indexAtPosition:1] != 0) {
		return YES;
	}
	return NO;
}




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
		if (editingStyle == UITableViewCellEditingStyleDelete) {
			// Delete the row from the data source
			iBBAppDelegate *appDelegate = (iBBAppDelegate*)[[UIApplication sharedApplication] delegate];
			[appDelegate deleteBBServer:[indexPath indexAtPosition:1]-1];
			bbServers = nil;
			bbServers = appDelegate.bbServers;
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
			if (bbServers.count == 0) {
				[editButton setStyle:UIBarButtonItemStyleBordered];
				[editButton setTitle:@"Edit"];
				[editButton setEnabled:NO];
				[tView setEditing:NO];
			}
		}   
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	if ([indexPath indexAtPosition:1] == 0) {
		RootViewController *detailViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
		detailViewController.bbServers = bbServers;
		[self.navigationController pushViewController:detailViewController animated:YES];
	}
	else {
		BBServer *s = (BBServer*)[bbServers objectAtIndex:[indexPath indexAtPosition:1]-1];
		RootViewController *detailViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
		detailViewController.bbServers = [NSArray arrayWithObject:s];
		[self.navigationController pushViewController:detailViewController animated:YES];
	}


}

-(IBAction)addButtonPressed:(id)sender {
	AddBBServerViewController *addVC = [[AddBBServerViewController alloc] init];
	addVC.delegate = self;
	[self presentModalViewController:addVC animated:YES];
	//[addVC release];
}
- (void)BBServerAddViewControllerFinished:(AddBBServerViewController *)addBBServerViewController didAddServer:(BBServer *)bbServer
{
	//[self loadXML:bbServer];
	[tView reloadData];
}
#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

-(IBAction)editButtonPressed:(id)sender {
	if (tView.isEditing) {
		[editButton setTitle:@"Edit"];
		[editButton setStyle:UIBarButtonItemStyleBordered];
		[tView setEditing:NO animated:YES];
	}
	else {
		[tView setEditing:YES animated:YES];
		//editButton.title = @"Done";
		[editButton setTitle:@"Done"];
		[editButton setStyle:UIBarButtonItemStyleDone];
	}


}

- (void)dealloc {
    [super dealloc];
}


@end

