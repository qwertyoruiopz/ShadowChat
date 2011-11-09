//
//  ChannelUserList.h
//  ShadowChat
//
//  Created by James Long on 11/09/2011.
//  Copyright 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelUserList : UITableViewController {
    NSMutableArray *names;
}

@property (nonatomic, retain) NSArray *names;

@end
