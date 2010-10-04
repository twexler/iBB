//
//  iBBAppDelegate.h
//  iBB
//
//  Created by Ted Wexler on 8/6/10.
//  Copyright   2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBServer.h"
@interface iBBAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
	IBOutlet UIView *view;
	IBOutlet UITabBarController *tbController;
    UINavigationController *navigationController;
	NSMutableArray *bbServers;
	NSURL *passedURL;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (readonly, retain) NSMutableArray *bbServers;
-(void)addBBServer:(BBServer*)server;
-(void)deleteBBServer:(int)index;
-(BOOL)serializeBBServersAndSave:(NSMutableArray*)serverArray;
-(void)unSerializeAndPopulateBBServers;
@end

