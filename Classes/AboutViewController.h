//
//  AboutViewController.h
//  iBB
//
//  Created by Ted Wexler on 10/4/10.
//  Copyright 2010  . All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutViewController : UIViewController {
	IBOutlet UITextView *textView;
}
-(IBAction)doneButtonPressed:(id)sender;
@end
