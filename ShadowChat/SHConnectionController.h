//
//  ConnectionsTVController.h
//  ShadowChat
//
//  Created by James Long on 06/09/2011.
//  Copyright 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHAddCTController.h"
#import "SHIRCNetwork.h"
#import "SHIRCChannel.h"
#import "SHGradientView.h"
#import "SHClearLabelCellView.h"

@interface SHConnectionController : UITableViewController <SHSwipeCellDelegate> {
	BOOL isCellSwiped;
	SHClearLabelCellView *swipedCell;
    UIView* nothingView;
    BOOL isReallyEditing;
}
@property (assign,nonatomic) IBOutlet UIView* nothingView;
- (void)editConnectionForCell:(id)cell;
- (int)updateNoNetworks;
@end
