//
//  SHCmdParser.h
//  ShadowChat
//
//  Created by Max Shavrick on 11/12/11.
//  Copyright (c) 2011 uiop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHCmdParser : NSObject {
	NSMutableDictionary *cmds;
}
- (void)setEnteredCommand:(NSString *)aCmd shouldParseCaseSensitive:(BOOL)sensitive;
@end
