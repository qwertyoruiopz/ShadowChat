//
//  SHChannelSaver.m
//  ShadowChat
//
//  Created by Max Shavrick on 11/21/11.
//  Copyright (c) 2011 uiop. All rights reserved.
//

#import "SHChannelSaver.h"

@implementation SHChannelSaver

static id singleton = nil;

- (id)init {
	if ((self = [super init])) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		path = [[paths objectAtIndex:0] stringByAppendingString:@"/Rooms.plist"];
	}
	singleton = self;
	return self;
}

- (void)saveChannels:(NSString *)serv rooms:(NSArray *)rooms {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSMutableDictionary *saves = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	[saves setObject:rooms forKey:serv];
	[saves writeToFile:path atomically:YES];
	[saves release];
	[pool drain];

}

- (NSArray *)roomsForServer:(NSString *)server {
	return nil;
}

+ (id)sharedSaver {
	if (!singleton) singleton = [[self alloc] init];
	return singleton;
}

@end
