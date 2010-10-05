//
//  AlertsViewController.m
//  iBB
//
//  Created by Ted Wexler on 8/8/10.
//  Copyright 2010  . All rights reserved.
//

#import "AlertsViewController.h"
#import "AlertItem.h"
#import "ServerDetailViewController.h"
#import "TouchXML.h"
#import "BBServer.h"
#import "iBBAppDelegate.h"
#import "AddBBServerViewController.h"
#import "AboutViewController.h"
#import "NSDate+HumanInterval.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@implementation AlertsViewController
//Pull To Refresh
@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;

- (void)viewWillAppear:(BOOL)animated {
	colorArray = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor],@"green",[UIColor blueColor],@"blue",
				  [UIColor purpleColor],@"purple",[UIColor blackColor],@"black",[UIColor yellowColor],@"yellow",[UIColor redColor],@"red", nil];
	[colorArray retain];
	appDelegate = (iBBAppDelegate*)[[UIApplication sharedApplication] delegate];
	bbServers = (NSArray*)appDelegate.bbServers;
	[self reloadData];
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		UIImage *alertTabImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"59-flag.png" ofType:nil]];
        UITabBarItem *tbItem = [[UITabBarItem alloc] initWithTitle:@"Alerts" image:alertTabImage tag:0];
		self.tabBarItem = tbItem;
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPullToRefreshHeader];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
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
    BBServer *server = [bbServers objectAtIndex:section];
    return [server displayName];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BBServer *s = [bbServers objectAtIndex:section];
	if (s.alerts) {
		return [s.alerts count];
	}
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"AlertCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"AlertTableViewCell" owner:self options:nil];
		cell = tCell;
		tCell = nil;
    }
    // Configure the cell.
	BBServer *s = [bbServers objectAtIndex:[indexPath indexAtPosition:0]];
	AlertItem *item = [s.alerts objectAtIndex:[indexPath indexAtPosition:1]];
	NSString *fromString = item.from;
	NSLog(@"from string is %@", fromString);
	NSString *statusString = [NSString stringWithFormat:@"Went from %@ to %@", item.from, item.to];
	NSLog(@"status string is: %@ and item.from is: %@", statusString, item.from);
	UILabel *serverLabel = (UILabel *)[cell viewWithTag:1];
	serverLabel.text = item.serverName;
	serverLabel = nil;
	UILabel *statusLabel = (UILabel *)[cell viewWithTag:2];
	statusLabel.text = statusString;
	statusLabel = nil;
	UILabel *dateLabel = (UILabel *)[cell viewWithTag:3];
	//dateLabel.text = [NSDateFormatter localizedStringFromDate:item.date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
	dateLabel.text = [NSString stringWithFormat:@"%@ ago", [item.date humanIntervalSinceNow]];
	dateLabel = nil;
	UILabel *typeLabel = (UILabel *)[cell viewWithTag:4];
	typeLabel.text = item.name;
	typeLabel = nil;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//ServerDetailViewController *detailViewController = [[ServerDetailViewController alloc] initWithNibName:@"ServerDetailViewController" bundle:nil];
	//ServerItem *i = [servers objectAtIndex:[indexPath indexAtPosition:1]];
	//ServerDetailViewController *detailViewController = [[ServerDetailViewController alloc] initWithServerNameAndServices:i.name services:i.services];
	// ...
	// Pass the selected object to the new view controller.
	//[self.navigationController pushViewController:detailViewController animated:YES];
	//[detailViewController release];
	
}

-(void)loadXML:(BBServer*)server {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSMutableArray *alerts = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&alertPeriod=%d", [server.xmlURL absoluteString], server.alertPeriod]];
	CXMLDocument *rssParser = [[CXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil];
	NSArray *resultNodes = NULL;
	resultNodes = [rssParser nodesForXPath:@"//alerts/alert" error:nil];
	for (CXMLElement *resultElement in resultNodes) {
		NSLog(@"server name: %@", [[resultElement attributeForName:@"name"] stringValue]);
		AlertItem *i = [[AlertItem alloc] initWithServerName:[[resultElement attributeForName:@"name"] stringValue]];
		NSLog(@"childCount is: %d\n", [resultElement childCount]);
		
        // Create a counter variable as type "int"
        int counter;
        // Loop through the children of the current  node
        for(counter = 0; counter < [resultElement childCount]; counter++) {
			NSRange textRange = [[[resultElement childAtIndex:counter] name] rangeOfString:@"text"];
			if (textRange.length == 0) {
				SEL setVar;
				NSString *selString = [NSString stringWithFormat:@"set%@:",[[[resultElement childAtIndex:counter] name] capitalizedString]];
				NSLog(@"selector is: %@", selString);
				setVar = NSSelectorFromString(selString);
				[i performSelector:setVar withObject:[[resultElement childAtIndex:counter] stringValue]];
				NSLog(@"name is: %@, value is: %@", [[resultElement childAtIndex:counter] name], [[resultElement childAtIndex:counter] stringValue]);
			}
        }
		[alerts addObject:i];
		[i release];
	}
	NSArray *sortedServers;
	NSSortDescriptor *sd = [[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO] autorelease];
	sortedServers = [alerts sortedArrayUsingDescriptors:[NSArray arrayWithObject:sd]];
	[server setAlerts:sortedServers];
	[spinner stopAnimating];
	[pool release];
	[tView reloadData];
}

- (void)BBServerAddViewControllerFinished:(AddBBServerViewController *)addBBServerViewController didAddServer:(BBServer *)bbServer
{
	[self loadXML:bbServer];
}
-(IBAction)addButtonPressed:(id)sender {
	AddBBServerViewController *addVC = [[AddBBServerViewController alloc] init];
	addVC.delegate = self;
	[self presentModalViewController:addVC animated:YES];
	[addVC release];
}
-(IBAction)aboutButtonPressed:(id)sender {
	AboutViewController	*aboutVC = [[AboutViewController alloc] init];
	[self presentModalViewController:aboutVC animated:YES];
	[aboutVC release];
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

#pragma mark - 
#pragma mark Reload Method
-(void)reloadData {
    if ([bbServers count] > 0) {
		for (BBServer *s in bbServers) {
			if (s.alertPeriod <= 0) {
				[s setAlertPeriod:3600];
			}
			[spinner startAnimating];
			[self performSelectorInBackground:@selector(loadXML:) withObject:s];
			timePeriodLabel.text = [NSString stringWithFormat:@"From the last %d hours", s.alertPeriod/3600];
			//[self loadXML:s];
		}
	}
	else {
		AddBBServerViewController *addVC = [[AddBBServerViewController alloc] init];
		addVC.delegate = self;
		[self presentModalViewController:addVC animated:YES];
		[addVC release];
	}
    [tView reloadData];
}
- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark From PullToRefresh
- (void)addPullToRefreshHeader {
    textPull = [[NSString alloc] initWithString:@"Pull down to refresh..."];
    textRelease = [[NSString alloc] initWithString:@"Release to refresh..."];
    textLoading = [[NSString alloc] initWithString:@"Loading..."];
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
	
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
	
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 27) / 2,
                                    (REFRESH_HEADER_HEIGHT - 44) / 2,
                                    27, 44);
	
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 20) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
	
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [tView addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            tView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            tView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
	
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    tView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
	
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
	
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    tView.contentInset = UIEdgeInsetsZero;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(reloadData)];
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}
@end
