//
//  MyClass.m
//  ShadowChat
//
//  Created by Max on 9/6/11.
//  Copyright 2011 uiop. All rights reserved.
//

#import "SHRoomsTable.h"

@implementation SHRoomsTable

- (id)initWithFrame:(CGRect)frame {

	if ((self = [super initWithFrame:frame])) {
		self.transform = CGAffineTransformMakeRotation(M_PI/2);	
	}
    
    return self;
}

@end
