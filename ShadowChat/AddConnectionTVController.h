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
    NSString* user;
    NSString* nick;
    NSString* name;
    NSString* spass;
    NSString* npass;
    NSString* description;
    NSString* server;
    int port;
    BOOL hasSSL;
}
@end
