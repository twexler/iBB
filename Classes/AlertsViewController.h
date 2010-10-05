//
//  AlertsViewController.h
//  iBB
//
//  Created by Ted Wexler on 8/8/10.
//  Copyright 2010  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBBAppDelegate.h"
#import "AddBBServerViewController.h"
#import "PullRefreshTableViewController.h"
//pull to refresh
#import <QuartzCore/QuartzCore.h>
@interface AlertsViewController : UIViewController <BBServerAddDelegate>{
	NSDictionary *colorArray;
	IBOutlet UITableView *tView;
	IBOutlet UITableViewCell *tCell;
	IBOutlet UIActivityIndicatorView *spinner;
	IBOutlet UILabel *timePeriodLabel;
	iBBAppDelegate *appDelegate;
	NSArray *bbServers;
    
    //Pull to Refresh
    
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    
}
-(void)loadXML:(BBServer*)server;
-(IBAction)addButtonPressed:(id)sender;
-(IBAction)aboutButtonPressed:(id)sender;
-(void)reloadData;

//Pull to Refresh

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;
@end
