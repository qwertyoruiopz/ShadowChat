//
//  ChannelsTVController.h
//  ShadowChat
//
//  Created by James Long on 07/09/2011.
//  Copyright 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHIRCChannel.h"
#import "SHClearLabelCellView.h"

@interface SHChannelsController : UITableViewController <SHSwipeCellDelegate> {
    BOOL isReallyEditing;
}
@end
