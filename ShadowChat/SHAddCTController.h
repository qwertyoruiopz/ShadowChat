//
//  AddConnectionTVController.h
//  ShadowChat
//
//  Created by James Long on 06/09/2011.
//  Copyright 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHIRCNetwork.h"

@interface SHAddCTController : UITableViewController <UITextFieldDelegate> {
    UITextField* user;
	NSString *_user;
    UITextField* nick;
	NSString *_nick;
    UITextField* name;
	NSString *_name;
    UITextField* spass;
	NSString *_spass;
    UITextField* npass;
	NSString *_npass;
    UITextField* description;
	NSString *_description;
    UITextField* server;
	NSString *_server;
    UITextField* port;
	NSString *_port;
	SHIRCNetwork *_network;
    BOOL hasSSL;
	BOOL existingConnection;
}
- (id)initWithStyle:(UITableViewStyle)style andNetwork:(SHIRCNetwork *)net;
@end
