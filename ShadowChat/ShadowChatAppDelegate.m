//
//  ShadowChatAppDelegate.m
//  ShadowChat
//
//  Created by qwerty or on 05/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "ShadowChatAppDelegate.h"
#import "TestFlight.h"

@implementation ShadowChatAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
#ifndef TARGET_IPHONE_SIMULATOR
#ifdef __DEBUG__
    [TestFlight takeOff:@"35b8aa0d259ae0c61c57bc770aeafe63_Mzk5NDYyMDExLTExLTA5IDE4OjQ0OjEwLjc4MTM3MQ"];
#endif
#endif
	NSFileManager *mngr = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingString:@"/"];
	if (![mngr fileExistsAtPath:[documentsDirectory stringByAppendingString:@"Rooms.plist"]]) {
		[mngr createFileAtPath:[documentsDirectory stringByAppendingString:@"Rooms.plist"] contents:(NSData *)[NSDictionary dictionary] attributes:NULL];
	}

    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	if (!url) return NO;
// lol so what i learned from this. NSURL = bad. :P if i have urlscheme://http:// it makes it urlscheme://http// :P WHYY
	NSMutableString *tmp = [url.absoluteString mutableCopy];
	tmp = [[tmp substringWithRange:NSMakeRange(13, tmp.length-13)] mutableCopy];
	int index = 4;
	if ([tmp rangeOfString:@"ftp//"].location != NSNotFound)
		index = 3;
	[tmp insertString:@":" atIndex:index];
	for (UINavigationController *vc in _tabBarController.viewControllers) {
		if ([vc.visibleViewController isKindOfClass:objc_getClass("SHChatPanel")]) {
			SHWebBrowser *b = [[SHWebBrowser alloc] init];
			UINavigationController *c = [[UINavigationController alloc] initWithRootViewController:b];
			[c setToolbarHidden:NO];
			[b setURLToLoad:[NSURL URLWithString:tmp]];
			c.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
			[vc presentModalViewController:c animated:YES];
			[b release];
			return NO;
		}
	}
	return NO;
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
