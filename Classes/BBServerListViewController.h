//
//  BBServerListViewController.h
//  iBB
//
//  Created by Ted Wexler on 8/10/10.
//  Copyright 2010  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddBBServerViewController.h"

@interface BBServerListViewController : UITableViewController <BBServerAddDelegate> {
	NSDictionary *colorArray;
	IBOutlet UITableView *tView;
	NSMutableArray *bbServers;
	IBOutlet UIBarButtonItem *editButton;
}
-(IBAction)addButtonPressed:(id)sender;
-(IBAction)editButtonPressed:(id)sender;
@end
