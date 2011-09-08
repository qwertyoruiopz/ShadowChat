//
//  SHChatPanel.m
//  ShadowChat
//
//  Created by qwerty or on 08/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHChatPanel.h"

@implementation SHChatPanel
@synthesize chan, tfield;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    /*
     FIXME: hax
     */
    if (![textField inputAccessoryView]) {
        [textField setInputAccessoryView:[textField superview]];
        [textField becomeFirstResponder];
    }
    return YES;
}

- (void) viewWillDisappear:(BOOL)animated
{
    if ([tfield isFirstResponder]) {
        [tfield resignFirstResponder];
    }
    [chan release];
    [super viewDidDisappear:animated];
}

- (IBAction)sendMessagePlz
{
    [self textFieldShouldReturn:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [chan sendMessage:[tfield text] flavor:SHMessageFlavorNormal];
    [tfield setText:@""];
    return NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitle:[chan formattedName]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
