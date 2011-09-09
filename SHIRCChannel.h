//
//  SHIRCChannel.h
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHIRCSocket.h"
#import "SHIRCChannel.h"

typedef enum SHMessageFlavor
{
    SHMessageFlavorNormal,
    SHMessageFlavorAction,
    SHMessageFlavorNotice
} SHMessageFlavor;
@interface SHIRCChannel : NSObject
{
    NSString* net;
    NSString* name;
    SHIRCSocket* socket;
    id delegate;
}
@property(retain) NSString* net;
@property(retain) NSString* name;
@property(assign) SHIRCSocket* socket;
@property(assign) id delegate;
- (id)initWithSocket:(SHIRCSocket *)sock andChanName:(NSString*)chName;
- (BOOL)sendMessage:(NSString*)message flavor:(SHMessageFlavor)flavor;
- (NSString *)formattedName;
- (void)part;
- (void)didRecieveMessageFrom:(NSString*)nick text:(NSString*)ircMessage;
- (void)parseCommand:(NSString*)command;
- (void)parseAndEventuallySendMessage:(NSString *)command;
- (void)didRecieveActionFrom:(NSString*)nick text:(NSString*)ircMessage;
@end
