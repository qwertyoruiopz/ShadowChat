//
//  SecondViewController.m
//  ShadowChat
//
//  Created by qwerty or on 05/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SecondViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
@implementation SecondViewController

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/
- (void)viewDidLoad {
    // Write code to create self.view
    // Then...
    pickerViewArray = [[NSArray arrayWithObjects:
                        @"#sc", @"#thegame", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zffffffffffffffffffffomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg", @"#zomg",
                        nil] retain];
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, -87, 20, 200)];
    myPickerView.delegate = self;
	[myPickerView setHidden:YES];
    myPickerView.showsSelectionIndicator = YES;
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI/2);
    rotate = CGAffineTransformScale(rotate, 0.10, 2.0);
    [myPickerView setTransform:rotate];
    myPickerView.dataSource = self;
    [myPickerView setBackgroundColor:[UIColor clearColor]];
    [omg addSubview:myPickerView];
    [myPickerView release];
    [super viewDidLoad];
} 
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [pickerViewArray count];
}


// UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	if (view) {
        [view removeFromSuperview];
    }
    for (UIView *subv in [pickerView subviews]) {
		if (![subv clipsToBounds]) {
			[subv setHidden:YES];
		}
		[subv setBackgroundColor:[UIColor clearColor]];
	}
	[self sSubviews:pickerView];
	CGRect rect = CGRectMake(0, 0, 120, 80);
	UILabel *label = [[UILabel alloc]initWithFrame:rect];
	CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI/2);
	rotate = CGAffineTransformScale(rotate, 0.10*3, 2.0*3);
	[label setTransform:rotate];
	label.text = [pickerViewArray objectAtIndex:row];
	label.font = [UIFont boldSystemFontOfSize:22.0];
	label.textAlignment = UITextAlignmentCenter;
	label.numberOfLines = 2;
	label.lineBreakMode = UILineBreakModeWordWrap;
    label.backgroundColor=[UIColor clearColor];
	label.layer.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1].CGColor;
	label.textColor = [UIColor whiteColor];
	label.shadowColor = [UIColor blackColor];
	label.shadowOffset = CGSizeMake(0, 1);
	label.clipsToBounds = YES;
    label.layer.masksToBounds=YES;
    label.layer.shouldRasterize = YES;
    label.layer.cornerRadius=8;
	return label;
}

- (id)sSubviews:(id)a {
	for (id s in [a subviews]) {
		NSLog(@"meh %@", s);
		if ([s isKindOfClass:objc_getClass("_UIOnePartImageView")]) [s removeFromSuperview];
		[self sSubviews:s];
	}
	return nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
