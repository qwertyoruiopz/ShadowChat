//
//  AddConnectionTVController.h
//  ShadowChat
//
//  Created by James Long on 06/09/2011.
//  Copyright 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddConnectionTVController : UITableViewController <UITextFieldDelegate>
{
    UITextField* user;
    UITextField* nick;
    UITextField* name;
    UITextField* spass;
    UITextField* npass;
    UITextField* description;
    UITextField* server;
    UITextField* port;
    BOOL hasSSL;
}
@end
