//
//  SHIRCManager.m
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import <Foundation/NSScanner.h>
#import "SHIRCManager.h"
#import "SHIRCPrivateChat.h"

static SHIRCManager* sharedSHManager;
@implementation SHIRCManager

+ (SHIRCManager *)sharedManager {
    if(!sharedSHManager)
        sharedSHManager = [[(Class)self alloc] init];
    return sharedSHManager;
}

- (void)dealloc {
    if (1 == 2) {
        [super dealloc];
    }
}

- (void)parseMessageWithArray:(NSArray *)args {
    id pool = [NSAutoreleasePool new];
    if ([args count] != 2) {
        [args release];
        [pool release];
        return;
    }
    [self parseMessage:[args objectAtIndex:0] fromSocket:[args objectAtIndex:1]];
    [pool release];
}

#define NO_THREADING 1
- (void)parseMessage:(NSMutableString *)msg fromSocket:(SHIRCSocket *)socket {
	// 322 = room listing...
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	#ifndef NO_THREADING
	if ([NSThread isMainThread]) {
		[self performSelectorInBackground:@selector(parseMessageWithArray:) withObject:[[NSArray alloc] initWithObjects:msg, socket, nil]];
		return;
	}
	#endif
	NSScanner *scan = [NSScanner scannerWithString:msg];
	if ([msg hasPrefix:@":"])
		[scan setScanLocation:1];
	NSString *sender = nil;
	NSString *command = nil;
	NSString *argument = nil;
    [scan scanUpToString:@" " intoString:&sender];
    [scan scanUpToString:@" " intoString:&command];
	[scan scanUpToString:@"\r\n" intoString:&argument];
	if ([sender isEqualToString:@"PING"]) {
		[socket sendCommand:[@"PONG " stringByAppendingString:command] withArguments:nil];
		NSLog(@"Pingie!");
		return;
	}
	if ([command isEqualToString:@"372"]) {
        // MOTD, do not want
	}
	else if ([command isEqualToString:@"PRIVMSG"]) {
        NSScanner *scan_ = [NSScanner scannerWithString:argument];
        NSString *nick = nil;
        NSString *user = nil;
        NSString *hostmask = nil;
        [self parseUsermask:sender nick:&nick user:&user hostmask:&hostmask];
        NSString *message = nil;
        NSString *toChannel = nil;
        [scan_ scanUpToString:@" " intoString:&toChannel];
        @try {
            [scan_ setScanLocation:[scan_ scanLocation]+2];
        }
        @catch (id e) {
            NSLog(@"Catched error %@", e);
        }
        [scan_ scanUpToString:@"" intoString:&message];
        NSLog(@"%@ lolwat", message);
        if ([message hasPrefix:@"\x01"] && [message hasSuffix:@"\x01"]) {
            NSString *command = nil;
            NSString *arg = nil;
            NSScanner *scan__ = [NSScanner scannerWithString:message];
            [scan__ setScanLocation:1];
            [scan__ scanUpToString:@" " intoString:&command];
            NSLog(@"command is %@, %d", command, [command hasPrefix:@"\x01"]);
            if ([command hasSuffix:@"\x01"]) {
                [scan__ setScanLocation:1 ];
                [scan__ scanUpToString:@"\x01" intoString:&command];
                goto singlearg;
            }
            [scan__ scanUpToString:@"\x01" intoString:&arg];
        singlearg:
            if ([command isEqualToString:@"ACTION"]) {
                id chan = [socket retainedChannelWithFormattedName:toChannel];
                [chan didRecieveActionFrom:nick text:arg];
                [chan release];
            }
			else if ([command isEqualToString:@"VERSION"]) {
				[socket sendCommand:[@"NOTICE " stringByAppendingString:nick] withArguments:@"\x01VERSION ShadowChat\x01"];
			}
		}
		else {
			NSLog(@"zomg a message %@ to %@ from %@", message, toChannel, nick);
			id chan = [socket retainedChannelWithFormattedName:toChannel];
			if ([toChannel isEqualToString:socket.nick_] && !chan) {
				chan = [[SHIRCPrivateChat alloc] initWithSocket:socket withNick:nick];
				[chan retain];
			}
			[chan didRecieveMessageFrom:nick text:message];
			[chan release];
		}
	}
	else cont:
    if ([command isEqualToString:@"433"]) {
        if (!socket.didRegister) {
            [socket setNick_:[[socket nick_] stringByAppendingString:@"_"]];
        }
        NSLog(@"Nick is being used.");
    }
    else if ([command isEqualToString:@"353"]) {
// MARK: 353
		NSLog(@"Users Found: %@", argument);
		NSRange rangeOfSpace = [argument rangeOfString:@"#"];
		NSRange rangeOfEndOfRoom = [argument rangeOfString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(rangeOfSpace.location, [argument length]-rangeOfSpace.location)];
		NSString *roomName = [argument substringWithRange:NSMakeRange(rangeOfSpace.location, rangeOfEndOfRoom.location-rangeOfSpace.location)];
		NSRange rOfRoom = [argument rangeOfString:roomName];
		NSString *_tmpUsers = [argument substringWithRange:NSMakeRange(rOfRoom.location+roomName.length+2, [argument length]-rOfRoom.location-roomName.length-2)];
		NSLog(@"Found Users:%@",[_tmpUsers componentsSeparatedByString:@" "]);
		for (SHIRCChannel *chan in [socket channels]) {
			if ([[[chan name] lowercaseString] isEqualToString:[roomName lowercaseString]]) {
				[chan addUsers:[_tmpUsers componentsSeparatedByString:@" "]];
				break;
			}
		}
	}
	else if ([command isEqualToString:@"322"]) {
		// gettting rooms data.. :o
		/*
		 2011-12-10 16:12:42.716 ShadowChat[3024:f803] Rooms data... 322 : Maximus-i4 #help 5 :[+nt]  : <SHIRCSocket: 0x68a5570> 
		 2011-12-10 16:12:42.717 ShadowChat[3024:f803] Rooms data... 322 : Maximus-i4 #test 2 :[+nt]  : <SHIRCSocket: 0x68a5570> 
		 2011-12-10 16:12:42.723 ShadowChat[3024:f803] Rooms data... 322 : Maximus-i4 #nightcoast 32 :[+tfj] God gave men penis and a brain, but only enough blood to run one at a time <--- Now das a quote to live by ;) | k | max, we should rewrite shadowchat </trolo> | dida is alive (8/12/11) : <SHIRCSocket: 0x68a5570> 
		 */
		NSLog(@"Meh. Rooms shit. %@ - %@ - %@", command, argument, scan);
		NSString *testArg = [argument stringByReplacingOccurrencesOfString:[[socket nick_] stringByAppendingString:@" "] withString:@""];
		NSRange endOfRoom = [testArg rangeOfString:@" "];
		NSRange endOfUserCount = [testArg rangeOfString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(endOfRoom.location+1, testArg.length-(endOfRoom.location+1))];
		[socket addRoom:[testArg substringWithRange:NSMakeRange(0, endOfRoom.location)] withUserCount:[testArg substringWithRange:NSMakeRange(endOfRoom.location+1, endOfUserCount.location-endOfRoom.location+1)]];
	}
    else if ([command isEqualToString:@"001"]) {
		socket.didRegister = YES;
		NSLog(@"Did register");
	}
//	http://d.pr/AzCq
	
	else if ([command isEqualToString:@"KICK"]) {
        NSString *nick = nil;
        NSString *chan = nil;
        NSString *target = nil;
        NSString *message = nil;
        NSScanner *scanz = [NSScanner scannerWithString:argument];
        [scanz scanUpToString:@" " intoString:&chan];
        if (![scanz isAtEnd]) 
            [scanz setScanLocation:[scanz scanLocation]+1];
        [self parseUsermask:sender nick:&nick user:nil hostmask:nil];
        [scanz scanUpToString:@" " intoString:&target];
        if (![scanz isAtEnd]) 
            [scanz setScanLocation:[scanz scanLocation]+1];
        int point = [scanz scanLocation];
        [scanz scanUpToString:@"" intoString:&message];
		if ([message hasPrefix:@":"]) {
			@try {
				[scanz setScanLocation:point+1];
			}
			@catch (id e) {
				NSLog(@"Catched error %@", e);
			}
			[scanz scanUpToString:@"" intoString:&message];
		}
        SHIRCChannel *chanC = [socket retainedChannelWithFormattedName:chan];
        [chanC didRecieveEvent:SHEventTypeKick from:nick to:target extra:message];
        [chanC release];
	}
	else if ([command isEqualToString:@"MODE"]) {
        NSString *nick = nil;
        NSString *chan = nil;
        NSString *target = nil;
        NSString *message = nil;
        NSScanner *scanz = [NSScanner scannerWithString:argument];
        [scanz scanUpToString:@" " intoString:&chan];
        if (![scanz isAtEnd]) 
            [scanz setScanLocation:[scanz scanLocation]+1];
        [self parseUsermask:sender nick:&nick user:nil hostmask:nil];
        [scanz scanUpToString:@" " intoString:&target];
        if (![scanz isAtEnd]) 
            [scanz setScanLocation:[scanz scanLocation]+1];
        int point = [scanz scanLocation];
        [scanz scanUpToString:@"" intoString:&message];
		if ([message hasPrefix:@":"]) {
			@try {
				[scanz setScanLocation:point+1];
			}
			@catch (id e) {
				NSLog(@"Catched error %@", e);
			}
			[scanz scanUpToString:@"" intoString:&message];
		}
		SHIRCChannel *chanCC = [socket retainedChannelWithFormattedName:chan];
		NSLog(@"What iS HAPPENING! ChanCC: %@ Nick:%@ Target:%@ Message:%@", chanCC, nick, target, message);;

		[chanCC didRecieveEvent:SHEventTypeMode from:nick to:target extra:message];

    }
	else if ([command isEqualToString:@"JOIN"]) {
		if ([argument hasPrefix:@":"]) {
			NSScanner *scnr = [NSScanner scannerWithString:argument];
			[scnr setScanLocation:1];
			[scnr scanUpToString:@"" intoString:&argument];
		}
		NSString *nick = nil;
        [self parseUsermask:sender nick:&nick user:nil hostmask:nil];
		NSLog(@"socket nick: %@", socket.nick_);
		NSLog(@"nick: %@", nick);
		if ([[NSString stringWithFormat:@"%@", nick] isEqualToString: [NSString stringWithFormat:@"%@", socket.nick_]]) {
            [[SHIRCChannel alloc] initWithSocket:socket andChanName:argument];
        }
        SHIRCChannel *chanC = [socket retainedChannelWithFormattedName:argument];
        [chanC didRecieveEvent:SHEventTypeJoin from:nick to:argument extra:nil];
        [chanC release];
    }
	else if ([command isEqualToString:@"NICK"]) {
        if ([argument hasPrefix:@":"]) {
            NSScanner *scnr = [NSScanner scannerWithString:argument];
            [scnr setScanLocation:1];
            [scnr scanUpToString:@"" intoString:&argument];
        }
        NSString *nick = nil;
        [self parseUsermask:sender nick:&nick user:nil hostmask:nil];
        NSLog(@"socket nick: %@", socket.nick_);
        NSLog(@"nick: %@", nick);
		if ([[NSString stringWithFormat:@"%@", nick] isEqualToString: [NSString stringWithFormat:@"%@", socket.nick_]]) {
			[socket setNick_:argument];
		}
	}
	else if ([command isEqualToString:@"PART"]) {
        NSScanner *scnr = [NSScanner scannerWithString:argument];
        NSString *chan = nil;
        NSString *msg = nil;
        NSString *nick = nil;
        [scnr scanUpToString:@" " intoString:&chan];
        @try {
            [scnr setScanLocation:[scnr scanLocation]+1];
        }
        @catch (id e) {
            NSLog(@"Catched error %@", e);
        }
        int point = [scnr scanLocation];
        [scnr scanUpToString:@"" intoString:&msg];
        if ([msg hasPrefix:@":"]) {
            @try {
                [scnr setScanLocation:point+1];
            }
            @catch (id e) {
                NSLog(@"Catched error %@", e);
            }
            [scnr scanUpToString:@"" intoString:&msg];
        }
        [self parseUsermask:sender nick:&nick user:nil hostmask:nil];
        NSLog(@"%@ parted from %@ with message %@", nick, chan, msg);
	//	for (SHIRCChannel *ch in [socket channels]) {
	//		if ([[ch.name lowercaseString] isEqualToString:[chan lowercaseString]]) {
	//			[ch.users removeObject:nick];
	//			[ch updateUserList];
	//		}
	//	}
        if ([nick isEqualToString:[socket nick_]]) {
            // k, remove dug chan.
        }
        SHIRCChannel *chanC = [socket retainedChannelWithFormattedName:chan];
        [chanC didRecieveEvent:SHEventTypePart from:nick to:argument extra:msg];
        [chanC release];
    } 
    [pool release];
}

- (void)parseUsermask:(NSString *)mask nick:(NSString **)nick user:(NSString **)user hostmask:(NSString **)hostmask {
	if (nick)
		*nick = nil;
	if (user)
		*user = nil;
    if (hostmask)
		*hostmask = nil;
	NSScanner *scan = [NSScanner scannerWithString:mask];
	[scan scanUpToString:@"!" intoString:nick];
	if ([scan isAtEnd]) return;
	[scan setScanLocation:((int)[scan scanLocation])+1];
	[scan scanUpToString:@"@" intoString:user];
	[scan setScanLocation:((int)[scan scanLocation])+1];
	if ([scan isAtEnd]) return;
	[scan scanUpToString:@"" intoString:hostmask];
}

@end
