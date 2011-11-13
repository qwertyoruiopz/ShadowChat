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

}
- (void)undrawOptionsView {
	NSLog(@"undrawing...");
/*	switch (currentDirection) {
		case SHSwipeDirectionRight: 
			break;
		case SHSwipeDirectionLeft:
			break;
		default:
			break;
	}
*/	
}

@end
