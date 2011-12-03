//
//  SHUsersTableView.h
//  ShadowChat
//
//  Created by Max Shavrick on 11/30/11.
//  Copyright (c) 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHUsersTableView : UITableViewController {
	NSMutableArray *users;
	NSMutableArray *ops;
	NSMutableArray *vops;
	NSMutableArray *hops;
	NSMutableArray *sops;
	NSMutableArray *aops;
	NSMutableArray *norms;
	NSMutableDictionary *userTitles;
}
- (void)setUsers:(NSArray *)_users;
- (void)sortNicks;
- (void)doneEditing:(id)g;
@end
