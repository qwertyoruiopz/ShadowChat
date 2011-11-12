//
//  SHChatPanel.m
//  ShadowChat
//
//  Created by qwerty or on 08/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHChatPanel.h"

@implementation SHChatPanel
@synthesize tfield, output, sendbtn, bar;

- (SHIRCChannel *)chan {
    return chan;
}

- (SHChatPanel *)initWithChan:(SHIRCChannel *)chan_ {
    if ([chan_ delegate]) {
		[self release];
		return [chan_ delegate];        
	}
	[self setChan:chan_];
	return self;
}

- (void)setChan:(SHIRCChannel *)chan_ {
	[chan release];
	chan = chan_;
	[chan setDelegate:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        NSLog(@"no u");
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	[UIView beginAnimations:nil context:NULL]; // Begin animation
	[UIView setAnimationDuration:0.3f];
	CGRect pnt = bar.frame;
	pnt.origin.y = 156;
	bar.frame = pnt;
	pnt = output.frame;
	pnt.size.height = 157;
	output.frame = pnt;
	[UIView commitAnimations];
	[output stringByEvaluatingJavaScriptFromString:@"window.scrollTo(0, document.body.scrollHeight);"];
	return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView beginAnimations:nil context:NULL]; // Begin animation
    [UIView setAnimationDuration:0.3f];
    CGRect pnt=bar.frame;
    pnt.origin.y=323;
    bar.frame=pnt;
    pnt=output.frame;
    pnt.size.height=324;
    output.frame=pnt;
    [UIView commitAnimations];
    [output stringByEvaluatingJavaScriptFromString:@"window.scrollTo(0, document.body.scrollHeight);"];
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    isViewHidden = YES;
    [tfield resignFirstResponder];
    [super viewDidDisappear:animated];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length == 1 && [[textField text]length] == 1) {
		sendbtn.enabled = NO;
	}
	else if (range.length == 0 && range.location == 0) {
		sendbtn.enabled = YES;
    }
    return YES;
}


- (IBAction)sendMessageAndResign {
    [self textFieldShouldReturn:nil];
}

- (void)didRecieveMessageFrom:(NSString*)nick text:(NSString*)ircMessage {
	NSLog(@"Nick:%@ Message:%@", nick, ircMessage);
    NSString *java = [NSString stringWithFormat:@"addMessage('%@','%@');",
                      [[nick stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"],
                      [[ircMessage stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"]];
    [output stringByEvaluatingJavaScriptFromString:java];
}

- (void)didRecieveActionFrom:(NSString*)nick text:(NSString*)ircMessage_ {
	NSLog(@"Action(Nick:%@ Message:%@)",nick, ircMessage_);
    NSString *java = [NSString stringWithFormat:@"addAction('%@','%@');",
                      [[nick stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"],
                      [[ircMessage_ stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"]];
    [output stringByEvaluatingJavaScriptFromString:java];
}

- (void)didRecieveNamesList:(NSArray*)array {
    NSLog(@"ZOMG I IS EPIC AND THIS IS MY ARRAYYYYY: %@", array);
    ChannelUserList *cul = [[ChannelUserList alloc] init];
    [cul setNames:[array mutableCopy]];
    [self.navigationController pushViewController:cul animated:YES];
    [cul release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([[tfield text] isEqualToString:@""]) {
        return YES;
    }
    [chan parseAndEventuallySendMessage:[tfield text]];
    [tfield setText:@""];
	NSLog(@"source code: %@", [output stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"]);
    sendbtn.enabled = NO;

//	Line colors.... needed help picking subtle colours... >< CSS? yes... will work on formatting asap, thinking about providing the js \
	the css so that we can load it more dynamically with the themes or whatever shit... >:D \
	font picking.... Not going so well... may need to include some :) \
	http://d.pr/kTce , http://d.pr/rPuW , http://d.pr/xREJ , http://d.pr/qi2p , http://d.pr/6YCa
	
//	NSMutableArray *colors = [[NSMutableArray alloc] init];
//	for (unsigned int i = 0; i < 26; i++) {
//		[colors addObject:[NSString stringWithFormat:@"%06X", arc4random() % 16777216]];
//	}
//	NSLog(@"meh %@", colors);
//	[output stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setColors(%@)", colors]];
//	This probably won't be used. Reason being we have no control over neon, eye-hurting colors. We'd have to use CSS and write a small parser.
//	Reason being, colloquy and another clients have names attached to a certain colour based ona hash(?) This makes it easier for our eyes to tell what is actually happening.
//	Maybe something we want to look into?
	
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[[self navigationItem] setTitle:[chan formattedName]];
	[output loadHTMLString:@"\
     <html>\
     <head>\
	 <style type=\"text/css\">\
	 * {margin:0px;padding:0px;}\
	 div { /*border-top:1px solid black;*/border-bottom:1px solid black;padding-left:3px;padding-right:3px;}\
	 body {font-family:'Tahoma';}\
	 </style>\
     <script>\
     function htmlEntities(str) { return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/\"/g, '&quot;'); }\
     function addMessage(nick, msg) { document.body.innerHTML += '<div><strong>' + htmlEntities(nick) + ':</strong> ' + htmlEntities(msg) + '</div>'; window.scrollTo(0, document.body.scrollHeight); }\
     function addAction(nick, msg) { document.body.innerHTML += '<div><strong><span style=\"font-size: 24; vertical-align: middle; position:relative;\">•</span> ' + htmlEntities(nick) + '</strong> ' + htmlEntities(msg) + '</div>'; window.scrollTo(0, document.body.scrollHeight); }\
     function background_color() {\
         document.body.style.background=\"#dae0ec\";\
         return \"#dae0ec\";\
     }\
     function addEvent(from, to, extra, type)\
     {\
         if(type==\"SHEventTypeKick\") {\
             document.body.innerHTML += '<div><center>' + htmlEntities(from) + ' has kicked ' + htmlEntities(to) + ' (' + htmlEntities(extra) + ')</center></div>';\
             window.scrollTo(0, document.body.scrollHeight);\
         }\
         if(type==\"SHEventTypeJoin\") {\
             document.body.innerHTML += '<div><center>' + htmlEntities(from) + ' has joined the channel </center></div>';\
             window.scrollTo(0, document.body.scrollHeight);\
         }\
         if(type==\"SHEventTypePart\") {\
             if(extra=='(null)'){\
                 document.body.innerHTML += '<div><center>' + htmlEntities(from) + ' has left the channel </center></div>';\
                 window.scrollTo(0, document.body.scrollHeight);\
             }\
             else {\
                 document.body.innerHTML += '<div><center>' + htmlEntities(from) + ' has left the channel (' + htmlEntities(extra) + ')</center></div>';\
                 window.scrollTo(0, document.body.scrollHeight);\
             }\
         }\
     }\
     </script>\
     </head>\
     <body style=\"word-wrap: break-word; \">\
     <center>ShadowChat beta</center>\
     </body>\
     </html>\
	 " baseURL:[NSURL URLWithString:@"http://zomg.com"]];
    NSLog(@"lolwat, %@", [output stringByEvaluatingJavaScriptFromString:@"background_color();"]);//dae0ec    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    NSLog(@"cyah");
    [chan setDelegate:nil];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
    // (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated {
    isViewHidden = NO;
    NSLog(@"%@", tfield);
    NSLog(@"%@", [tfield superview]);
    [[self view] addSubview:[tfield superview]];
    [tfield becomeFirstResponder];
}

- (void)didRecieveEvent:(SHEventType)evt from:(NSString *)from to:(NSString *)to extra:(NSString *)extra {
    NSLog(@"%d %@ %@", evt, from, to);
    NSString *java = [NSString stringWithFormat:@"addEvent('%@','%@', '%@', '%@');",
                      [[from stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"],
                      [[to stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"],
                      [[extra stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"],
                      (evt == SHEventTypeKick) ? @"SHEventTypeKick" :
                      (evt == SHEventTypeJoin) ? @"SHEventTypeJoin" :
                      (evt == SHEventTypeMode) ? @"SHEventTypeMode" : 
                      (evt == SHEventTypePart) ? @"SHEventTypePart" : nil
                      ];
    [output stringByEvaluatingJavaScriptFromString:java];
}
@end
