//
//  LocationViewController.m
//  Map
//
//  Created by Julian Ceipek on 5/30/12.
//  Copyright (c) 2012-2013 SLAC. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

@synthesize curLoc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        NSLog(@"Init Location View Controller");
        menuIsOpen = FALSE;
        shouldBeSpinning = FALSE;
        [spinner setUsesThreadedAnimation:YES];
    }
    return self;
}

- (void) setLocationText:(NSString *)text {
    [locationLabel setStringValue:text];
}

- (void) startSpinner {
    shouldBeSpinning = TRUE;
    [self makeSpinnerSpinIfItShould];
}

- (void) stopSpinner {
    shouldBeSpinning = FALSE;
    [self makeSpinnerSpinIfItShould];
}

- (void) makeSpinnerSpinIfItShould {
    if (menuIsOpen) {
        if (shouldBeSpinning) {
            NSLog(@"Start spinning");
            [spinner performSelector:@selector(startAnimation:) withObject:self afterDelay:0.1 inModes:[NSArray arrayWithObject:NSEventTrackingRunLoopMode]];
        } else {
            NSLog(@"Stop spinning");
            [spinner stopAnimation:self];
        }
    }
}

- (void)menuOpened {
    menuIsOpen = TRUE;
    [self makeSpinnerSpinIfItShould];
}

- (void)menuClosed {
    menuIsOpen = FALSE;
}

@end
