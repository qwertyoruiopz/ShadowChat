//
//  SHIRCPrivateChat.h
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHIRCChannel.h"

@interface SHIRCPrivateChat : SHIRCChannel

- (id)initWithSocket:(SHIRCSocket *)sock withNick:(NSString *)nick;
- (NSString *)formattedName;

@end
