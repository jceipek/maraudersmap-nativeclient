//
//  GeneralPrefsViewController.m
//  Map
//
//  Created by Julian Ceipek on 5/20/12.
//  Copyright (c) 2012 ohack. All rights reserved.
//

#import "GeneralPrefsViewController.h"

@implementation GeneralPrefsViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize authSpinner;
@synthesize invalidPasswordLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(authFinished:)
                                                     name:@"authFinished"
                                                   object:nil];
    }
    return self;
}

- (IBAction)authenticateClicked: (id)sender {
    [authSpinner startAnimation: sender];
    [[NetworkManager theNetworkManager] authenticateWithUsername: [usernameField stringValue] password: [passwordField stringValue]];
    NSLog(@"Tried to Authenticate!");
}

- (void)authFinished: (NSNotification *)notificationData {
    NSDictionary *theData = [notificationData userInfo];
    NSLog(@"Auth finished");
    if (theData != nil) {
        NSNumber *successNum = [theData objectForKey:@"Success"];
        if ([successNum boolValue]) {
            NSLog(@"Succeeded!");
            [invalidPasswordLabel setHidden:TRUE];
        } else {
            NSLog(@"Failed!");
            [invalidPasswordLabel setHidden:FALSE];
        }
    }

    [authSpinner stopAnimation: self];
}

// Based on http://stackoverflow.com/questions/2635132/nstextfield-enter-to-trigger-action
- (BOOL)control:(NSControl *)control textView:(NSTextView *)fieldEditor doCommandBySelector:(SEL)commandSelector {
    BOOL retval = NO;
    if (commandSelector == @selector(insertNewline:)) {
        retval = YES; // causes Apple to NOT fire the default enter action
        // Do your special handling of the "enter" key here
        [self authenticateClicked:self];
        [passwordField abortEditing];
    }
    return retval;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
