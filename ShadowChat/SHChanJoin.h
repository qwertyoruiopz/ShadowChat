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
	NSMutableArray *_rooms;
	NSMutableDictionary *rooms;
}
@property(nonatomic, assign) SHIRCNetwork* network;
- (void)done;
- (void)doneWithJoin:(NSString *)room;
- (void)addRoom:(NSString *)room withRoomInfo:(NSDictionary *)infos;
- (void)loadAvailableRoomsOnServer;
- (void)deleteLoadingCellIfNecessary;
@end
