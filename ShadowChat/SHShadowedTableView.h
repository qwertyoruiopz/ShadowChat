//
//  ShadowedTableView.h
//  ShadowedTableView
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SHShadowedTableView : UITableView {
	CAGradientLayer *originShadow;
	CAGradientLayer *topShadow;
	CAGradientLayer *bottomShadow;
}

@end
