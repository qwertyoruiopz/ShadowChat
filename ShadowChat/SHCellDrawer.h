//
//  SHCellDrawer.h
//  ShadowChat
//
//  Created by Max Shavrick on 11/16/11.
//  Copyright (c) 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHDrawerButton.h"
typedef enum SHCellOption {
	SHCellOptionDelete = 0, 
	SHCellOptionEdit = 1,
	SHCellOptionFav = 2
} SHCellOption;

@protocol SHCellDrawerDelegate
@required
- (void)buttonPressed:(SHCellOption)option;
@end

@interface SHCellDrawer : UIView {
	id delegate;
}
@property (nonatomic, retain, setter=setDelegate:) id delegate;
- (id)initWithFrame:(CGRect)frame;
- (void)drawButtons;

@end
