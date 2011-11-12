//
//  ConnectionsTVController.h
//  ShadowChat
//
//  Created by James Long on 06/09/2011.
//  Copyright 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ConnectionsTVController : UITableViewController
{
    UIView* nothingView;
    BOOL isReallyEditing;
}
@property (assign,nonatomic) IBOutlet UIView* nothingView;
- (int)updateNoNetworks;
@end
