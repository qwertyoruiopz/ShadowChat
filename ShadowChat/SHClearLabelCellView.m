//
//  ClearLabelsCellView.m
//  ShadowedTableView
//
//  Created by Matt Gallagher on 2009/08/21.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//

#import "SHClearLabelCellView.h"

@implementation SHClearLabelCellView
@synthesize delegate;
@synthesize thirdLabel;

- (id)initWithStyle:(UITableViewCellStyle)s reuseIdentifier:(NSString *)identifier {
	if ((self = [super initWithStyle:s reuseIdentifier:identifier])) {
		thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-155, self.frame.size.height-25, 150, 20)];
        thirdLabel.backgroundColor = [UIColor clearColor];
        thirdLabel.textColor = [UIColor grayColor];
        thirdLabel.font = [UIFont systemFontOfSize:15];
        thirdLabel.textAlignment = UITextAlignmentRight;
		[self addSubview:thirdLabel];
		[self removeAllGestureRecognizers];
		UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSwiped:)];
		[swipe setDirection:(UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight)];
		[self addGestureRecognizer:swipe];
		[swipe release];
	}
	return self;
}

- (void)removeAllGestureRecognizers {
	for (id gesture in self.gestureRecognizers) {
		[self removeGestureRecognizer:gesture];
	}
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];

	self.textLabel.backgroundColor = [UIColor clearColor];
	self.detailTextLabel.backgroundColor = [UIColor clearColor];
}

- (void)dealloc {
	[super dealloc];
	[thirdLabel release];
}

- (void)cellWasSwiped:(UISwipeGestureRecognizer *)recog {
	[self drawOptionsView];
}


- (void)drawOptionsView {
	if (!self.editing) {
		if ([delegate respondsToSelector:@selector(clearCellSwiped:)]) {
			[delegate clearCellSwiped:self];
		}
		drawer = [[SHCellDrawer alloc] initWithFrame:self.frame andDelegate:self];
		oldFrame = self.frame;
		[self.superview addSubview:drawer];
		[self.superview bringSubviewToFront:self];
		[UIView animateWithDuration:0.15 delay:0.0 options:(UIViewAnimationCurveEaseIn) animations:^ {
			self.frame = CGRectMake(self.frame.size.width*-1, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
		} completion:^(BOOL finished) {
			if (finished) {
	
			}

		}];
		[drawer setBackgroundColor:[UIColor whiteColor]];
	}
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
	if (!self.editing) {
		if (state == 2)
				return;
	}
	else if (state == 3) {
		[UIView animateWithDuration:0.25 animations:^{self.thirdLabel.alpha = 0; }];
	}
	else if (state == 1) {
			[UIView animateWithDuration:0.25 animations:^{self.thirdLabel.alpha = 1; }];
	}
	[super willTransitionToState:state];
}

/*
- (void)addSubview:(UIView *)view {
	NSString *hax = NSStringFromClass([view class]);
	if ([hax hasSuffix:@"ConfirmationControl"]) {
		
		return;
	}
	[super addSubview:view];
}
*/

- (void)buttonPressed:(SHCellOption)option {
	// here let's notify the table view controller that something has happened..
	// so that class can send a UIActionSheet confirming a delete, or push the edit view controller..
	// yay?
}


//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	// overridden to prevent the swipe-to-show-delete button :[[ 
	// I'm sorry... 
	// Just to clarify, ac3xx.. nothing goes here... 
	// except maybe some stupid comments..
	// potatoe. 
	// <3
	// actually.. i later realized this doesn't affect it all
	// but in fact is probably screwing up somethign else.
	
	// :'( \
}

- (void)undrawOptionsView {
	NSLog(@"undrawing...");

	[UIView animateWithDuration:0.15
						  delay:0.0
						options:(UIViewAnimationCurveEaseIn)
					 animations: ^{ self.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, self.frame.size.width, self.frame.size.height); }
					 completion: ^(BOOL finished) {
						 [UIView animateWithDuration:0.15 delay:0.0 options:(UIViewAnimationCurveEaseOut) animations:^{
							 self.frame = CGRectMake(-10, oldFrame.origin.y, self.frame.size.width, self.frame.size.height);
						 }
										  completion: ^(BOOL fin) {
											  if (fin) {
												  self.frame = CGRectMake(0, oldFrame.origin.y, self.frame.size.width, self.frame.size.height);
												  [drawer removeFromSuperview];
												  [drawer release];
											  }
										  }];
					 }];
	if ([delegate respondsToSelector:@selector(cellReturned)]) 
		[delegate cellReturned];


}

@end
