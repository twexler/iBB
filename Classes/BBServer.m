//
//  BBServer.m
//  iBB
//
//  Created by Ted Wexler on 8/9/10.
//  Copyright 2010  . All rights reserved.
//

#import "BBServer.h"


@implementation BBServer
-(id)initWithNameAndURLs:(NSString*)name xmlURL:(NSURL*)xURL ackURL:(NSURL*)aURL {
	if ((self = [super init]) != NULL){
		displayName = [name retain];
		xmlURL = [xURL retain];
		ackURL = [aURL retain];
		return self;
	}
	return nil;
}
-(NSString*)displayName {
	return displayName;
}
-(NSURL*)ackURL {
	return ackURL;
}
-(NSURL*)xmlURL {
	return xmlURL;
}
-(NSMutableArray*)servers {
	return servers;
}
-(NSMutableArray*)alerts {
	return alerts;
}
-(NSUInteger)alertPeriod {
    return alertPeriod;
}
-(void)setAlertPeriod:(NSUInteger)input{
    alertPeriod = input;
}
-(void)setAlerts:(NSMutableArray *)input{
	[alerts autorelease];
	alerts = [input retain];
}
-(void)setServers:(NSMutableArray *)input{
	[servers autorelease];
	servers = [input retain];
}
-(void)setAckURL:(NSURL *)input{
	[ackURL autorelease];
	ackURL = [input retain];
}
-(void)setXmlURL:(NSURL *)input{
	[xmlURL autorelease];
	xmlURL = [input retain];
}
-(void)setDisplayName:(NSString *)input{
	[displayName autorelease];
	displayName = [input retain];
}
#pragma mark NSCoding Protocol

- (void)encodeWithCoder:(NSCoder *)encoder;
{
    [encoder encodeObject:[self displayName] forKey:@"displayName"];
    [encoder encodeObject:[self xmlURL] forKey:@"xmlURL"];
	[encoder encodeObject:[self ackURL] forKey:@"ackURL"];
	[encoder encodeInt:[self alertPeriod] forKey:@"alertPeriod"];
}

- (id)initWithCoder:(NSCoder *)decoder;
{
    if ( ![super init] )
        return nil;
	
    [self setDisplayName:[decoder decodeObjectForKey:@"displayName"]];
    [self setXmlURL:[decoder decodeObjectForKey:@"xmlURL"]];
	[self setAckURL:[decoder decodeObjectForKey:@"ackURL"]];
	[self setAlertPeriod:[decoder decodeIntForKey:@"alertPeriod"]];
    return self;
}
#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone {
	BBServer *copy = [[[self class] allocWithZone:zone] init];
	copy.ackURL = [[self.ackURL copyWithZone:zone] autorelease];
	copy.displayName = [[self.displayName copyWithZone:zone] autorelease];
	copy.xmlURL = [[self.xmlURL copyWithZone:zone] autorelease];
	copy.alertPeriod = self.alertPeriod;
	return copy;
}
@end
