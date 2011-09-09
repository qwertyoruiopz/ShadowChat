//
//  SHChatPanel.m
//  ShadowChat
//
//  Created by qwerty or on 08/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHChatPanel.h"

@implementation SHChatPanel
@synthesize tfield, output, sendbtn;

- (SHIRCChannel *)chan
{
    return chan;
}

- (void)setChan:(SHIRCChannel *)chan_
{
    chan=chan_;
    [chan setDelegate:self];
}

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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length==1&&[[textField text]length]==1) {
        sendbtn.enabled=NO;
    } else if (range.length==0&&range.location==0)
    {
        sendbtn.enabled=YES;
    }
    return YES;
}


- (IBAction)sendMessagePlz
{
    [self textFieldShouldReturn:nil];
}

- (void)didRecieveMessageFrom:(NSString*)nick text:(NSString*)ircMessage
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSString *java = [NSString stringWithFormat:@"addMessage('%@','%@');",
                      [[nick stringByReplacingOccurrencesOfString:@"\'" withString:@"\\'"] stringByReplacingOccurrencesOfString:@"'" withString:@"\'"],
                      [[ircMessage stringByReplacingOccurrencesOfString:@"\'" withString:@"\\'"] stringByReplacingOccurrencesOfString:@"'" withString:@"\'"]];
    [output stringByEvaluatingJavaScriptFromString:java];
    [pool release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([[tfield text] isEqualToString:@""]) {
        return YES;
    }
    
    if ([[tfield text] hasPrefix:@"/"]) {
        [chan parseCommand:[tfield text]];
    } else {    
        [chan sendMessage:[tfield text] flavor:SHMessageFlavorNormal];
    }
    [tfield setText:@""];
    sendbtn.enabled=NO;
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitle:[chan formattedName]];
    [output loadHTMLString:@"<html><head><script>function htmlEntities(str) { return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/\"/g, '&quot;'); } function addMessage(nick, msg) { document.body.innerHTML += '</br><strong>' + htmlEntities(nick) + ':</strong> ' + htmlEntities(msg) + ''; window.scrollTo(0, document.body.scrollHeight); }</script><body>ShadowChat beta</body></html>" baseURL:[NSURL URLWithString:@"http://google.com"]];  
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
    return YES;
    // (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated
{
    [tfield becomeFirstResponder];
}

@end
