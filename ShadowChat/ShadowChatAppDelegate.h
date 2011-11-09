//
//  ShadowChatAppDelegate.h
//  ShadowChat
//
//  Created by qwerty or on 05/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShadowChatAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
