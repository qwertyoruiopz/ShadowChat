//
//  SHIRCSocket.h
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHIRCSocket : NSObject <NSStreamDelegate>
{
    NSInputStream* input;
    NSOutputStream* output;
    NSString* server;
    int port;
    BOOL usesSSL;
    NSMutableString* data;
    BOOL didRegister;
    NSMutableArray* commandsWaiting;
    NSMutableArray* channels;
    NSString* nick_;
}
@property(retain, readwrite) NSInputStream* input;
@property(retain, readwrite) NSOutputStream* output;
@property(retain, readwrite) NSString* server;
@property(retain, readwrite) NSString* nick_;
@property(retain, readwrite) NSMutableArray* channels;
@property(assign, readwrite) int port;
@property(assign, readwrite) BOOL usesSSL;
@property(assign, readwrite) BOOL didRegister;
+ (SHIRCSocket*)socketWithServer:(NSString *)server andPort:(int)port usesSSL:(BOOL)ssl;
- (BOOL)sendCommand:(NSString *)command withArguments:(NSString *)args;
- (BOOL)connectWithNick:(NSString *)nick andUser:(NSString *)user;
@end
