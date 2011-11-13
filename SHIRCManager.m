//
//  SHIRCManager.m
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import <Foundation/NSScanner.h>
#import "SHIRCManager.h"

static SHIRCManager* sharedSHManager;
@implementation SHIRCManager

+ (SHIRCManager *)sharedManager
{
    if(!sharedSHManager)
        sharedSHManager=[[(Class)self alloc] init];
    return sharedSHManager;
}

- (void)dealloc {
    if (1 == 2) {
        [super dealloc];
    }
}

- (void)parseMessageWithArray:(NSArray*)args
{
    id pool=[NSAutoreleasePool new];
    if ([args count]!=2) {
        [args release];
        [pool release];
        return;
    }
    [self parseMessage:[args objectAtIndex:0] fromSocket:[args objectAtIndex:1]];
    [pool release];
}

#define NO_THREADING 1
- (void)parseMessage:(NSMutableString*)msg fromSocket:(SHIRCSocket*)socket {
	NSLog(@"fun %@", msg);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	#ifndef NO_THREADING
	if ([NSThread isMainThread]) {
		[self performSelectorInBackground:@selector(parseMessageWithArray:) withObject:[[NSArray alloc] initWithObjects:msg, socket, nil]];
		return;
	}
	#endif
	NSScanner* scan=[NSScanner scannerWithString:msg];
	if([msg hasPrefix:@":"])
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
    } else if ([command isEqualToString:@"PRIVMSG"]) {
        NSScanner* scan_=[NSScanner scannerWithString:argument];
        NSString* nick=nil;
        NSString* user=nil;
        NSString* hostmask=nil;
        [self parseUsermask:sender nick:&nick user:&user hostmask:&hostmask];
        NSString* message=nil;
        NSString* toChannel=nil;
        [scan_ scanUpToString:@" " intoString:&toChannel];
        @try {
            [scan_ setScanLocation:[scan_ scanLocation]+2];
        }
        @catch (id e) {
            NSLog(@"Catched error %@", e);
        }
        [scan_ scanUpToString:@"" intoString:&message];
        NSLog(@"%@ lolwat", message);
        if ([message hasPrefix:@"\x01"]&&[message hasSuffix:@"\x01"])
        {
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
                id chan=[socket retainedChannelWithFormattedName:toChannel];
                [chan didRecieveActionFrom:nick text:arg];
                [chan release];
            } else if ([command isEqualToString:@"VERSION"])
            {
                [socket sendCommand:[@"NOTICE " stringByAppendingString:nick] withArguments:@"\x01VERSION ShadowChat\x01"];
            }
        } else {
            NSLog(@"zomg a message %@ to %@ from %@", message, toChannel, nick);
            id chan = [socket retainedChannelWithFormattedName:toChannel];
            [chan didRecieveMessageFrom:nick text:message];
            [chan release];
        }
    } else
    cont:
    if ([command isEqualToString:@"433"]) {
        if (!socket.didRegister)
        {
            [socket setNick_:[[socket nick_] stringByAppendingString:@"_"]];
        }
        NSLog(@"Nick is being used.");
    }/*
    else if ([command isEqualToString:@"353"]) {
        NSString *tmp;
        NSString *chanstr;
        NSString *names;
        NSScanner *namesScan = [NSScanner scannerWithString:argument];
        [namesScan scanUpToString:@"= " intoString:&tmp];
        [namesScan setScanLocation:[tmp length]+1];
        [namesScan scanUpToString:@" " intoString:&chanstr];
        [namesScan setScanLocation:[chanstr length]+[tmp length]+4];
        [namesScan scanUpToString:@"\r\n" intoString:&names];
        
        NSArray *namesArray = [names componentsSeparatedByString:@" "];
        
        //NSLog(@"%@", namesArray);
        
        id chan=[socket retainedChannelWithFormattedName:chanstr];
        
        [chan didRecieveNamesList:namesArray];
        [chan release];
        
        //NSLog(@"Names from %@ received, names: %@", chanstr, names);
    }*/
    else if ([command isEqualToString:@"001"])
    {
        socket.didRegister=YES;
        NSLog(@"Did register");
    }    else if ([command isEqualToString:@"KICK"])
    {
        NSString* nick=nil;
        NSString* chan=nil;
        NSString* target=nil;
        NSString* message=nil;
        NSScanner* scanz=[NSScanner scannerWithString:argument];
        [scanz scanUpToString:@" " intoString:&chan];
        if (![scanz isAtEnd]) 
            [scanz setScanLocation:[scanz scanLocation]+1];
        [self parseUsermask:sender nick:&nick user:nil hostmask:nil];
        [scanz scanUpToString:@" " intoString:&target];
        if (![scanz isAtEnd]) 
            [scanz setScanLocation:[scanz scanLocation]+1];
        int point=[scanz scanLocation];
        [scanz scanUpToString:@"" intoString:&message];
        if ([message hasPrefix:@":"])
        {
            @try {
                [scanz setScanLocation:point+1];
            }
            @catch (id e) {
                NSLog(@"Catched error %@", e);
            }
            [scanz scanUpToString:@"" intoString:&message];
        }
        SHIRCChannel* chanC=[socket retainedChannelWithFormattedName:chan];
        [chanC didRecieveEvent:SHEventTypeKick from:nick to:target extra:message];
        [chanC release];
    }    else if ([command isEqualToString:@"MODE"])
    {

    }    else if ([command isEqualToString:@"JOIN"])
    {
        if ([argument hasPrefix:@":"]) {
            NSScanner* scnr=[NSScanner scannerWithString:argument];
            [scnr setScanLocation:1];
            [scnr scanUpToString:@"" intoString:&argument];
        }
        NSString* nick=nil;
        [self parseUsermask:sender nick:&nick user:nil hostmask:nil];
        NSLog(@"socket nick: %@", socket.nick_);
        NSLog(@"nick: %@", nick);
        if ([[NSString stringWithFormat:@"%@", nick] isEqualToString: [NSString stringWithFormat:@"%@", socket.nick_]]) {
            [[SHIRCChannel alloc] initWithSocket:socket andChanName:argument];
        }
        SHIRCChannel* chanC=[socket retainedChannelWithFormattedName:argument];
        [chanC didRecieveEvent:SHEventTypeJoin from:nick to:argument extra:nil];
        [chanC release];
    }else if ([command isEqualToString:@"NICK"])
    {
        if ([argument hasPrefix:@":"]) {
            NSScanner* scnr=[NSScanner scannerWithString:argument];
            [scnr setScanLocation:1];
            [scnr scanUpToString:@"" intoString:&argument];
        }
        NSString* nick=nil;
        [self parseUsermask:sender nick:&nick user:nil hostmask:nil];
        NSLog(@"socket nick: %@", socket.nick_);
        NSLog(@"nick: %@", nick);
        if ([[NSString stringWithFormat:@"%@", nick] isEqualToString: [NSString stringWithFormat:@"%@", socket.nick_]]) {
            [socket setNick_:argument];
        }
    }    else if ([command isEqualToString:@"PART"])
    {
        NSScanner* scnr=[NSScanner scannerWithString:argument];
        NSString* chan=nil;
        NSString* msg=nil;
        NSString* nick=nil;
        [scnr scanUpToString:@" " intoString:&chan];
        @try {
            [scnr setScanLocation:[scnr scanLocation]+1];
        }
        @catch (id e) {
            NSLog(@"Catched error %@", e);
        }
        int point=[scnr scanLocation];
        [scnr scanUpToString:@"" intoString:&msg];
        if ([msg hasPrefix:@":"])
        {
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
        if ([nick isEqualToString:[socket nick_]]) {
            // k, remove dug chan.
        }
        SHIRCChannel* chanC=[socket retainedChannelWithFormattedName:chan];
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
    if([scan isAtEnd]) return;
    [scan setScanLocation:((int)[scan scanLocation])+1];
    [scan scanUpToString:@"@" intoString:user];
    [scan setScanLocation:((int)[scan scanLocation])+1];
    if([scan isAtEnd]) return;
    [scan scanUpToString:@"" intoString:hostmask];
}

@end
