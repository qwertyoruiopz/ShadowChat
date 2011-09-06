//
//  FirstViewController.h
//  ShadowChat
//
//  Created by qwerty or on 05/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCChanPart.h"
#import "SHIRCSocket.h"

@interface FirstViewController : UIViewController
{
    SCChanPart* callout;
    SHIRCSocket* sock;
}
-(IBAction)lolwat:(id)sender;
@end
