//
//  SHIRCSocket.m
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHIRCSocket.h"
#import "Foundation/NSStream.h"
#import "SHIRCManager.h"
@implementation SHIRCSocket
@synthesize input, output, port, server, usesSSL, didRegister, nick_, channels;
+(SHIRCSocket*)socketWithServer:(NSString*)srv andPort:(int)prt usesSSL:(BOOL)ssl
{
    SHIRCSocket* ret=[[[(Class)self alloc]init] autorelease];
    ret.server=srv;
    ret.port=prt;
    ret.usesSSL=ssl;
    NSInputStream* iStream;
    NSOutputStream* oStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)srv, prt, (CFReadStreamRef*)&iStream, (CFWriteStreamRef*)&oStream);
    ret.input=iStream;
    ret.output=oStream;
    [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    iStream.delegate = ret;
    oStream.delegate = ret;
    return ret;
}
-(BOOL)connectWithNick:(NSString*)nick andUser:(NSString*)user
{
    nick_=nick;
    NSInputStream* iStream=input;
    NSOutputStream* oStream=output;
    if ([iStream streamStatus] == NSStreamStatusNotOpen)
        [iStream open];
    
    if ([oStream streamStatus] == NSStreamStatusNotOpen)
        [oStream open];
    

    if (usesSSL)
    {            
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
        
    }
    didRegister=NO;
    [self sendCommand:[NSString stringWithFormat:@"USER %@ %@ %@ %@\r\n", user, user, user, user] withArguments:nil];
    return [self sendCommand:[NSString stringWithFormat:@"NICK %@\r\n", nick] withArguments:nil];
}
-(BOOL)sendCommand:(NSString*)command withArguments:(NSString*)args
{
    NSString* cmd;
    if(args)
        cmd=[command stringByAppendingFormat:@" :%@\r\n", args];
    else
        cmd=command;
    return [output write:(uint8_t*)[cmd UTF8String] maxLength:[cmd length]];
}
-(BOOL)sendCommand:(NSString*)command withArguments:(NSString*)args waitUntilRegistered:(BOOL)wur
{
    if(didRegister) wur=NO;
    NSString* cmd;
    if(args)
        cmd=[command stringByAppendingFormat:@" :%@\r\n", args];
    else
        cmd=command;
    if(!wur){
        return [output write:(uint8_t*)[cmd UTF8String] maxLength:[cmd length]];
    }
    if(!commandsWaiting) commandsWaiting=[NSMutableArray new];
    [commandsWaiting addObject:cmd];
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
        [data release];
        data=nil;
        [input release];
        [output release];
    }
}
- (void)addChannel:(SHIRCChannel*)chan
{
    [self sendCommand:@"JOIN" withArguments:[chan formattedName] waitUntilRegistered:YES];
    if(!channels) channels=[NSMutableArray new];
    [channels addObject:chan];
    [chan sendMessage:@"#sc: Mudkipz :D" flavor:SHMessageFlavorNormal];
}
- (void)removeChannel:(SHIRCChannel*)chan
{
    [self sendCommand:@"PART" withArguments:[chan formattedName] waitUntilRegistered:YES];
    [channels removeObject:chan];
    [chan release];
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

@end
