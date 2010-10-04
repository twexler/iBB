//
//  AlertItem.h
//  iBB
//
//  Created by Ted Wexler on 8/8/10.
//  Copyright 2010  . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlertItem : NSObject {
	NSString *serverName;
	NSString *name;
	NSDate *date;
	NSString *from;
	NSString *to;
}
- (id)initWithServerName:(NSString *)theServerName;
@property (readonly, retain) NSString *serverName;
@property (readwrite, retain) NSString *name;
@property (readwrite, retain) NSDate *date;
@property (readwrite, retain) NSString *from;
@property (readwrite, retain) NSString *to;
@end
