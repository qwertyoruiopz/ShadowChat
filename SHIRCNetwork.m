//
//  SHIRCNetwork.m
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHIRCNetwork.h"
#import "SHIRCChannel.h"
static NSMutableArray* networks=nil;
@implementation SHIRCNetwork
@synthesize server, port, descr, hasSSL, username, nickname, realname, serverPassword, nickServPassword, socket;
+(SHIRCNetwork*)createNetworkWithServer:(NSString*)server andPort:(int)port isSSLEnabled:(BOOL)ssl
                            description:(NSString*)description withUsername:(NSString*)username andNickname:(NSString*)nickname
                            andRealname:(NSString*)realname serverPassword:(NSString*)password nickServPassword:(NSString*)nickserv
{
    [(Class)self allNetworks];
    SHIRCNetwork* ret=[[(Class)self alloc] init];
    [ret setServer:server];
    [ret setDescr:description];
    [ret setPort:port];
    [ret setHasSSL:ssl];
    [ret setUsername:username];
    [ret setNickname:nickname];
    [ret setRealname:realname];
    [ret setServerPassword:password];
    [ret setNickServPassword:nickserv];
    [networks addObject:ret];
    [self saveDefaults];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadNetworks" object:nil];
    return ret;
}
- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:server forKey:@"server"];
    [coder encodeObject:descr forKey:@"description"];
    [coder encodeObject:[NSNumber numberWithInt:port] forKey:@"port"];
    [coder encodeObject:[NSNumber numberWithBool:hasSSL] forKey:@"hasSSL"];
    [coder encodeObject:username forKey:@"username"];
    [coder encodeObject:nickname forKey:@"nickname"];
    [coder encodeObject:realname forKey:@"realname"];
    [coder encodeObject:serverPassword forKey:@"serverPassword"];
    [coder encodeObject:nickServPassword forKey:@"nickServPassword"];
}
- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
        NSAutoreleasePool* poolz=[NSAutoreleasePool new];
        if ([coder containsValueForKey:@"server"])
            self.server = [coder decodeObjectForKey:@"server"];
        if ([coder containsValueForKey:@"description"])
            self.descr = [coder decodeObjectForKey:@"description"];
        if ([coder containsValueForKey:@"port"])
            self.port = [[coder decodeObjectForKey:@"port"] intValue];
        if ([coder containsValueForKey:@"hasSSL"])
            self.hasSSL = [[coder decodeObjectForKey:@"hasSSL"] boolValue];
        if ([coder containsValueForKey:@"nickname"])
            self.nickname = [[coder decodeObjectForKey:@"nickname"] retain];
        if ([coder containsValueForKey:@"realname"])
            self.realname = [coder decodeObjectForKey:@"realname"];
        if ([coder containsValueForKey:@"username"])
            self.username = [coder decodeObjectForKey:@"username"];
        if ([coder containsValueForKey:@"serverPassword"])
            self.serverPassword = [coder decodeObjectForKey:@"serverPassword"];
        if ([coder containsValueForKey:@"nickServPassword"])
            self.nickServPassword = [coder decodeObjectForKey:@"nickServPassword"];
        [poolz release];
    }
    return self;
}

+(void)saveDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:networks] forKey:@"Networks"];
}
-(void)saveDefaults
{
    [[self class] saveDefaults];
}
-(void)dealloc
{
    NSLog(@"OMG HAX");
    [socket disconnect];
    [socket release];
    [super dealloc];
}
+(NSMutableArray*)allNetworks
{
    if(!networks)
    {
        NSAutoreleasePool* pawl=[NSAutoreleasePool new];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Networks"])
        {
            NSArray* stuff=[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"Networks"]];//  mutableCopy];
            networks = [stuff mutableCopy];
        } else {
            networks = [[NSMutableArray alloc] init];
        }
        [pawl release];
    }
    return networks;
}
-(void)disconnect
{
    [socket disconnect];
}
-(BOOL)isOpen
{
    return ([socket status] == SHSocketStausOpen || [socket status] == SHSocketStausConnecting);
}
-(SHIRCSocket*)connect
{
    if([socket status] == SHSocketStausOpen || [socket status] == SHSocketStausConnecting)
    {
        NSLog(@"ShadowChatIRCCORE: Already connected");
        return nil;
    }
    [socket disconnect];
    if (!socket)
        socket=[SHIRCSocket socketWithServer:[self server] andPort:[self port] usesSSL:[self hasSSL]];
    [socket connectWithNick:[self nickname] andUser:[self username]];
    return socket;
}
@end
