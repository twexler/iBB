//
//  ServiceItem.h
//  iBB
//
//  Created by Ted Wexler on 8/6/10.
//  Copyright 2010  . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ServiceItem : NSObject {
	NSString *name;
	NSString *status;
	NSUInteger *duration;
}
@property (readwrite, retain) NSString *name;
@property (readwrite, retain) NSString *status;
@property (readwrite) NSUInteger *duration;
@end
