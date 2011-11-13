//
//  SHIRCChannel.m
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHIRCChannel.h"
extern id objc_msgSend(id target, SEL msg, ...);
@interface NSString (casecompare)
- (BOOL)isEqualToStringNoCase:(NSString *)aString;
@end

@implementation NSString (casecompare)
- (BOOL)isEqualToStringNoCase:(NSString *)aString {
    return ([self caseInsensitiveCompare:aString] == NSOrderedSame);
}
@end

@implementation SHIRCChannel
@synthesize net, name, socket, delegate;

- (id)initWithSocket:(SHIRCSocket *)sock andChanName:(NSString *)chName {
	if ((self = [super init])) {
		[self setSocket:sock];
		[self setName:chName];
		[self setNet:[sock server]];
	}
	id channel = [sock retainedChannelWithFormattedName:[self formattedName]];
    if ([[sock channels] containsObject:self] || channel) {
        [self release];
        [channel release]; // might be a bug.
        return channel;
	}
	else {
		[sock addChannel:self];
    }
    [channel release];
    [[SHChatPanel alloc] initWithChan:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadChans" object:nil];
    return [self retain];
}
- (NSString *)formattedName {
    return [name hasPrefix:@"#"] || [name hasPrefix:@"&"] || [name hasPrefix:@"!"] || [name hasPrefix:@"+"] ? name : [@"#" stringByAppendingString:name];
}
- (BOOL)sendMessage:(NSString*)message flavor:(SHMessageFlavor)flavor {
	if (![socket didRegister]) return NO;
	NSString *command;
	switch (flavor) {
		case SHMessageFlavorNotice:
			command = @"NOTICE";
			break;
		case SHMessageFlavorNormal:
		case SHMessageFlavorAction:
		default:
			command = @"PRIVMSG";
			break;
    }
	if (flavor == SHMessageFlavorNormal) {
		[self didRecieveMessageFrom:[socket nick_] text:message];
    }
	else if (flavor == SHMessageFlavorAction) {
		[self didRecieveActionFrom:[socket nick_] text:message];
	}
	return [socket sendCommand:[command stringByAppendingFormat:@" %@", [self formattedName]]withArguments:(flavor==SHMessageFlavorAction) ? [NSString stringWithFormat:@"%c%@%@%c", 0x01, @"ACTION ", message, 0x01] : [NSString stringWithFormat:@"%@%@%@", @"", message, @""]];
}
- (void)parseAndEventuallySendMessage:(NSString *)command {
	if ([command hasPrefix:@"/"])
		[self parseCommand:command];
	else
		[self sendMessage:command flavor:SHMessageFlavorNormal];
}
- (void)parseCommand:(NSString*)command {
    NSAutoreleasePool* pool = [NSAutoreleasePool new];
    NSScanner* scan = [NSScanner scannerWithString:command];
    if ([command hasPrefix:@"/"])
        [scan setScanLocation:1];
    else
        goto out; //lolwat
    NSString *command_ = nil;
    NSString *argument = nil;
    [scan scanUpToString:@" " intoString:&command_];
    [scan scanUpToString:@"" intoString:&argument];
    if ([command_ isEqualToStringNoCase:@"me"]) {
		[self sendMessage:argument flavor:SHMessageFlavorAction];
	}
	else if ([command_ hasPrefix:@"/"]) {
		[scan setScanLocation:1];
		[scan scanUpToString:@"" intoString:&argument];
		[self sendMessage:argument flavor:SHMessageFlavorNormal];
	} 
	else if ([command_ isEqualToStringNoCase:@"mode"]) {
		if ([[argument componentsSeparatedByString:@" "] count] < 1) goto out;
		[socket sendCommand:[NSString stringWithFormat:@"MODE %@ %@\r\n", [self formattedName], [[argument componentsSeparatedByString:@" "] objectAtIndex:0]] withArguments:nil];
    }
	else if ([command_ isEqualToStringNoCase:@"op"]) {
		if ([[argument componentsSeparatedByString:@" "] count] < 1) goto out;
		[socket sendCommand:[NSString stringWithFormat:@"MODE %@ +o %@\r\n", [self formattedName], [[argument componentsSeparatedByString:@" "] objectAtIndex:0]] withArguments:nil];
    }
	else if ([command_ isEqualToStringNoCase:@"deop"]) {
		if ([[argument componentsSeparatedByString:@" "] count] < 1) goto out;
		[socket sendCommand:[NSString stringWithFormat:@"MODE %@ -o %@\r\n", [self formattedName], [[argument componentsSeparatedByString:@" "] objectAtIndex:0]] withArguments:nil];
    }
	else if ([command_ isEqualToStringNoCase:@"voice"]) {
		if ([[argument componentsSeparatedByString:@" "] count] < 1) goto out;
        [socket sendCommand:[NSString stringWithFormat:@"MODE %@ +v %@\r\n", [self formattedName], [[argument componentsSeparatedByString:@" "] objectAtIndex:0]] withArguments:nil];
    }
	else if ([command_ isEqualToStringNoCase:@"devoice"]) {
		if ([[argument componentsSeparatedByString:@" "] count] < 1) goto out;
		[socket sendCommand:[NSString stringWithFormat:@"MODE %@ -v %@\r\n", [self formattedName], [[argument componentsSeparatedByString:@" "] objectAtIndex:0]] withArguments:nil];
    }
	else if ([command_ isEqualToStringNoCase:@"halfop"]) {
		if ([[argument componentsSeparatedByString:@" "] count] < 1) goto out;
		[socket sendCommand:[NSString stringWithFormat:@"MODE %@ +h %@\r\n", [self formattedName], [[argument componentsSeparatedByString:@" "] objectAtIndex:0]] withArguments:nil];
    }
	else if ([command_ isEqualToStringNoCase:@"dehalfop"]) {
		if ([[argument componentsSeparatedByString:@" "] count] < 1) goto out;
		[socket sendCommand:[NSString stringWithFormat:@"MODE %@ -h %@\r\n", [self formattedName], [[argument componentsSeparatedByString:@" "] objectAtIndex:0]] withArguments:nil];
    }
	else if ([command_ isEqualToStringNoCase:@"oper"]) {
		if ([[argument componentsSeparatedByString:@" "] count] < 2) goto out;
		[socket sendCommand:[NSString stringWithFormat:@"OPER %@ %@\r\n", [[argument componentsSeparatedByString:@" "] objectAtIndex:0], [[argument componentsSeparatedByString:@" "] objectAtIndex:1]] withArguments:nil];
    } 
	else if ([command_ isEqualToStringNoCase:@"kill"]) {
		if ([[argument componentsSeparatedByString:@" "] count] < 1) goto out;
		[socket sendCommand:[NSString stringWithFormat:@"KILL %@\r\n", argument] withArguments:nil];
    }
	else if ([command_ isEqualToStringNoCase:@"join"]) {
		if ([[argument componentsSeparatedByString:@" "] count] < 1) goto out;
		[socket sendCommand:@"JOIN" withArguments:argument];
    }
	else if ([command_ isEqualToStringNoCase:@"kick"]) {
		if ([[argument componentsSeparatedByString:@" "] count] < 1) goto out;
		[scan setScanLocation:1];
		NSString *tokick = nil;
        NSString *msg = nil;
		[scan scanUpToString:@" " intoString:nil];
		[scan scanUpToString:@" " intoString:&tokick];
		[scan scanUpToString:@"" intoString:&msg];
		[socket sendCommand:[NSString stringWithFormat:@"KICK %@ %@ :%@", [self formattedName], tokick, msg ? msg : tokick] withArguments:nil];
    }
	else if ([command_ isEqualToStringNoCase:@"msg"] || [command_ isEqualToStringNoCase:@"query"]) {
		NSString *user;
		NSString *msg;
		NSScanner *tmpscan = [NSScanner scannerWithString:argument];
		[tmpscan scanUpToString:@" " intoString:&user];
		[tmpscan scanUpToString:@"" intoString:&msg];
        [socket sendCommand:[NSString stringWithFormat:@"PRIVMSG %@ :%@\r\n", user, msg] withArguments:nil];        
    }
	else if ([command_ isEqualToStringNoCase:@"raw"]) {
		[socket sendCommand:[NSString stringWithFormat:@"%@\r\n", argument] withArguments:nil];
    }
	else if ([command_ isEqualToStringNoCase:@"nick"]) {
		if ([[argument componentsSeparatedByString:@" "] count]<1) goto out;
		[socket setNick_:[[argument componentsSeparatedByString:@" "] objectAtIndex:0]];
    }
	else {
		NSString *all = nil;
		[scan setScanLocation:1];
		[scan scanUpToString:@"" intoString:&all];
		[socket sendCommand:all withArguments:nil];
	}
    out:
    [pool drain];
}

- (void)part {
    [socket sendCommand:@"PART" withArguments:[self formattedName]];
    [socket removeChannel:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadChans" object:nil];
    [self release];
}

- (void)didRecieveMessageFrom:(NSString*)nick text:(NSString*)ircMessage {
	if ([delegate respondsToSelector:_cmd]) {
		[delegate performSelector:_cmd withObject:nick withObject:ircMessage];
	}
}

- (void)didRecieveActionFrom:(NSString*)nick text:(NSString*)ircMessage {
	if ([delegate respondsToSelector:_cmd]) {
		[delegate performSelector:_cmd withObject:nick withObject:ircMessage];
	}
}

- (void)didRecieveEvent:(SHEventType)event from:(NSString*)from to:(NSString*)to extra:(NSString *)extra {
	if ([delegate respondsToSelector:_cmd]) {
		objc_msgSend(delegate, _cmd, event, from, to, extra);
	}
}

- (void)didRecieveNamesList:(NSArray*)array {
	if ([delegate respondsToSelector:_cmd]) {
        [delegate performSelector:_cmd withObject:array];
	}
}

@end
