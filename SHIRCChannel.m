//
//  SHIRCChannel.m
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHIRCChannel.h"

@implementation SHIRCChannel
@synthesize net, name, socket, delegate;
- (id)initWithSocket:(SHIRCSocket *)sock andChanName:(NSString*)chName
{
    self = [super init];
    if (self) {
        [self setSocket:sock];
        [self setName:chName];
        [self setNet:[sock server]];
    }
    [sock addChannel:self];
    return [self retain];
}
- (NSString*)formattedName
{
    return [name hasPrefix:@"#"]||[name hasPrefix:@"&"]||[name hasPrefix:@"!"]||[name hasPrefix:@"+"] ? name : [@"#" stringByAppendingString:name];
}
- (BOOL)sendMessage:(NSString*)message flavor:(SHMessageFlavor)flavor
{
    if (![socket didRegister]) return NO;
    NSString* command;
    switch (flavor) {
        case SHMessageFlavorNotice:
            command=@"NOTICE";
            break;
        case SHMessageFlavorNormal:
        case SHMessageFlavorAction:
        default:
            command=@"PRIVMSG";
            break;
    }
    [self didRecieveMessageFrom:[socket nick_] text:message];
    return [socket sendCommand:[command stringByAppendingFormat:@" %@", [self formattedName]] withArguments:[NSString stringWithFormat:@"%@%@%@", (flavor==SHMessageFlavorAction) ? @"/x01 ACTION ", message, @"/x01" : @"", message, @""]];
}
- (void)part
{
    [socket sendCommand:@"PART" withArguments:[self formattedName]];
    [self release];
}
- (void)didRecieveMessageFrom:(NSString*)nick text:(NSString*)ircMessage
{
    NSLog(@"oh mah gawd %@", delegate);
    if ([delegate respondsToSelector:_cmd])
    {
        [delegate performSelector:_cmd withObject:nick withObject:ircMessage];
    }
}
@end
