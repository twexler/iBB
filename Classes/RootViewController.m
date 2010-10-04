//
//  RootViewController.m
//  iBB
//
//  Created by Ted Wexler on 8/6/10.
//  Copyright   2010. All rights reserved.
//

#import "RootViewController.h"
#import "TouchXML.h"
#import "ServerItem.h"
#import "ServiceItem.h"
#import "ServerDetailViewController.h"
#import "iBBAppDelegate.h"
#import "BBServer.h"
#import "AddBBServerViewController.h"
@implementation RootViewController

//@synthesize servers;
#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	[spinner stopAnimating];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (id)initWithBBServer:(BBServer*)theServer {
	if ((self = [super init]) != NULL){
		//server = [theServer retain];
		return self;
	}
	return nil;
}
- (void)viewWillAppear:(BOOL)animated {
	[spinner stopAnimating];
	tView = (UITableView*)self.view;
	colorArray = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor],@"green",[UIColor blueColor],@"blue",
				  [UIColor purpleColor],@"purple",[UIColor blackColor],@"black",[UIColor yellowColor],@"yellow",[UIColor redColor],@"red", nil];
	[colorArray retain];
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	spinner.frame = CGRectMake(290, 10, 20, 20);
	[self.navigationController.navigationBar addSubview:spinner];
	if ([bbServers count] > 1) {
		self.navigationItem.title = @"All Servers";
		[spinner startAnimating];
		for (BBServer *s in bbServers) {
			[self performSelectorInBackground:@selector(loadXML:) withObject:s];
		}
		[spinner stopAnimating];
	}
	else if ([bbServers count] == 1){
		BBServer *s = (BBServer*)[bbServers objectAtIndex:0];
		self.navigationItem.title = s.displayName;
		[spinner startAnimating];
		[self performSelectorInBackground:@selector(loadXML:) withObject:s];
	}
	else {
		AddBBServerViewController *addVC = [[AddBBServerViewController alloc] init];
		[self presentModalViewController:addVC animated:YES];
	}

    [super viewWillAppear:animated];
	[tView reloadData];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

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
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [bbServers count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
	if ([bbServers count] > 1) {
		BBServer *server = [bbServers objectAtIndex:section];
		return [server displayName];
	}
	else {
		return nil;
	}
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	/*if (servers) {
		return [servers count];
	}*/
	BBServer *s = (BBServer*)[bbServers objectAtIndex:section];
    return [s.servers count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	BBServer *s = (BBServer*)[bbServers objectAtIndex:[indexPath indexAtPosition:0]];
	ServerItem *i = [s.servers objectAtIndex:[indexPath indexAtPosition:1]];
    UIImageView *accessoryBlack = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AccDisclosure.png" ofType:nil]]];
	cell.accessoryView = accessoryBlack;
	[accessoryBlack release];
	cell.textLabel.text = i.name;
	NSLog(@"i.status is: %@", i.status);
	cell.textLabel.textColor = [colorArray objectForKey:i.status];
	// Configure the cell.
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


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
	
	 //ServerDetailViewController *detailViewController = [[ServerDetailViewController alloc] initWithNibName:@"ServerDetailViewController" bundle:nil];
	BBServer *s = (BBServer*)[bbServers objectAtIndex:[indexPath indexAtPosition:0]];
	ServerItem *i = [s.servers objectAtIndex:[indexPath indexAtPosition:1]];
	ServerDetailViewController *detailViewController = [[ServerDetailViewController alloc] initWithServerNameAndServices:i.name services:i.services];
	detailViewController.bbServerHost = s.xmlURL.host;
	 // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 
}

#pragma mark -
#pragma mark XML Methods
-(void)loadXML:(BBServer*)server {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSURL *url = server.xmlURL;
	NSMutableArray *servers = [[NSMutableArray alloc] init];
	
	CXMLDocument *rssParser = [[[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
	//NSLog(@"xml string: %@", [[NSString alloc] initWithData:[rssParser XMLData] encoding:NSUTF8StringEncoding]);
	NSArray *resultNodes = NULL;
	resultNodes = [rssParser nodesForXPath:@"//hosts/server" error:nil];
	for (CXMLElement *resultElement in resultNodes) {
		NSLog(@"server name: %@", [[resultElement attributeForName:@"name"] stringValue]);
		ServerItem *i = [[ServerItem alloc] initWithServerName:[[resultElement attributeForName:@"name"] stringValue]];
		NSLog(@"childCount is: %d\n", [resultElement childCount]);
		NSArray *serviceNodes = [resultElement nodesForXPath:@"service" error:nil];
		NSLog(@"serviceNodes count: %d", [serviceNodes count]);
		NSMutableArray *s = [[NSMutableArray alloc] init];
		for (CXMLElement *serviceElement in serviceNodes) {
			ServiceItem *j = [[ServiceItem alloc] init];
			j.name = [[serviceElement childAtIndex:1] stringValue];
			j.status = [[serviceElement childAtIndex:3] stringValue];
			/*if (j.status @"green") {
				
				i.status = j.status;
			}*/
			NSRange foo = [j.status rangeOfString:@"green"];
			if (foo.length == 0) {
				i.status = j.status;
			}
			//NSLog(@"range is: %@", [j.status rangeOfString:@"green"]);
			j.duration = (NSUInteger *)[[serviceElement childAtIndex:5] stringValue];
			[s addObject:j];
		}
		if (!i.status) {
			i.status = @"green";
		}
		i.services = s;
		[servers addObject:i];
		NSLog(@"double checking the server name: %@", i.name);
	}
	NSArray *sortedServers;
	NSSortDescriptor *sd = [[[NSSortDescriptor alloc] initWithKey:@"status" ascending:NO] autorelease];
	sortedServers = [servers sortedArrayUsingDescriptors:[NSArray arrayWithObject:sd]];
	[server setServers:(NSMutableArray*)sortedServers];
	[pool release];
	[self performSelectorOnMainThread:@selector(loadingFinished) withObject:nil waitUntilDone:YES];
}
-(void)loadingFinished {
	[spinner stopAnimating];
	[tView reloadData];
}
-(void)setBbServers:(NSArray *)input{
	[bbServers autorelease];
	bbServers = [input retain];
}
-(NSArray*)bbServers{
	return bbServers;
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


- (void)dealloc {
    [super dealloc];
}


@end

