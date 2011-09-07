//
//  SHIRCChannel.h
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHIRCSocket.h"
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
}
@property(retain) NSString* net;
@property(retain) NSString* name;
@property(assign) SHIRCSocket* socket;
- (id)initWithSocket:(SHIRCSocket*)sock andChanName:(NSString*)chName;
- (BOOL)sendMessage:(NSString*)message flavor:(SHMessageFlavor)flavor;
- (NSString*)formattedName;
- (void)part;
@end
