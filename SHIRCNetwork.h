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
    NSMutableDictionary* settingsDict;
    SHIRCSocket* socket;
}
@property(assign) NSDictionary* settingsDict;
+(SHIRCNetwork*)createNetworkWithServer:(NSString*)server andPort:(int)port isSSLEnabled:(BOOL)ssl
                            description:(NSString*)description withUsername:(NSString*)username andNickname:(NSString*)nickname
                            andRealname:(NSString*)realname serverPassword:(NSString*)password nickServPassword:(NSString*)nickserv;
+(NSArray*)allNetworks;
-(SHIRCSocket*)connect;
-(NSString*)server;
-(NSString*)description;
-(NSString*)username;
-(NSString*)nickname;
-(NSString*)realname;
-(NSString*)serverPassword;
-(NSString*)nickServPassword;
-(int)port;
-(BOOL)hasSSL;
-(void)setServer:(NSString*)server;
-(void)setDescription:(NSString*)description;
-(void)setUsername:(NSString*)username;
-(void)setNickname:(NSString*)nickname;
-(void)setRealname:(NSString*)realname;
-(void)setServerPassword:(NSString*)nickServPassword;
-(void)setNickServPassword:(NSString*)nickServPassword;
-(void)setPort:(int)port;
-(void)setHasSSL:(BOOL)hasSSL;
+(SHIRCNetwork*)networkWithDict:(NSDictionary*)dict;
@end
