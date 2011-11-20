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
        [self addSubview:bg];
		[bg setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		[bg release];
    }
    return self;
}


- (void)drawButtons {
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	NSArray *st = [NSArray arrayWithObjects:@"Edit", @"Del", @"Connect", nil];
	for (int i = 0; i <= 2; i++) {
		// this is only temporary. I'm sorry.
		int pos[ ] = {55, 140, 225};
		UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(pos[i], self.frame.size.height/3, 40, 20)];
		[btn setTag:(SHCellOption)i];
		[btn setTitle:[st objectAtIndex:i] forState:UIControlStateNormal];
	//	[btn setBackgroundColor:[UIColor whiteColor]];
		[btn addTarget:self action:@selector(aButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btn];
		[btn release];
		// Allocate UIbutton.. or subclass? idk yet.
		// set each buttons tag to one SHCellOption
		// so it can be passed directly. 
		// set up their frames here, release them all after adding them to be efficient with memory.. :[
		// this will be fun! 
	}
	[p drain];
}

- (void)aButtonPressed:(UIButton *)button {
	NSLog(@"fdsfs");
//	if ([delegate respondsToSelector:@selector(buttonPressed:)]) {
//		[delegate buttonPressed:(SHCellOption)((UIButton *)button).tag];
//	}
	if ([delegate respondsToSelector:@selector(undrawOptionsView)]) {
		[delegate performSelector:@selector(undrawOptionsView)];
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
