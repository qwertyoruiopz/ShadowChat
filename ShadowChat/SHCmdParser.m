//
//  SHCmdParser.m
//  ShadowChat
//
//  Created by Max Shavrick on 11/12/11.
//  Copyright (c) 2011 uiop. All rights reserved.
//

#import "SHCmdParser.h"

@implementation SHCmdParser
static id sharedParser = nil;
- (id)init {
	if ((self = [super init])) {
		cmds = [[NSMutableDictionary alloc] init];
		id fakeCmds = [[NSArray alloc] initWithObjects:@"kick", @"op", @"deop", @"halfop", @"dehalfop", @"invite", @"part", @"join", @"ping", @"privmsg", @"query", @"version", @"nick", @"me", @"msg", @"partall", @"ignore", @"quit", @"whois", @"help", @"kill", @"die", @"connect", @"info", @"list", @"motd", @"oper", @"version", @"whowas", @"topic", nil];
		for (int i = 0; i < [fakeCmds count]; i++) {
			[cmds setObject:[fakeCmds objectAtIndex:i] forKey:[[fakeCmds objectAtIndex:i] uppercaseString]];
		}
	}
	sharedParser = self;
	return self;
}
+ (id)sharedParser {
	if (!sharedParser) return [[self alloc] init];
	return sharedParser;
}
- (void)setEnteredCommand:(NSString *)aCmd shouldParseCaseSensitive:(BOOL)sensitive {
	NSString *rlCommand = [aCmd stringByReplacingOccurrencesOfString:@"/" withString:@""];
	if (!sensitive) {

		
		
		
	}
}
@end
