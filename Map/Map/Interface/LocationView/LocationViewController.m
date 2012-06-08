//
//  LocationViewController.m
//  Map
//
//  Created by Julian Ceipek on 5/30/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
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
        [spinner setUsesThreadedAnimation:YES];
    }
    return self;
}

- (void) startSpinner {
    [spinner performSelector:@selector(startAnimation:) withObject:self afterDelay:0.0 inModes:[NSArray arrayWithObject:NSEventTrackingRunLoopMode]];
}

- (void) stopSpinner {
    [spinner stopAnimation:self];
}

@end
