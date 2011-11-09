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
@synthesize input, output, port, server, usesSSL, channels, status;
+ (SHIRCSocket*)socketWithServer:(NSString *)srv andPort:(int)prt usesSSL:(BOOL)ssl {
    SHIRCSocket* ret = [[(Class)self alloc]init];
    ret.server = srv;
    ret.port = prt;
    ret.usesSSL = ssl;
    return ret;
}
- (BOOL)connectWithNick:(NSString *)nick andUser:(NSString *)user {
    return [self connectWithNick:nick andUser:user andPassword:nil];
}
- (BOOL)connectWithNick:(NSString *)nick andUser:(NSString *)user andPassword:(NSString *)pass {
    NSInputStream *iStream;
    NSOutputStream *oStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)server, port ? port : 6667, (CFReadStreamRef*)&iStream, (CFWriteStreamRef *)&oStream);
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
    if (pass) {
        [self sendCommand:[NSString stringWithFormat:@"PASS %@:%@", user, pass] withArguments:nil];
    }
    [self sendCommand:[NSString stringWithFormat:@"USER %@ %@ %@ %@", user, user, user, user] withArguments:nil];
    [self sendCommand:[NSString stringWithFormat:@"NICK %@", nick] withArguments:nil];
    for (id obj in channels) {
        [self addChannel:obj];
    }
    return YES;
}
- (NSString*)nick_
{
    return nick_;
}
- (void)setNick_:(NSString *)nick
{
    [nick_ release];
    nick_ = [nick retain];
    [self sendCommand:@"NICK" withArguments:nick];
}
- (BOOL)sendCommand:(NSString *)command withArguments:(NSString *)args {
    NSString *cmd;
    NSLog(@"Command: %@ Args: %@", command, args);
    if(args)
        cmd = [command stringByAppendingFormat:@" :%@\r\n", args];
    else
        cmd = [command stringByAppendingString:@"\r\n"];
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
        status = SHSocketStausClosed;
        [data release];
        data=nil;
        [input release];
        [output release];
        [self setDidRegister:NO];
    } else if (streamEvent == NSStreamEventHasSpaceAvailable)
    {
        if (status == SHSocketStausConnecting)
        {
            status = SHSocketStausOpen;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadNetworks" object:nil];
        }
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
    [input setDelegate:nil];
    [output setDelegate:nil];
    [input release];
    [output release];
    input = nil;
    output = nil;
    status = SHSocketStausClosed;
    [self setDidRegister:NO];
}
- (void)addChannel:(SHIRCChannel*)chan
{
    NSLog(@"Joiny fun!");
    if(!channels) channels=[NSMutableArray new];
    if (channels && ![channels containsObject:chan]) {
        if (![[chan formattedName] hasSuffix:@"JOIN"] || ![[chan formattedName] hasSuffix:@"PRIVMSG"]) {
            NSLog(@"%@", channels);
            [self sendCommand:@"JOIN" withArguments:[chan formattedName] waitUntilRegistered:YES];
            [channels addObject:chan];
        }
    }
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadNetworks" object:nil];    
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
