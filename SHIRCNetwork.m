//
//  SHIRCNetwork.m
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHIRCNetwork.h"
static NSMutableArray* networks=nil;
@implementation SHIRCNetwork
@synthesize settingsDict;
+(SHIRCNetwork*)createNetworkWithServer:(NSString*)server andPort:(int)port isSSLEnabled:(BOOL)ssl
                            description:(NSString*)description withUsername:(NSString*)username andNickname:(NSString*)nickname
                            andRealname:(NSString*)realname serverPassword:(NSString*)password nickServPassword:(NSString*)nickserv
{
    [(Class)self allNetworks];
    SHIRCNetwork* ret=[[(Class)self alloc] init];
    [ret setSettingsDict:[[NSMutableDictionary alloc] init]];
    [ret setServer:server];
    [ret setDescription:description];
    [ret setPort:port];
    [ret setHasSSL:ssl];
    [ret setUsername:username];
    [ret setNickname:nickname];
    [ret setRealname:realname];
    [ret setServerPassword:password];
    [ret setNickServPassword:nickserv];
    if(!networks)
    {
        networks=[[NSMutableArray alloc] init];
    }
    [networks addObject:[ret settingsDict]];
    [[NSUserDefaults standardUserDefaults] setObject:networks forKey:@"Networks"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadNetworks" object:nil];
    return ret;
}
+(SHIRCNetwork*)networkWithDict:(NSDictionary*)dict
{
    SHIRCNetwork* ret=[[(Class)self alloc] init];
    [ret setSettingsDict:[dict mutableCopy]];
    return ret;
}
-(void)dealloc
{
    [settingsDict release];
    [super dealloc];
}
+(NSArray*)allNetworks
{
    if (!networks) {
        networks=[[[NSUserDefaults standardUserDefaults] arrayForKey:@"Networks"] mutableCopy];
    }
    return networks;
}
-(void)disconnectAndRelease
{
    [socket disconnect];
    [self release];
}
-(SHIRCSocket*)connect
{
    NSLog(@"Connecting :D");
    if(![self server]) return nil;
    NSLog(@"mmkai");
    NSLog(@"%@", settingsDict);
    SHIRCSocket* ret=[SHIRCSocket socketWithServer:[self server] andPort:[self port] usesSSL:[self hasSSL]];
    if(!ret) NSLog(@"noes :(");
    [ret connectWithNick:[self nickname] andUser:[self username]];
    if([self serverPassword])
        [ret sendCommand:[@"PASS" stringByAppendingString:[self serverPassword]] withArguments:nil];
    if([self nickServPassword])
        [ret sendCommand:@"PRIVMSG NickServ" withArguments:[NSString stringWithFormat:@"IDENTIFY %@", [self nickServPassword]] waitUntilRegistered:YES];
    socket = ret;
    return ret;
}
-(NSString*)server
{
    return [settingsDict objectForKey:@"server"];
}
-(NSString*)description
{
    return [settingsDict objectForKey:@"description"];
}
-(NSString*)username
{
    return [settingsDict objectForKey:@"username"];
}
-(NSString*)nickname
{
    return [settingsDict objectForKey:@"nickname"];
}
-(NSString*)realname
{
    return [settingsDict objectForKey:@"realname"];
}
-(NSString*)serverPassword
{
    return [settingsDict objectForKey:@"serverPassword"];
}
-(NSString*)nickServPassword
{
    return [settingsDict objectForKey:@"nickServPassword"];
}
-(int)port
{
    return [[settingsDict objectForKey:@"port"] intValue] ? [[settingsDict objectForKey:@"port"] intValue] : 6667;
}
-(BOOL)hasSSL
{
    return [[settingsDict objectForKey:@"hasSSL"] boolValue];
}
#define __print(x) x
#define __print_(x) #x
#define setObj(x) NSLog(@"%@ - %@", x,__print(@)__print_(x)); if(x) [settingsDict setObject:x forKey:__print(@)__print_(x)];
-(void)setServer:(NSString*)server
{
    setObj(server)
}
-(void)setDescription:(NSString*)description
{
    setObj(description)
}
-(void)setUsername:(NSString*)username
{
    setObj(username)
}
-(void)setNickname:(NSString*)nickname
{
    setObj(nickname)
}
-(void)setRealname:(NSString*)realname
{
    setObj(realname)
}
-(void)setNickServPassword:(NSString*)nickServPassword
{
    setObj(nickServPassword)
}
-(void)setServerPassword:(NSString*)nickServPassword
{
    setObj(nickServPassword)
}
-(void)setPort:(int)port
{
    NSLog(@"port r %@", [NSNumber numberWithInt:port ? port : 6667]);
    [settingsDict setObject:[NSNumber numberWithInt:port ? port : 6667] forKey:@"port"];
}
-(void)setHasSSL:(BOOL)hasSSL
{
    [settingsDict setObject:[NSNumber numberWithBool:hasSSL] forKey:@"hasSSL"];
}

@end
