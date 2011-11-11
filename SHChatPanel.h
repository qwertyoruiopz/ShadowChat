//
//  SHChatPanel.h
//  ShadowChat
//
//  Created by qwerty or on 08/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHIRCChannel.h"
#import "ChannelUserList.h"

@interface SHChatPanel : UIViewController <UITextFieldDelegate> {
    SHIRCChannel *chan;
    UITextField *tfield;
    UIWebView *output;
    UIBarButtonItem *sendbtn;
    UIToolbar *bar;
    BOOL isViewHidden;
}
@property(retain) SHIRCChannel* chan;
@property(retain) IBOutlet UITextField* tfield;
@property(retain) IBOutlet UIWebView* output;
@property(retain) IBOutlet UIBarButtonItem* sendbtn;
@property(retain) IBOutlet UIToolbar* bar;
- (SHChatPanel *)initWithChan:(SHIRCChannel *)chan_;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (IBAction)sendMessagePlz;
- (void)didRecieveMessageFrom:(NSString*)nick text:(NSString*)ircMessage;
@end