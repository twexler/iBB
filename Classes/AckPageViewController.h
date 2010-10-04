//
//  AckPageViewController.h
//  iBB
//
//  Created by Ted Wexler on 8/7/10.
//  Copyright 2010  . All rights reserved.
//

#import <UIKit/UIKit.h>
@class iBBAppDelegate;

@interface AckPageViewController : UIViewController <UIActionSheetDelegate, UIPickerViewDelegate> {
	IBOutlet UITextField *codeField;
	IBOutlet UITextField *durationField;
	IBOutlet UIButton *serverButton;
	NSArray *bbServers;
	NSString *acknowledgeURL;
	iBBAppDelegate *appDelegate;
}
-(IBAction)goButtonClicked:(id)sender;
-(void)ackPage:(NSString*)secretCode duration:(NSString*)duration;
-(IBAction)chooseButtonClicked:(id)sender;
-(void)showPicker:(id)sender;
-(IBAction)dismissKeyboard:(id)sender;
@end
