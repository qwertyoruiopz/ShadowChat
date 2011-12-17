//
//  SHIRCSocket.m
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHIRCSocket.h"
#import "SHIRCManager.h"
#import "SHIRCChannel.h"
#import "SHIRCNetwork.h"
#import "SHIRCPrivateChat.h"
#import <objc/runtime.h>

@implementation SHIRCSocket

#define clean() [input close]; \
[output close]; \
[input setDelegate:nil]; \
[output setDelegate:nil]; \
[input release]; \
[output release]; \
input = nil; \
output = nil;

@synthesize input, output, port, server, usesSSL, _channels, status, delegate;

+ (SHIRCSocket *)socketWithServer:(NSString *)srv andPort:(int)prt usesSSL:(BOOL)ssl {
	SHIRCSocket *ret = [[(Class)self alloc] init];
	ret.server = srv;
	ret.port = prt;
	ret.usesSSL = ssl;
	return [ret autorelease];
}

- (BOOL)connectWithNick:(NSString *)nick andUser:(NSString *)user {
	return [self connectWithNick:nick andUser:user andPassword:nil];
}

- (BOOL)connectWithNick:(NSString *)nick andUser:(NSString *)user andPassword:(NSString *)pass {
	[self retain];
	IF_IOS4_OR_GREATER (
						bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{ 
		[[UIApplication sharedApplication] endBackgroundTask:bgTask]; 
        bgTask = UIBackgroundTaskInvalid;}]; 
                        );
	NSInputStream *iStream;
	NSOutputStream *oStream;
	CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)server, port ? port : 6667, (CFReadStreamRef *)&iStream, (CFWriteStreamRef *)&oStream);
	self.input = iStream;
	self.output = oStream;
	[iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	iStream.delegate = self;
	oStream.delegate = self;
	[iStream release];
	[oStream release];
	self.nick_ = nick;
	if ([iStream streamStatus] == NSStreamStatusNotOpen)
		[iStream open];
	
	if ([oStream streamStatus] == NSStreamStatusNotOpen)
		[oStream open];
	
	if ([self status] == SHSocketStausOpen || [self status] == SHSocketStausConnecting) {
		return NO;
	}
	if (usesSSL) {
		[iStream setProperty:NSStreamSocketSecurityLevelNegotiatedSSL forKey:NSStreamSocketSecurityLevelKey];
        [oStream setProperty:NSStreamSocketSecurityLevelNegotiatedSSL forKey:NSStreamSocketSecurityLevelKey];
		
		NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
								  [NSNumber numberWithBool:YES], kCFStreamSSLAllowsExpiredCertificates,
								  [NSNumber numberWithBool:YES], kCFStreamSSLAllowsAnyRoot,
								  [NSNumber numberWithBool:NO], kCFStreamSSLValidatesCertificateChain,
								  kCFNull,kCFStreamSSLPeerName,
								  nil];
		
		CFReadStreamSetProperty((CFReadStreamRef)iStream, kCFStreamPropertySSLSettings, (CFTypeRef)settings);
		CFWriteStreamSetProperty((CFWriteStreamRef)oStream, kCFStreamPropertySSLSettings, (CFTypeRef)settings);
		[settings release];
	}
	didRegister = NO;
	status = SHSocketStausConnecting;
	if (pass) {
		[self sendCommand:[NSString stringWithFormat:@"PASS %@:%@", user, pass] withArguments:nil];
	}
	[self sendCommand:[NSString stringWithFormat:@"USER %@ %@ %@ %@", user, user, user, user] withArguments:nil];
	[self sendCommand:[NSString stringWithFormat:@"NICK %@", nick] withArguments:nil];
	return YES;
}

- (NSString *)nick_ {
	return nick_;
}

- (void)setNick_:(NSString *)nick {
	if (nick == nick_) return;
	if (nick == nil || [nick isEqualToString:@""]) return;
	[nick_ release];
	nick_ = [nick retain];
	[self sendCommand:@"NICK" withArguments:nick];
}

- (id)channels {
	if (!self._channels)
		self._channels = [NSMutableArray new];
	return self._channels;
}

- (void)findAvailableRoomsWithCallback:(id)cBack {
	jCallback = cBack;
	[self sendCommand:@"LIST" withArguments:nil];
}

- (void)addRoom:(NSString *)room withRoomInfo:(NSDictionary *)infos {
	objc_msgSend(jCallback, _cmd, room, infos);
}

- (BOOL)sendCommand:(NSString *)command withArguments:(NSString *)args {
    NSString *cmd;
    NSLog(@"Command: %@ Args: %@", command, args);
    if (args)
        cmd = [command stringByAppendingFormat:@" :%@\r\n", args];
    else
        cmd = [command stringByAppendingString:@"\r\n"];
    if (canWrite) {
        [output write:(uint8_t *)[cmd UTF8String] maxLength:[cmd length]];
        [output write:(uint8_t *)"\r\n" maxLength:2];
        return YES;
    }
    if (!queuedCommands) queuedCommands = [NSMutableString new];
    [queuedCommands appendFormat:@"%@\r\n", cmd];
    return YES;
}
- (BOOL)sendCommand:(NSString *)command withArguments:(NSString *)args waitUntilRegistered:(BOOL)wur {
    if (didRegister) wur = NO;
    NSString *cmd;
    if (args)
		cmd = [command stringByAppendingFormat:@" :%@\r\n", args];
    else
        cmd = command;
    if (!wur) {
        if (canWrite) {
            [output write:(uint8_t*)[cmd UTF8String] maxLength:[cmd length]];
            [output write:(uint8_t*)"\r\n" maxLength:2];
            return YES;
        }
        if (!queuedCommands) queuedCommands = [NSMutableString new];
        [queuedCommands appendFormat:@"%@\r\n", cmd];
        return YES;
    }
    if (!commandsWaiting) commandsWaiting = [NSMutableArray new];
    [commandsWaiting addObject:cmd];
    return YES;
}
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    if(streamEvent == NSStreamEventHasBytesAvailable) {
        if (!data) data = [NSMutableString new];
        uint8_t buf;
        NSUInteger bytesRead = [(NSInputStream *)theStream read:&buf maxLength:1];
		if (bytesRead)
			[data appendFormat:@"%c", buf];
		if ([data hasSuffix:@"\r\n"]) {
			[[SHIRCManager sharedManager] parseMessage:data fromSocket:self];
			[data release];
			data = nil;
		}
    }
	else if (streamEvent == NSStreamEventErrorOccurred) {
		if (status != SHSocketStausError || status != SHSocketStausError) {
			clean()
			status = SHSocketStausError;
			[self setDidRegister:NO];
            [[UIApplication sharedApplication] endBackgroundTask:bgTask]; 
            bgTask = UIBackgroundTaskInvalid;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadNetworks" object:nil];
		}
	}
	else if (streamEvent == NSStreamEventEndEncountered) {
		if (status != SHSocketStausError || status != SHSocketStausError) {
			clean()
			status = SHSocketStausClosed;
			[self setDidRegister:NO];
            [[UIApplication sharedApplication] endBackgroundTask:bgTask]; 
            bgTask = UIBackgroundTaskInvalid;
            [[SHIRCNetwork allConnectedNetworks] removeObject:[self delegate]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadNetworks" object:nil];
		}
	} 
	else if (streamEvent == NSStreamEventHasSpaceAvailable) {
		if (status == SHSocketStausConnecting) {
			status = SHSocketStausOpen;
			[[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadNetworks" object:nil];
		}
		if (queuedCommands) {
			canWrite = NO;
			[(NSOutputStream *)theStream write:(uint8_t *)[queuedCommands UTF8String] maxLength:[queuedCommands length]];
			[output write:(uint8_t *)"\r\n" maxLength:2];
			[queuedCommands release];
			queuedCommands = nil;
		}
		canWrite = YES;
	}
}
- (void)disconnect {
	if (status != SHSocketStausError || status != SHSocketStausClosed) {
		[self sendCommand:@"QUIT" withArguments:@"ShadowChat BETA"];
		status = SHSocketStausClosed;
		[self setDidRegister:NO];
        [[UIApplication sharedApplication] endBackgroundTask:bgTask]; 
        bgTask = UIBackgroundTaskInvalid;
        [[SHIRCNetwork allConnectedNetworks] removeObject:[self delegate]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadNetworks" object:nil];
    }
}


- (void)addChannel:(SHIRCChannel *)chan {
	NSLog(@"Joiny fun!");
    [self joinChannel:chan];
}
- (void)removeChannel:(SHIRCChannel *)chan {
	[self partChannel:chan];
}

- (void)joinChannel:(SHIRCChannel *)chan {
    [self sendCommand:[@"JOIN " stringByAppendingString:[chan formattedName]] withArguments:nil waitUntilRegistered:YES];
    [chan setIsJoined:YES];
	if (![[delegate channels] containsObject:[chan formattedName]]) {
        [[delegate channels] addObject:[chan formattedName]];
        [SHIRCNetwork saveDefaults];
	}
	if (![_channels containsObject:chan])
		[_channels addObject:chan];
}

- (void)partChannel:(SHIRCChannel *)chan {
	[self sendCommand:[@"PART " stringByAppendingString:[chan formattedName]] withArguments:nil waitUntilRegistered:YES];
	[chan setIsJoined:NO];
    [_channels removeObject:chan];
    [[delegate channels] removeObject:[chan formattedName]];
    [SHIRCNetwork saveDefaults];
}

- (BOOL) didRegister {
    return didRegister;
}

- (void)setDidRegister:(BOOL)didReg {
	if (didReg == didRegister) {
		return;
	}
	didRegister = didReg;
	if (didReg) {
		for (NSString *cmd in commandsWaiting) {
			if ([cmd isKindOfClass:[NSString class]]) {
				[output write:(uint8_t *)[cmd UTF8String] maxLength:[cmd length]];
				[output write:(uint8_t *)"\r\n" maxLength:2];
			}
		}
		[commandsWaiting release];
		commandsWaiting = nil;
		for (NSString *obj in [delegate channels]) {
			id chan = [self retainedChannelWithFormattedName:obj];
			[self addChannel:chan ? chan : ([chan hasPrefix:@"#"] ? [[SHIRCChannel alloc] initWithSocket:self andChanName:obj] : [[SHIRCPrivateChat alloc] initWithSocket:self withNick:obj])];
			NSLog(@"IC.. %@ %@ ", obj, chan);
			[chan release];			
		}
		if ([delegate respondsToSelector:@selector(hasBeenRegisteredCallback:)]) {
			[delegate performSelector:@selector(hasBeenRegisteredCallback:) withObject:self];
		}
		[[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadNetworks" object:nil];
	}  
}

- (void)dealloc {
    [self disconnect];
    NSLog(@"lol wtf");
    for (id obj in _channels) {
        [obj release];
    }
    [_channels release];
    [input release];
    [output release];
    [super dealloc];
}

- (SHIRCChannel *)retainedChannelWithFormattedName:(NSString *)fName {
		for (SHIRCChannel *rtn in [self channels]) {
			if ([[[rtn formattedName] lowercaseString] isEqualToString:[fName lowercaseString]]) {
				return [rtn retain];
			}
		}
	
    return nil;
}
@end
