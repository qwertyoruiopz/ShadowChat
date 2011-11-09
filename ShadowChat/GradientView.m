//
//  GradientView.m
//  ShadowedTableView
//
//  Created by Matt Gallagher on 2009/08/21.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//

#import "GradientView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GradientView

//
// layerClass
//
// returns a CAGradientLayer class as the default layer class for this view
//
+ (Class)layerClass
{
	return [CAGradientLayer class];
}

// initWithFrame:
//
// Initialise the view.
//
- (id)initWithFrame:(CGRect)frame reversed:(BOOL)rev
{
    self = [super initWithFrame:frame];
	if (self)
	{
		CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
        if (rev) {
            gradientLayer.colors =
			[NSArray arrayWithObjects:
             (id)[UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:0.3].CGColor,
             (id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.3].CGColor,
             nil];
            self.backgroundColor = [UIColor blackColor];
        } else {
            gradientLayer.colors =
			[NSArray arrayWithObjects:
             (id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor,
             (id)[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:0.8].CGColor,
             nil];
            self.backgroundColor = [UIColor grayColor];
        }
    }
    return self;
}

@end
