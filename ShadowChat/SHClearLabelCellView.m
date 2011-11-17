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
		[self setAccessoryView:thirdLabel];
		[thirdLabel release];
		for (id gesture in self.gestureRecognizers) {
			[self removeGestureRecognizer:gesture];
		}
		UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSwiped:)];
		[swipe setDirection:(UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight)];
		[self addGestureRecognizer:swipe];
		[swipe release];
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];

	self.textLabel.backgroundColor = [UIColor clearColor];
	self.detailTextLabel.backgroundColor = [UIColor clearColor];
}

- (void)dealloc {

}

- (void)cellWasSwiped:(UISwipeGestureRecognizer *)recog {
	[self drawOptionsView];
}

- (void)drawOptionsView {
	NSLog(@"fdsfdsfds dfsyay ");
	if ([delegate respondsToSelector:@selector(clearCellSwiped:)]) {
		[delegate clearCellSwiped:self];
	}
	drawer = [[UIView alloc] initWithFrame:self.frame];
	
	oldFrame = self.frame;

	[UIView animateWithDuration:0.15 delay:0.0 options:(UIViewAnimationOptionCurveEaseIn) animations:^ {
		self.frame = CGRectMake(self.frame.size.width*-1, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
	} completion:^(BOOL finished) {
		if (finished) 
		[self.superview addSubview:drawer];
	}];
	[drawer setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];

}

- (void)buttonPressed:(SHCellOption)option {
	// here let's notify the table view controller that something has happened..
	// so that class can send a UIActionSheet confirming a delete, or push the edit view controller..
	// yay?
}

- (void)undrawOptionsView {
	NSLog(@"undrawing...");
	[drawer removeFromSuperview];
	[drawer release];
	[UIView animateWithDuration:0.15
						  delay:0.0
						options:(UIViewAnimationOptionCurveEaseIn)
					 animations: ^{ self.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, self.frame.size.width, self.frame.size.height); }
					 completion: ^(BOOL finished) {
						 [UIView animateWithDuration:0.15 delay:0.0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
							 self.frame = CGRectMake(-10, oldFrame.origin.y, self.frame.size.width, self.frame.size.height);
						 }
										  completion: ^(BOOL fin) {
											  if (fin) {
												  self.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, self.frame.size.width, self.frame.size.height);
											  }
										  }];}];
	
	
//	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationDuration:0.15];
//	self.frame = CGRectMake(0, oldFrame.origin.y, self.frame.size.width, self.frame.size.height);
//	[UIView commitAnimations];
}

@end
