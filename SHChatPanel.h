//
//  SHChatPanel.h
//  ShadowChat
//
//  Created by qwerty or on 08/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHIRCChannel.h"
#import "SHUsersTableView.h"

#define is_iPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

@interface SHChatPanel : UIViewController <UITextFieldDelegate, UIWebViewDelegate> {
	SHUsersTableView *userList;
    SHIRCChannel *chan;
    UITextField *tfield;
    UIWebView *output;
    UIBarButtonItem *sendbtn;
    UIToolbar *bar;
    BOOL isViewHidden;
}
@property(retain) SHIRCChannel *chan;
@property(retain) IBOutlet UITextField *tfield;
@property(retain) IBOutlet UIWebView *output;
@property(retain) IBOutlet UIBarButtonItem *sendbtn;
@property(retain) IBOutlet UIToolbar *bar;
- (SHChatPanel *)initWithChan:(SHIRCChannel *)chan_;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (IBAction)sendMessageAndResign;
- (void)didRecieveMessageFrom:(NSString *)nick text:(NSString *)ircMessage;
- (BOOL)keyboardShouldUpdate:(BOOL)update;
@end
