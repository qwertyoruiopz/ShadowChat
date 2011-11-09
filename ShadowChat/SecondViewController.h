//
//  SecondViewController.h
//  ShadowChat
//
//  Created by qwerty or on 05/09/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
    UIPickerView *myPickerView;
    NSArray *pickerViewArray;
    IBOutlet UINavigationBar *omg;
}
- (id)sSubviews:(id)a;
@end
