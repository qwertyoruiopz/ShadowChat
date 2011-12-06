//
//  SHCellDrawer.m
//  ShadowChat
//
//  Created by Max Shavrick on 11/16/11.
//  Copyright (c) 2011 uiop. All rights reserved.
//

#import "SHCellDrawer.h"

@implementation SHCellDrawer
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {

		UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ctbg"]];
        [self addSubview:bg];
		[bg setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		[bg release];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"[%@ touchesBegan:%@ withEvent:%@]", NSStringFromClass([self class]), touches, event);
}

- (void)drawButtons {
	NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	NSArray *st = [NSArray arrayWithObjects:@"Del", @"Edit", @"Connect", nil];
	for (int i = 0; i <= 2; i++) {
		// this is only temporary. I'm sorry.
		int pos[ ] = {self.frame.size.width/5, self.frame.size.width/3, self.frame.size.width/2};
		UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(pos[i], 0, 40, self.frame.size.height)];
		[btn setTag:(SHCellOption)i];
		[btn setTitle:[st objectAtIndex:i] forState:UIControlStateNormal];
		[btn setFrame:CGRectMake(((self.frame.size.width/3.8)*(i == 0 ? 1 : i+1))-40, 0, 40, self.frame.size.height)];
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
	NSLog(@"Yay! %@, del: %@",button, delegate);

	if ([delegate respondsToSelector:@selector(buttonPressed:)]) {
		[delegate buttonPressed:(SHCellOption)button.tag];
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
