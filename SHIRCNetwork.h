//
//  SHIRCNetwork.h
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHIRCSocket.h"
@interface SHIRCNetwork : NSObject
{
    SHIRCSocket* socket;
    NSString* server;
    NSString* descr;
    NSString* username;
    NSString* nickname;
    NSString* realname;
    NSString* serverPassword;
    NSString* nickServPassword;
    int port;
    BOOL hasSSL;
}
@property(retain) NSString* server;
@property(retain) NSString* descr;
@property(retain) NSString* username;
@property(retain) NSString* nickname;
@property(retain) NSString* realname;
@property(retain) NSString* serverPassword;
@property(retain) NSString* nickServPassword;
@property(assign) int port;
@property(assign) BOOL hasSSL;
@property(assign) SHIRCSocket* socket;
+(SHIRCNetwork*)createNetworkWithServer:(NSString*)server andPort:(int)port isSSLEnabled:(BOOL)ssl
                            description:(NSString*)description withUsername:(NSString*)username andNickname:(NSString*)nickname
                            andRealname:(NSString*)realname serverPassword:(NSString*)password nickServPassword:(NSString*)nickserv;
+(void)saveDefaults;
+(NSArray*)allNetworks;
@end
