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
@implementation SHIRCSocket
@synthesize input, output, port, server, usesSSL, nick_, channels, status;
+ (SHIRCSocket*)socketWithServer:(NSString *)srv andPort:(int)prt usesSSL:(BOOL)ssl {
    SHIRCSocket* ret = [[(Class)self alloc]init];
    ret.server = srv;
    ret.port = prt;
    ret.usesSSL = ssl;
    NSInputStream *iStream;
    NSOutputStream *oStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)srv, prt ? prt : 6667, (CFReadStreamRef*)&iStream, (CFWriteStreamRef *)&oStream);
    ret.input = iStream;
    ret.output = oStream;
    [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    iStream.delegate = ret;
    oStream.delegate = ret;
    [iStream release];
    [oStream release];
    return ret;
}
- (BOOL)connectWithNick:(NSString *)nick andUser:(NSString *)user {
    self.nick_ = nick;
    NSInputStream *iStream = input;
    NSOutputStream *oStream = output;
    if ([iStream streamStatus] == NSStreamStatusNotOpen)
        [iStream open];
    
    if ([oStream streamStatus] == NSStreamStatusNotOpen)
        [oStream open];
    
    if ([self status] == SHSocketStausOpen || [self status] == SHSocketStausConnecting) {
        return NO;
    }
    if (usesSSL) {
		[iStream setProperty:NSStreamSocketSecurityLevelNegotiatedSSL 
                       forKey:NSStreamSocketSecurityLevelKey];
        [oStream setProperty:NSStreamSocketSecurityLevelNegotiatedSSL 
                        forKey:NSStreamSocketSecurityLevelKey];  
        
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
    [self sendCommand:[NSString stringWithFormat:@"USER %@ %@ %@ %@\r\n", user, user, user, user] withArguments:nil];
    [self sendCommand:[NSString stringWithFormat:@"NICK %@\r\n", nick] withArguments:nil];
    return YES;
}
- (BOOL)sendCommand:(NSString *)command withArguments:(NSString *)args {
    NSString *cmd;
    if(args)
        cmd = [command stringByAppendingFormat:@" :%@\r\n", args];
    else
        cmd = command;
    if (canWrite) {
        return [output write:(uint8_t*)[cmd UTF8String] maxLength:[cmd length]];
    }
    if (!queuedCommands) queuedCommands = [NSMutableString new];
    [queuedCommands appendFormat:@"%@\r\n", cmd];
    return YES;
}
- (BOOL)sendCommand:(NSString *)command withArguments:(NSString*)args waitUntilRegistered:(BOOL)wur {
    if(didRegister) wur = NO;
    NSString *cmd;
    if(args)
		cmd = [command stringByAppendingFormat:@" :%@\r\n", args];
    else
        cmd = command;
    if(!wur){
        if (canWrite) 
            return [output write:(uint8_t*)[cmd UTF8String] maxLength:[cmd length]];
        if (!queuedCommands) queuedCommands = [NSMutableString new];
        [queuedCommands appendFormat:@"%@\r\n", cmd];
        return YES;
    }
    if(!commandsWaiting) commandsWaiting=[NSMutableArray new];
    [commandsWaiting addObject:cmd];
    return YES;
}
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
    if(streamEvent == NSStreamEventHasBytesAvailable)
    {
        if(!data) data=[NSMutableString new];
            uint8_t buf;
            NSUInteger bytesRead = [(NSInputStream*)theStream read:&buf maxLength:1];
            if(bytesRead)
                [data appendFormat:@"%c", buf];
            if([data hasSuffix:@"\r\n"]) {
                [[SHIRCManager sharedManager] parseMessage:data fromSocket:self];
                [data release];
                data=nil;
        }           
    }
    else if (streamEvent == NSStreamEventEndEncountered)
    {
        if (status == SHSocketStausClosed) {
            return;
        }
        status = SHSocketStausClosed;
        [data release];
        data=nil;
        [input release];
        [output release];
    } else if (streamEvent == NSStreamEventHasSpaceAvailable)
    {
        if (status == SHSocketStausConnecting)
            status = SHSocketStausOpen;
        if (queuedCommands) {
            canWrite=NO;
            [(NSOutputStream*)theStream write:(uint8_t*)[queuedCommands UTF8String] maxLength:[queuedCommands length]];
            [queuedCommands release];
            queuedCommands=nil;
        }
        canWrite=YES;
    }
}
-(void)disconnect
{
    if (status == SHSocketStausClosed) {
        return;
    }
    [self sendCommand:@"QUIT" withArguments:@"ShadowChat BETA"];
    [input close];
    [output close];
    [input release];
    [output release];
    input = nil;
    output = nil;
}
- (void)addChannel:(SHIRCChannel*)chan
{
    [self sendCommand:@"JOIN" withArguments:[chan formattedName] waitUntilRegistered:YES];
    if(!channels) channels=[NSMutableArray new];
    [channels addObject:chan];
}
- (void)removeChannel:(SHIRCChannel*)chan
{
    [self sendCommand:@"PART" withArguments:[chan formattedName] waitUntilRegistered:YES];
    [channels removeObject:chan];
}
- (BOOL) didRegister
{
    return didRegister;
}
- (void)setDidRegister:(BOOL)didReg
{
    if (didRegister) {
        return;
    }
    didRegister=didReg;
    if (didReg)
    {
        for(NSString* cmd in commandsWaiting)
        {
            if([cmd isKindOfClass:[NSString class]])
            {
                [output write:(uint8_t*)[cmd UTF8String] maxLength:[cmd length]];
            }
        }
        [commandsWaiting release];
        commandsWaiting=nil;
    }
}
- (void)dealloc
{
    [self disconnect];
    NSLog(@"lol wtf");
    for (id obj in channels) {
        [obj release];
    }
    [channels release];
    [input release];
    [output release];
    [super dealloc];
}
- (SHIRCChannel*)retainedChannelWithFormattedName:(NSString*)fName;
{
    for (SHIRCChannel* rtn in [self channels]) {
        if ([[rtn formattedName] isEqualToString:fName]) {
            return [rtn retain];
        }
    }
    return nil;
}
@end
