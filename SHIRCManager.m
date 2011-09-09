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

+ (SHIRCManager*)sharedManager
{
    if(!sharedSHManager)
        sharedSHManager=[[(Class)self alloc] init];
    return sharedSHManager;
}
- (void)dealloc {
    // [super dealloc];
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
}
#define NO_THREADING 1
- (void)parseMessage:(NSMutableString*)msg fromSocket:(SHIRCSocket*)socket
{
    #ifndef NO_THREADING
    if ([NSThread isMainThread]) {
        [self performSelectorInBackground:@selector(parseMessageWithArray:) withObject:[[NSArray alloc] initWithObjects:msg, socket, nil]];
        return;
    }
    #endif
    NSScanner* scan=[NSScanner scannerWithString:msg];
    @try {
        if([msg hasPrefix:@":"])
            [scan setScanLocation:1];
    }
    @catch (id e) {
        NSLog(@"Catched error %@", e);
    }
    NSString* sender=nil;
    NSString* command=nil;
    NSString* argument=nil;
    [scan scanUpToString:@" " intoString:&sender];
    [scan scanUpToString:@" " intoString:&command];
    [scan scanUpToString:@"\r\n" intoString:&argument];
    if ([sender isEqualToString:@"PING"]) {
        [socket sendCommand:[@"PONG " stringByAppendingString:command] withArguments:nil];
        NSLog(@"Pingie!");
        return;
    }
    if ([command isEqualToString:@"PRIVMSG"]) {
        NSScanner* scan_=[NSScanner scannerWithString:argument];
        NSString* nick=nil;
        NSString* user=nil;
        NSString* hostmask=nil;
        [self parseUsermask:sender nick:&nick user:&user hostmask:&hostmask];
        NSString* message=nil;
        NSString* toChannel=nil;
        [scan_ scanUpToString:@" " intoString:&toChannel];
        @try {
            [scan_ setScanLocation:[scan_ scanLocation]+2 ];
        }
        @catch (id e) {
            NSLog(@"Catched error %@", e);
        }
        [scan_ scanUpToString:@"" intoString:&message];
        if ([message hasPrefix:@"\x01"]&&[message hasSuffix:@"\x01"])
        {
            NSLog(@"Got a CTCP request from %@ [%@]", sender, message);
            [socket sendCommand:[@"NOTICE " stringByAppendingString:nick] withArguments:@"\x01VERSION ShadowChat\x01"];
        } else {
            NSLog(@"zomg a message %@ to %@ from %@", message, toChannel, nick);
            [[socket retainedChannelWithFormattedName:toChannel] didRecieveMessageFrom:nick text:message];
        }
    }
    cont:
    if ([command isEqualToString:@"433"]) {
        if (!socket.didRegister)
        {
            socket.nick_=[socket.nick_ stringByAppendingString:@"_"];
            [socket sendCommand:[NSString stringWithFormat:@"NICK %@\r\n", socket.nick_] withArguments:nil];
        }
        NSLog(@"Nick is being used.");
    }
    else if ([command isEqualToString:@"001"])
    {
        socket.didRegister=YES;
        NSLog(@"Did register");
        
    }
    NSLog(@"%@", msg);
}
- (void)parseUsermask:(NSString*)mask nick:(NSString**)nick user:(NSString**)user hostmask:(NSString**)hostmask
{
    *nick=nil;
    *user=nil;
    *hostmask=nil;
    NSScanner* scan=[NSScanner scannerWithString:mask];
    [scan scanUpToString:@"!" intoString:nick];
    if([scan isAtEnd]) return;
    [scan setScanLocation:((int)[scan scanLocation])+1];
    [scan scanUpToString:@"@" intoString:user];
    [scan setScanLocation:((int)[scan scanLocation])+1];
    if([scan isAtEnd]) return;
    [scan scanUpToString:@"" intoString:hostmask];
}
- (void)parseCommand:(NSString*)command fromChannel:(SHIRCChannel*)chat
{
    
}

@end
