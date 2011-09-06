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
- (void)dealloc
{
    // [super dealloc];
}
- (void)parseMessage:(NSMutableString*)msg fromSocket:(SHIRCSocket*)socket
{
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
        [socket sendCommand:@"PONG" withArguments:command];
        NSLog(@"Pingie!");
        return;
    }
    if ([command isEqualToString:@"433"]) {
        if (!socket.didRegister)
        {
            socket.nick_=[socket.nick_ stringByAppendingString:@"_"];
            [socket sendCommand:[NSString stringWithFormat:@"NICK %@\r\n", socket.nick_] withArguments:nil];
        }
        NSLog(@"Nick is being used.");
    }
    else if ([command isEqualToString:@"376"])
    {
        socket.didRegister=YES;
        NSLog(@"Did register (motd command ended)");
        
    }
    NSString* nick=nil;
    NSString* user=nil;
    NSString* hostmask=nil;
    [self parseUsermask:sender nick:&nick user:&user hostmask:&hostmask];
    NSLog(@"%@ - %@ - %@ - %@ - %@", nick, user, hostmask, command, argument);
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
