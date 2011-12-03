//
//  SHIRCManager.h
//  ShadowChat
//
//  Created by qwerty or on 06/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHIRCSocket.h"
#import "SHIRCChannel.h"


@interface SHIRCManager : NSObject {
	
}
+ (SHIRCManager *)sharedManager;
- (void)parseMessage:(NSString*)msg fromSocket:(SHIRCSocket*)socket;
- (void)parseUsermask:(NSString*)mask nick:(NSString**)nick user:(NSString**)user hostmask:(NSString**)hostmask;
- (void)dealloc;
@end
