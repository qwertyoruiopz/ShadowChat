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
    NSDictionary* settingsDict;
}
+(SHIRCNetwork*)createNetworkWithServer:(NSString*)server andPort:(int)port isSSLEnabled:(BOOL)ssl
                            description:(NSString*)description withUsername:(NSString*)username andNickname:(NSString*)nickname
                            andRealname:(NSString*)realname serverPassword:(NSString*)password nickServPassword:(NSString*)nickserv;
+(NSArray*)allNetworks;
-(SHIRCSocket*)connect;
@end
