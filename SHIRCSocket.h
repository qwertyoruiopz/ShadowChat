//
//  SHIRCSocket.h
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Foundation/NSStream.h"


@class SHIRCChannel;
@class SHIRCSocket;
typedef enum SHSocketStaus {
    SHSocketStausNotOpen,
    SHSocketStausConnecting,
    SHSocketStausOpen,
    SHSocketStausError,
    SHSocketStausClosed
} SHSocketStaus;
@interface SHIRCSocket : NSObject <NSStreamDelegate> {
    NSInputStream *input;
    NSOutputStream *output;
    NSString *server;
    int port;
    BOOL usesSSL;
    SHSocketStaus status;
    NSMutableString *data;
    BOOL didRegister;
    NSMutableArray *commandsWaiting;
    NSMutableString *queuedCommands;
    NSMutableArray *_channels;
    NSString *nick_;
    BOOL canWrite;
    id delegate;
    int bgTask;
}
@property(retain, readwrite) NSInputStream *input;
@property(retain, readwrite) NSOutputStream *output;
@property(retain, readwrite) NSString *server;
@property(retain, readwrite) NSString *nick_;
@property(assign, readwrite) NSMutableArray *_channels;
@property(assign, readwrite) int port;
@property(assign, readwrite) BOOL usesSSL;
@property(assign, readwrite) BOOL didRegister;
@property(assign, readwrite) SHSocketStaus status;
@property(assign, readwrite) id delegate;
+ (SHIRCSocket *)socketWithServer:(NSString *)srv andPort:(int)prt usesSSL:(BOOL)ssl;
- (BOOL)connectWithNick:(NSString *)nick andUser:(NSString *)user;
- (BOOL)connectWithNick:(NSString *)nick andUser:(NSString *)user andPassword:(NSString *)pass;
- (BOOL)sendCommand:(NSString *)command withArguments:(NSString *)args;
- (BOOL)sendCommand:(NSString *)command withArguments:(NSString *)args waitUntilRegistered:(BOOL)wur;
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent;
- (void)disconnect;
- (id)channels;
- (void)joinChannel:(SHIRCChannel *)chan;
- (void)partChannel:(SHIRCChannel *)chan;
- (void)addChannel:(SHIRCChannel *)chan;
- (void)removeChannel:(SHIRCChannel *)chan;
- (void)setDidRegister:(BOOL)didReg;
- (void)dealloc;
- (SHIRCChannel *)retainedChannelWithFormattedName:(NSString *)fName;
@end
