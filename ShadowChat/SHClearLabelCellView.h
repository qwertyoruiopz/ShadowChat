//
//  ClearLabelsCellView.h
//  ShadowedTableView
//
//  Created by Matt Gallagher on 2009/08/21.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum SHSwipeDirection {
	SHSwipeDirectionLeft,
	SHSwipeDirectionRight
} SHSwipeDirection;
@protocol SHSwipeCellDelegate <NSObject>
@required
- (void)clearCellSwiped:(id)c swipe:(UISwipeGestureRecognizer *)g;
@end

@interface SHClearLabelCellView : UITableViewCell {
	BOOL wasSwiped;
	UILabel *thirdLabel;
	SHSwipeDirection currentDirection;
	id <SHSwipeCellDelegate> delegate;
}
@property (nonatomic, retain) id <SHSwipeCellDelegate> delegate;
@property (nonatomic, retain) UILabel *thirdLabel;
- (id)initWithStyle:(UITableViewCellStyle)s reuseIdentifier:(NSString *)identifier;
- (void)cellWasSwpied:(UISwipeGestureRecognizer *)recog;
- (void)drawOptionsView:(SHSwipeDirection)direction;
- (void)undrawOptionsView;
@end
