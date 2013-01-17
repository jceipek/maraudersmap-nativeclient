//
//  GeneralPrefsViewController.h
//  Map
//
//  Created by Julian Ceipek on 5/20/12.
//  Copyright (c) 2012-2013 ohack. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "NetworkManager.h"

@interface GeneralPrefsViewController : NSViewController <NSTextDelegate>

@property (assign) IBOutlet NSTextField *aliasField;
@property (assign) IBOutlet NSTextField *usernameField;
@property (assign) IBOutlet NSTextField *passwordField;
@property (assign) IBOutlet NSTextField *invalidPasswordLabel;
@property (assign) IBOutlet NSProgressIndicator *authSpinner;

- (IBAction)authenticateClicked:(id)sender;

@end
