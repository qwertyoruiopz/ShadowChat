//
//  SHChannelSaver.h
//  ShadowChat
//
//  Created by Max Shavrick on 11/21/11.
//  Copyright (c) 2011 uiop. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SHChannelSaver : NSObject {
	NSString *path;
}
- (id)init;
+ (id)sharedSaver;
- (NSArray *)roomsForServer:(NSString *)server;
- (void)saveChannels:(NSArray *)chans server:(id)serv;
@end