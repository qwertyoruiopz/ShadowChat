//
//  SHWebBrowser.m
//  ShadowChat
//
//  Created by Max Shavrick on 12/13/11.
//  Copyright (c) 2011 uiop. All rights reserved.
//

#import "SHWebBrowser.h"


@implementation SHWebBrowser

- (id)init {
	if ((self = [super init])) {
		_browser = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/*factored for iPhone in portrait.. ;( i'll fix soon. promise.:P*/, self.view.frame.size.height-88)];
		[_browser setDelegate:self];
		[_browser setScalesPageToFit:YES];
		[self performSelectorInBackground:@selector(addToolBarButtons) withObject:nil];
		UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissMe)];
		[self.navigationItem setRightBarButtonItem:done];
		[done release];
		[self.view addSubview:_browser];
	}
	return self;
}
								 
- (void)dismissMe {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)addToolBarButtons {
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(browserGoBack:)];
	backButton.tag = 0001;
	UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(browserGoFwd:)];
	forwardButton.tag = 0002;
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:_browser action:@selector(stopLoading)];
	cancelButton.tag = 0003;
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:_browser action:@selector(reload)];
	refreshButton.tag = 0004;
	[self setToolbarItems:[NSArray arrayWithObjects:backButton, forwardButton, cancelButton, refreshButton, nil] animated:YES];
	[backButton release];
	[forwardButton release];
	[cancelButton release];
	[refreshButton release];
	[p drain];
}

- (void)browserGoBack:(UIBarButtonItem *)bttn {

	[_browser goBack];
	[self toggleBackButtons];
	
}

- (void)toggleBackButtons {
	for (UIBarButtonItem *t in self.navigationController.toolbarItems) {
		if (t.tag == 0001) {
			t.enabled = [_browser canGoBack];
		}
		if (t.tag == 0002) {
			t.enabled = [_browser canGoForward];
		}
	}
}

- (void)browserGoFwd:(UIBarButtonItem *)btn {
	[_browser goForward];
	[self toggleBackButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	for (UIBarButtonItem *itm in self.navigationController.toolbar.items) {
		if (itm.tag == 0004) {
			itm.enabled = YES;
			break;
		}
		else if (itm.tag == 0003) {
			itm.enabled = NO;
		}
	}
	self.title = [_browser stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	for (UIBarButtonItem *itm in self.navigationController.toolbar.items) {
		if (itm.tag == 0004) {
			itm.enabled = NO;
			break;
		}
		else if (itm.tag == 0003) {
			itm.enabled = YES;
		}
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setURLToLoad:(NSURL *)aURL {
	NSLog(@"Loading URL.. %@",aURL);
	[_browser loadRequest:[NSURLRequest requestWithURL:aURL]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)dealloc {
	[super dealloc];
	[_browser release];
}

@end
