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
		thirdLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        thirdLabel.backgroundColor = [UIColor clearColor];
        thirdLabel.textColor = [UIColor grayColor];
        thirdLabel.font = [UIFont systemFontOfSize:15];
        thirdLabel.textAlignment = UITextAlignmentRight;
		[self setAccessoryView:thirdLabel];
		[self removeAllGestureRecognizers];
		UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSwiped:)];
		[swipe setDirection:(UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight)];
		[self addGestureRecognizer:swipe];
		[swipe release];
        oldFrame=CGRectZero;
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
    if (!CGRectIsEmpty(oldFrame)) {
        return;
    }
	if (!self.editing) {
        oldFrame = self.frame;
		if ([delegate respondsToSelector:@selector(clearCellSwiped:)]) {
			[delegate clearCellSwiped:self];
		}
		drawer = [[SHCellDrawer alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) andDelegate:self];
		[self addSubview:drawer];
        [drawer release];
		[UIView animateWithDuration:0.15 delay:0.0 options:(UIViewAnimationCurveEaseIn) animations:^ {
			self.frame = CGRectMake(self.frame.size.width*-1, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
		} completion:^(BOOL finished) {
			if (finished) {
                
			}
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width*2, self.frame.size.height);
            [[self accessoryView] setHidden:1];
            self.selectionStyle=UITableViewCellSelectionStyleNone;
		}];
		[drawer setBackgroundColor:[UIColor blackColor]];
	}
}



- (void)willTransitionToState:(UITableViewCellStateMask)state {
	if (!self.editing) {
		if (state == 2)
            return;
	}
	switch (state) {
		case 0: 
			[UIView animateWithDuration:0.25 delay:0.75 options:(UIViewAnimationCurveEaseOut) animations:^{self.thirdLabel.alpha = 1; } completion:^(BOOL finished) { }];
			// this doesn't seem like it's being called at all..
			// i modify the duration/delay and there's no change..
			// but if you log something here.. it's called..
			// btw this is the case, when you Edit>Red Button "-" (When Edit button shows up) and then Hitting edit again
			// Erm.. :[
			break;
		case 1:
			[UIView animateWithDuration:0.25 animations:^{self.thirdLabel.alpha = 1; }];
			break;
		case 3:
			[UIView animateWithDuration:0.25 animations:^{self.thirdLabel.alpha = 0; }];
			break;
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
    if (CGRectIsEmpty(oldFrame)) {
        return;
    }
	NSLog(@"undrawing...");
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, oldFrame.size.width, self.frame.size.height);
	[UIView animateWithDuration:0.15
						  delay:0.0
						options:(UIViewAnimationCurveEaseIn)
					 animations: ^{ self.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, self.frame.size.width, self.frame.size.height); }
					 completion: ^(BOOL finished) {
                         if (finished&&!self.isEditing) {
                             [UIView animateWithDuration:0.10 delay:0.0 options:(UIViewAnimationCurveEaseOut) animations:^{
                                 self.frame = CGRectMake(-10, oldFrame.origin.y, self.frame.size.width, self.frame.size.height);
                             }
                                              completion: ^(BOOL fin) {
                                                  if (fin) {
                                                      [UIView animateWithDuration:0.10 delay:0.0 options:(UIViewAnimationCurveEaseIn) animations:^{
                                                          self.frame = CGRectMake(0, oldFrame.origin.y, self.frame.size.width, self.frame.size.height);
                                                      }
                                                                       completion: ^(BOOL fin) {
                                                                           [drawer removeFromSuperview];
                                                                           drawer=nil;
                                                                           oldFrame=CGRectZero;
                                                                       }];
                                                      
                                                  } else {
                                                      [drawer removeFromSuperview];
                                                      drawer=nil;
                                                      oldFrame=CGRectZero;
                                                  }
                                              }];
                         } else {
                             [drawer removeFromSuperview];
                             drawer=nil;
                             oldFrame=CGRectZero;
                         }
					 }];
    [[self accessoryView] setHidden:0];
    self.selectionStyle=UITableViewCellSelectionStyleBlue;
    [self setSelected:NO];
	if ([delegate respondsToSelector:@selector(cellReturned)]) 
		[delegate cellReturned];
    
}

@end
