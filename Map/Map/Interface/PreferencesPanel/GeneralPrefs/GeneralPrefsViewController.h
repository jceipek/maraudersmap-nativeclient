//
//  GeneralPrefsViewController.h
//  Map
//
//  Created by Julian Ceipek on 5/20/12.
//  Copyright (c) 2012-2013 SLAC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "NetworkManager.h"

@interface GeneralPrefsViewController : NSViewController <NSTextDelegate>

@property (assign) IBOutlet NSTextField *aliasField;
@property (assign) IBOutlet NSTextField *usernameField;
@property (assign) IBOutlet NSTextField *userIDLabel;
@property (assign) IBOutlet NSTextField *sessionIDLabel;
@property (assign) IBOutlet NSTextField *passwordField;
@property (assign) IBOutlet NSTextField *invalidPasswordLabel;
@property (assign) IBOutlet NSProgressIndicator *authSpinner;
@property (assign) IBOutlet NSView *notAuthedView;
@property (assign) IBOutlet NSView *authedView;

- (IBAction)authenticateClicked:(id)sender;
- (void)displayAccountData;
- (void)authFinished: (NSNotification *)notificationData;

@end
