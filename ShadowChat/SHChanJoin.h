//
//  SHChanJoin.h
//  ShadowChat
//
//  Created by qwerty or on 09/11/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHIRCNetwork.h"
@interface SHChanJoin : UITableViewController {
	SHIRCNetwork *network;
	BOOL needsToReIndex;
	NSMutableDictionary *rooms;
}
@property(nonatomic, assign) SHIRCNetwork* network;
- (void)done;
- (void)doneWithJoin;
- (void)addRoom:(NSString *)room withUserCount:(NSString *)_count isDone:(BOOL)done;
- (void)loadAvailableRoomsOnServer;
- (void)deleteLoadingCellIfNecessary;
@end
