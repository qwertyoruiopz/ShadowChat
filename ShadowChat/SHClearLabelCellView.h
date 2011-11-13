//
//  ClearLabelsCellView.h
//  ShadowedTableView
//
//  Created by Matt Gallagher on 2009/08/21.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHSwipeCellDelegate <NSObject>
@required
- (void)clearCellSwiped:(id)c;
- (void)cellReturned;
@end

@interface SHClearLabelCellView : UITableViewCell {
	BOOL wasSwiped;
	UILabel *thirdLabel;
	id <SHSwipeCellDelegate> delegate;
}
@property (nonatomic, retain) id <SHSwipeCellDelegate> delegate;
@property (nonatomic, retain) UILabel *thirdLabel;
- (id)initWithStyle:(UITableViewCellStyle)s reuseIdentifier:(NSString *)identifier;
- (void)cellWasSwiped:(UISwipeGestureRecognizer *)recog;
- (void)drawOptionsView;
- (void)undrawOptionsView;
@end