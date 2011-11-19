//
//  SHCellDrawer.m
//  ShadowChat
//
//  Created by Max Shavrick on 11/16/11.
//  Copyright (c) 2011 uiop. All rights reserved.
//

#import "SHCellDrawer.h"

@implementation SHCellDrawer

- (id)initWithFrame:(CGRect)frame andDelegate:(id)del {
	if ((self = [super initWithFrame:frame])) {
		del = delegate;
		UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ctbg"]];
		[bg setFrame:self.frame];
		[self addSubview:bg];
		[bg release];
    }
    return self;
}


- (void)drawButtons {
	for (int i = 0; i < 2; i++) {
		// Allocate UIbutton.. or subclass? idk yet.
		// set each buttons tag to one SHCellOption
		// so it can be passed directly. 
		// set up their frames here, release them all after adding them to be efficient with memory.. :[
		// this will be fun! 
	}
}

- (void)aButtonPressed:(UIButton *)button {
	if ([delegate respondsToSelector:@selector(buttonPressed:)]) {
		[delegate buttonPressed:((UIButton *)button).tag];
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end