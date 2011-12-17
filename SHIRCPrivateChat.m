//
//  SHIRCPrivateChat.m
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHIRCPrivateChat.h"

@implementation SHIRCPrivateChat

- (id)initWithSocket:(SHIRCSocket *)sock withNick:(NSString *)nick {
    return [self initWithSocket:sock andChanName:nick];
}
- (NSString *)formattedName {
    return name;
}

@end
