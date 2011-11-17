//
//  SHCellDrawer.h
//  ShadowChat
//
//  Created by Max Shavrick on 11/16/11.
//  Copyright (c) 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum SHCellOption {
	SHCellOptionDelete, 
	SHCellOptionEdit,
	SHCellOptionFav
} SHCellOption;

@protocol SHCellDrawerDelegate
@required
- (void)buttonPressed:(SHCellOption)option;
@end

@interface SHCellDrawer : UIView {
	id delegate;
}
- (id)initWithFrame:(CGRect)frame andDelegate:(id)del;
- (void)drawButtons;

@end
