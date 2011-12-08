//
//  SHUsersTableView.h
//  ShadowChat
//
//  Created by Max Shavrick on 11/30/11.
//  Copyright (c) 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHUsersTableView : UITableViewController {
	NSMutableArray *ops;
	NSArray *arrayOfArrays;
	NSMutableArray *vops;
	NSMutableArray *hops;
	NSMutableArray *sops;
	NSMutableArray *aops;
	NSMutableArray *norms;
	NSMutableDictionary *userTitles;
}
- (void)setUsers:(NSArray *)_users;
- (void)sortNicks;
- (void)removeUser:(NSString *)aUser;
- (void)addUser:(NSString *)aUser;
- (void)categorizeNick:(NSString *)aNick;
- (void)doneEditing:(id)g;
- (void)setMode:(NSString *)mode forUser:(NSString *)_cUser;
- (void)findArrayAndRemoveNick:(NSString *)_sUser;
@end
