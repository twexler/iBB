//
//  RootViewController.h
//  iBB
//
//  Created by Ted Wexler on 8/6/10.
//  Copyright   2010. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServerItem;
@class ServiceItem;
@class BBServer;
@interface RootViewController : UITableViewController {
	NSArray *bbServers;
	NSDictionary *colorArray;
	IBOutlet UITableView *tView;
	UIActivityIndicatorView *spinner;
}
@property (readwrite, retain) NSArray *bbServers;
- (id)initWithBBServer:(BBServer*)theServer;
-(void)loadXML:(BBServer*)server;
-(void)loadingFinished;
@end
