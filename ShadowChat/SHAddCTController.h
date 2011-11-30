//
//  AddConnectionTVController.h
//  ShadowChat
//
//  Created by James Long on 06/09/2011.
//  Copyright 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHAddCTController : UITableViewController <UITextFieldDelegate>
{
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
    BOOL hasSSL;
}
- (id)initWithStyle:(UITableViewStyle)style theUser:(NSString *)__user aNick:(NSString *)__nick aName:(NSString *)__name thePass:(NSString *)__spass nickPass:(NSString *)__npass aDescription:(NSString *)__description aServer:(NSString *)__server aPortal:(NSString *)__port usesSSL:(BOOL)__ssl;
@end
