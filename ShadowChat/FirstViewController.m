//
//  FirstViewController.m
//  ShadowChat
//
//  Created by qwerty or on 05/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "FirstViewController.h"
#import "SCChanPart.h"
#import "SHIRCChannel.h"
@implementation FirstViewController
-(IBAction)lolwat:(id)sender
{
    if(!callout)
    {
        callout = [[SCChanPart alloc] initWithFrame:CGRectZero];
        sock = [SHIRCSocket socketWithServer:@"irc.icj.me" andPort:6697 usesSSL:YES]; 
        [sock connectWithNick:@"woot" andUser:@"lolrly"];
        [callout setChan:[[[SHIRCChannel alloc] initWithSocket:sock andChanName:@"#sc"] autorelease]];
        //[callout addTarget:self action:@selector(closeCalloutView:)];
        [self.view addSubview:callout];
        [callout setAnchorPoint:CGPointMake(80, 40) boundaryRect:[UIScreen mainScreen].applicationFrame animate:YES];
        [callout setOpacity:0.8f];
        [callout release];
        [sender setTitle:@"Disconnect"];
    } else
    {
        [callout die];
        [sender setTitle:@"Connect"];
        callout=nil;
    }
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
