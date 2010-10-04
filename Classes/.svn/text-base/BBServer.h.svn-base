//
//  BBServer.h
//  iBB
//
//  Created by Ted Wexler on 8/9/10.
//  Copyright 2010  . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BBServer : NSObject <NSCoding, NSCopying> {
	NSString *displayName;
	NSURL *xmlURL;
	NSURL *ackURL;
    NSUInteger alertPeriod;
	NSMutableArray *alerts;
	NSMutableArray *servers;
}
@property (readonly, retain) NSString *displayName;
@property (readonly, retain) NSURL *xmlURL;
@property (readonly, retain) NSURL *ackURL;
@property (readwrite, retain) NSMutableArray *alerts;
@property (readwrite, retain) NSMutableArray *servers;
-(id)initWithNameAndURLs:(NSString*)name xmlURL:(NSURL*)xURL ackURL:(NSURL*)aURL;
@property (readwrite) NSUInteger alertPeriod;
@end
