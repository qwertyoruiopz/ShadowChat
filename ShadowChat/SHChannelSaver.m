//
//  SHChannelSaver.m
//  ShadowChat
//
//  Created by Max Shavrick on 11/21/11.
//  Copyright (c) 2011 uiop. All rights reserved.
//

#import "SHChannelSaver.h"
#import "SHIRCNetwork.h"
#import "SHIRCChannel.h"
#import <objc/runtime.h>
@class SHIRCChannel;

@implementation SHChannelSaver

static id singleton = nil;

- (id)init {
	if ((self = [super init])) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		path = [[paths objectAtIndex:0] stringByAppendingString:@"/Rooms.plist"];
		[path retain];
	}
	singleton = self;
	return self;
}

- (void)saveChannels:(NSArray *)chans server:(NSString *)serv {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[chans retain];
	NSLog(@"fdsfds %@", chans);
	NSMutableDictionary *saves = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	[saves setObject:chans forKey:serv];
	if ([saves writeToFile:path atomically:YES]) 
		NSLog(@"yay saved... cleaning up");
	[saves release];
	[chans release];
	[pool drain];

}

- (NSArray *)roomsForServer:(id)serve {
	NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
	NSArray *rooms = [dict objectForKey:[serve server]];
	for (int i = 0; i < [rooms count]; i++) {
		NSLog(@"dsadas %@ %d", [rooms objectAtIndex:i], i);
		NSLog(@"dfsfds %@", [[SHIRCChannel alloc] initWithSocket:serve andChanName:[rooms objectAtIndex:i]]);
	}
	// need to make array of SHIRCChannels here and return it.. WTF IS HAPPENING!!?!??!!?!?!?! 
	
	return nil;
}

+ (id)sharedSaver {
	if (!singleton) singleton = [[self alloc] init];
	return singleton;
}

@end
