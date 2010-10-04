//
//  ServerItem.m
//  iBB
//
//  Created by Ted Wexler on 8/6/10.
//  Copyright 2010  . All rights reserved.
//

#import "ServerItem.h"


@implementation ServerItem
@synthesize name, services;
- (id)initWithServerName:(NSString *)serverName
{
	if ((self = [super init]) != NULL){
		name = [serverName retain];
		return self;
	}
	return nil;
}
-(NSMutableArray*)services {
	return services;
}
-(NSString*)name {
	return name;
}
-(NSString*)status {
	return status;
}
-(void) setStatus:(NSString*)input {
	[status autorelease];
	status = [input retain];
}
-(void) setServices:(NSMutableArray *)input {
	[services autorelease];
	services = [input retain];
}
-(void) dealloc {
	[name dealloc];
	[services dealloc];
	[super dealloc];
}
@end
