//
//  ClearLabelsCellView.h
//  ShadowedTableView
//
//
//

#import <UIKit/UIKit.h>
#import "SHCellDrawer.h"

@protocol SHSwipeCellDelegate <NSObject>
@required
- (void)clearCellSwiped:(id)c;
- (void)cellReturned;
@end


@interface SHClearLabelCellView : UITableViewCell <SHCellDrawerDelegate> {
	BOOL wasSwiped;
	SHCellDrawer *drawer;
	CGRect oldFrame;
	BOOL _isSwiped;
	UILabel *thirdLabel;
	id <SHSwipeCellDelegate> delegate;
}
@property (nonatomic, retain) id <SHSwipeCellDelegate> delegate;
@property (nonatomic, retain) UILabel *thirdLabel;
- (id)initWithStyle:(UITableViewCellStyle)s reuseIdentifier:(NSString *)identifier;
- (void)removeAllGestureRecognizers;
- (void)cellWasSwiped:(UISwipeGestureRecognizer *)recog;
- (void)drawOptionsView;
- (void)undrawOptionsViewAnimated:(BOOL)animated;
- (void)buttonPressed:(SHCellOption)option;
@end
