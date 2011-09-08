//
//  SHChatPanel.h
//  ShadowChat
//
//  Created by qwerty or on 08/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHIRCChannel.h"
@interface SHChatPanel : UIViewController
{
    SHIRCChannel* chan;
    UITextField* tfield;
}
@property(retain) SHIRCChannel* chan;
@property(retain) IBOutlet UITextField* tfield;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (IBAction)sendMessagePlz;
@end
