//
//  ClearLabelsCellView.m
//  ShadowedTableView
//
// <3
//

#import "SHClearLabelCellView.h"
#import "SHIRCNetwork.h"
#import "ShadowChatAppDelegate.h"

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
        oldFrame = CGRectZero;
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
	NSLog(@"Trying to draw.. %@", recog);
	if (_isSwiped) {
		[self undrawOptionsViewAnimated:YES];
		_isSwiped = NO;
		return;
	}
	_isSwiped = NO;
	if (!self.editing)
		[self drawOptionsView];
}


- (void)drawOptionsView {
    if (_isSwiped) {
        return;
    }
    _isSwiped = YES;
	if (!self.editing) {
        oldFrame = self.frame;
		if ([delegate respondsToSelector:@selector(clearCellSwiped:)]) {
			[delegate clearCellSwiped:self];
		}
		drawer = [[SHCellDrawer alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
		[drawer setDelegate:self];
		[drawer drawButtons];
		[self addSubview:drawer];
        [drawer release];
		[UIView animateWithDuration:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 0.17 : 0.15 delay:0.0 options:(UIViewAnimationCurveEaseIn) animations:^ {
			self.frame = CGRectMake(self.frame.size.width*-1, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
		} completion:^(BOOL finished) {
			if (finished) {
                
			}
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width*2, self.frame.size.height);
            [[self accessoryView] setHidden:YES];
            self.selectionStyle = UITableViewCellSelectionStyleNone;
		}];
		[drawer setBackgroundColor:[UIColor blackColor]];
	}
}

- (void)showConfirmation {
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Are you sure you want to delete network %@", self.textLabel.text] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
	[sheet showFromTabBar:((ShadowChatAppDelegate *)[[UIApplication sharedApplication] delegate]).tabBarController.tabBar];
	[sheet release];
}

- (void)buttonPressed:(SHCellOption)option {
	switch (option) {
		case SHCellOptionDelete:
			[self showConfirmation];
			break;
			
		case SHCellOptionEdit:
			if ([delegate respondsToSelector:@selector(editConnectionForCell:)]) {
				[delegate editConnectionForCell:self];
			}
			break;
		case SHCellOptionFav:
			break;
		default: break;
	}
	[self undrawOptionsViewAnimated:YES];
}

- (void)removeMeGlobally {
	for (SHIRCNetwork *netw in [SHIRCNetwork allNetworks]) {
		if ([self.textLabel.text isEqualToString:netw.descr] && [self.detailTextLabel.text isEqualToString:netw.server]) {
			[netw disconnect];
			[[SHIRCNetwork allNetworks] removeObject:netw];
			[((UITableView *)self.superview) beginUpdates];
			[((UITableView *)self.superview) deleteRowsAtIndexPaths:[NSArray arrayWithObject:[((UITableView *)self.superview) indexPathForCell:self]] withRowAnimation:UITableViewRowAnimationRight];
			[((UITableView *)self.superview) endUpdates];
			break;
		}
	}
	[SHIRCNetwork saveDefaults];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
			[self removeMeGlobally];
			break;
		case 1:
			// cancelled.. :D
			break;
		default:
			break;
	}
}

- (void)undrawOptionsViewAnimated:(BOOL)animated {
	if (animated) {
		if (!_isSwiped) {
			return;
		}
		_isSwiped = NO;
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, oldFrame.size.width, self.frame.size.height);
		[UIView animateWithDuration:0.15 delay:0.0 options:(UIViewAnimationCurveEaseIn) 
						 animations: ^{ self.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, self.frame.size.width, self.frame.size.height); }
						 completion: ^(BOOL finished) {
							 if (finished && !self.isEditing) {
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
																			   drawer = nil;
																			   oldFrame = CGRectZero;
																		   }];
                                                      
													  } else {
														  [drawer removeFromSuperview];
														  drawer = nil;
														  oldFrame = CGRectZero;
													  }
												  }];
							 } else {
								 [drawer removeFromSuperview];
								 drawer = nil;
								 oldFrame = CGRectZero;
							 }
						 }];

		}
	else {
		self.frame = oldFrame;
	}
	[[self accessoryView] setHidden:0];
	self.selectionStyle = UITableViewCellSelectionStyleBlue;
	[self setSelected:NO];
	if ([delegate respondsToSelector:@selector(cellReturned)]) 
		[delegate cellReturned];
}

@end
