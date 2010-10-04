//
//  ServerDetailViewController.h
//  iBB
//
//  Created by Ted Wexler on 8/6/10.
//  Copyright 2010  . All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServiceItem;
@interface ServerDetailViewController : UITableViewController {
	NSArray *services;
	NSString *serverName;
	IBOutlet UITableView *tView;
	NSString *bbServerHost;
}
- (id)initWithServerNameAndServices:(NSString *)name services:(NSArray*)s;
@property (assign, readwrite) NSString *bbServerHost;
@end
