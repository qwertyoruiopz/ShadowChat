//
//  SHChatPanel.m
//  ShadowChat
//
//  Created by qwerty or on 08/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHChatPanel.h"

//#define is_iPad ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))

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
	userList = [[SHUsersTableView alloc] initWithStyle:UITableViewStylePlain];
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
	return [self keyboardShouldUpdate:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	return [self keyboardShouldUpdate:NO];
}

- (BOOL)keyboardShouldUpdate:(BOOL)update {
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:0.3f];
	CGRect pnt = bar.frame;
	int offset = 0;
	if (update) {
		if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad)
			offset = 47;
		if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
			offset = -65;
		pnt.origin.y = frame.size.height-307-pnt.size.height+offset;
			NSLog(@"fdfs yay %@", bar);
	}
	else {
		if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]))
			offset = -167;
		pnt.origin.y = frame.size.height-93-pnt.size.height+offset;
	}
	bar.frame = pnt;
	pnt = output.frame;
	pnt.size.height = bar.frame.origin.y;
	output.frame = pnt;
	[UIView commitAnimations];
	[output stringByEvaluatingJavaScriptFromString:@"window.scrollTo(0, document.body.scrollHeight);"];
	return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    isViewHidden = YES;
    [tfield resignFirstResponder];
    [super viewDidDisappear:animated];
}

- (BOOL)canBecomeFirstResponder {
	return YES;
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

- (void)didRecieveMessageFrom:(NSString *)nick text:(NSString *)ircMessage {
	NSLog(@"Nick:%@ Message:%@", nick, ircMessage);
	NSString *format = @"addMessage('%@','%@');";
	NSRange r = [ircMessage rangeOfString:@"http://"];
	if (r.location != NSNotFound) {
		format = @"addHTML('%@','%@');";
	}
	else {
		// try https...:o
		r = [ircMessage rangeOfString:@"https://"];
		if (r.location != NSNotFound) {
			format = @"addHTML('%@','%@');";	
		}	
	}
	NSString *java = [NSString stringWithFormat:format,
                      [[nick stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"],
                      [[ircMessage stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"]];
	NSLog(@"fdfsd %@", [output stringByEvaluatingJavaScriptFromString:java]);
}

- (void)didRecieveActionFrom:(NSString *)nick text:(NSString *)ircMessage_ {
	NSLog(@"Action(Nick:%@ Message:%@)",nick, ircMessage_);
    NSString *java = [NSString stringWithFormat:@"addAction('%@','%@');",
                      [[nick stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"],
                      [[ircMessage_ stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"] stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"]];
    [output stringByEvaluatingJavaScriptFromString:java];
}

- (void)didRecieveNamesList:(NSArray*)array {
    NSLog(@"ZOMG I IS EPIC AND THIS IS MY ARRAYYYYY: %@", array);

//	ChannelUserList *cul = [[ChannelUserList alloc] init];
//	[cul setNames:[array mutableCopy]];
//	[self.navigationController pushViewController:cul animated:YES];
//	[cul release];
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

- (void)showUsersView:(id)btn {
	[userList setUsers:chan.users];
	UINavigationController *ctrlr = [[[UINavigationController alloc] initWithRootViewController:userList] autorelease];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		UIPopoverController *userPopover = [[UIPopoverController alloc] initWithContentViewController:ctrlr];
		[userPopover setContentViewController:ctrlr];
		[userPopover setPopoverContentSize:CGSizeMake(320, 480)];
		if ([btn isKindOfClass:[UIBarButtonItem class]]) {
			[userPopover presentPopoverFromBarButtonItem:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}
		else 
			[userPopover presentPopoverFromRect:((UIView *)btn).frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
	else {
		[self.navigationController pushViewController:userList animated:YES];
	}
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[[self navigationItem] setTitle:[chan formattedName]];
	UIBarButtonItem *users = [[UIBarButtonItem alloc] initWithTitle:@"Users" style:UIBarButtonItemStyleBordered target:self action:@selector(showUsersView:)];
	[[self navigationItem] setRightBarButtonItem:users];
	[users release];
	[output loadHTMLString:@"\
	 <html>\
	 <head>\
	 <style type=\"text/css\">\
	 * {margin:0px;padding:0px;}\
	 div { /*border-top:1px solid black;*/border-bottom:1px solid black;padding-left:3px;padding-right:3px;}\
	 body {font-family:'Times';font-size:14.5;}\
	 </style>\
	 <script>\
	 function emojify(str) {return str;}\
	 function replaceURLWithHTMLLinks(text) {\
	 var exp = /(\\b(https?|ftp|file):\\/\\/[-A-Z0-9+&@#\\/%?=~_|!:,.;]*[-A-Z0-9+&@#\\/%=~_|])/ig;\
	 return text.replace(exp,\"<a href='sc-urlopen://$1'>$1</a>\");}\
	 function htmlEntities(str) { return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/\"/g, '&quot;');}\
     function addMessage(nick, msg) { document.body.innerHTML += '<div><strong>' + htmlEntities(nick) + ':</strong> ' + htmlEntities(emojify(msg)) + '</div>'; window.scrollTo(0, document.body.scrollHeight); }\
	 function addHTML(nick, msg) {  document.body.innerHTML += '<div><strong>' + htmlEntities(nick) + ':</strong> ' + replaceURLWithHTMLLinks(emojify(msg)) + '</div>'; window.scrollTo(0, document.body.scrollHeight); }\
     function addAction(nick, msg) { document.body.innerHTML += '<div><strong>• ' + htmlEntities(nick) + '</strong> ' + htmlEntities(msg) + '</div>'; window.scrollTo(0, document.body.scrollHeight); }\
     function background_color() {\
         document.body.style.background=\"#dae0ec\";\
         return \"#dae0ec\";\
	 }\
	 function addEvent(from, to, extra, type) {\
		if (type == \"SHEventTypeKick\") {\
			document.body.innerHTML += '<div><center>' + htmlEntities(from) + ' has kicked ' + htmlEntities(to) + ' (' + htmlEntities(extra) + ')</center></div>';\
			window.scrollTo(0, document.body.scrollHeight);\
		}\
		else if (type == \"SHEventTypeJoin\") {\
			document.body.innerHTML += '<div><center>' + htmlEntities(from) + ' has joined the channel </center></div>';\
			window.scrollTo(0, document.body.scrollHeight);\
		}\
		else if (type == \"SHEventTypePart\") {\
			if(extra == '(null)'){\
				document.body.innerHTML += '<div><center>' + htmlEntities(from) + ' has left the channel </center></div>';\
				window.scrollTo(0, document.body.scrollHeight);\
			}\
			else {\
				document.body.innerHTML += '<div><center>' + htmlEntities(from) + ' has left the channel (' + htmlEntities(extra) + ')</center></div>';\
				window.scrollTo(0, document.body.scrollHeight);\
			}\
		}\
		else if (type == \"SHEventTypeMode\") {\
				document.body.innerHTML += '<div><center>' + htmlEntities(from) + ' sets modes ' + htmlEntities(to) + ' ' + htmlEntities(extra) + '</center></div>';\
				window.scrollTo(0, document.body.scrollHeight);\
		}\
	 }\
	 </script>\
	 </head>\
	 <body style=\"word-wrap: break-word; \">\
	 <center>ShadowChat beta</center>\
	 </body>\
	 </html>\
	 " baseURL:[NSURL URLWithString:@"about:blank"]];
	[output setDelegate:self];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    NSLog(@"cyah");
    [chan setDelegate:nil];
	[userList release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	NSLog(@"fdfsd %@", self.navigationController.topViewController);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	NSLog(@"fdfsd %@", self.navigationController.topViewController);
}

- (void)viewDidAppear:(BOOL)animated {
    isViewHidden = NO;
    NSLog(@"%@", tfield);
    NSLog(@"%@", [tfield superview]);
    [[self view] addSubview:[tfield superview]];
    [tfield becomeFirstResponder];
}
//1 TheGame -v notaqwertyoruiop
- (void)didRecieveEvent:(SHEventType)evt from:(NSString *)from to:(NSString *)to extra:(NSString *)extra {
    NSLog(@"%d %@ %@ %@", evt, from, to, extra);
	switch (evt) {
		case SHEventTypeJoin:
			if (![from isEqualToString:[[chan socket] nick_]])
				[userList addUser:from];
			break;
		case SHEventTypeKick:
			[userList removeUser:to];
			break;
		case SHEventTypeMode:
			[userList setMode:to forUser:extra fromUser:from];
		//	[output stringByEvaluatingJavaScriptFromString:@""];
			break;
		case SHEventTypePart:
			[userList removeUser:from];
			break;
		default:
			break;
	}
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
