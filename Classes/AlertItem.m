//
//  AlertItem.m
//  iBB
//
//  Created by Ted Wexler on 8/8/10.
//  Copyright 2010  . All rights reserved.
//

#import "AlertItem.h"


@implementation AlertItem

- (id)initWithServerName:(NSString *)theServerName
{
	if ((self = [super init]) != NULL){
		serverName = [theServerName retain];
		return self;
	}
	return nil;
}
-(NSString*)serverName {
	return serverName;
}
-(NSString*)name {
	return name;
}
-(NSDate*)date {
	return date;
}
-(NSString*)from {
	return from;
}
-(NSString*)to {
	return to;
}
-(void) setName:(NSString*)input {
	[name autorelease];
	name = [input retain];
}
-(void) setDate:(NSDate*)input {
	[date autorelease];
	date = [input retain];
}
-(void) setFrom:(NSString*)input {
	[from autorelease];
	from = [input retain];
}
-(void) setTo:(NSString*)input {
	[to autorelease];
	to = [input retain];
}
-(void) setTime:(NSString*)input {
	[date autorelease];
	NSDate *d = [NSDate dateWithTimeIntervalSince1970:[input doubleValue]];
	date = [d retain];
}
@end
