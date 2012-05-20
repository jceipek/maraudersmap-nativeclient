//
//  AppDelegate.m
//  Map
//
//  Created by Julian Ceipek on 5/19/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize preferencesWindow = _window;

- (void) awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    NSBundle *bundle = [NSBundle mainBundle];
    statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"demoIcon" ofType:@"png"]];
    statusImageHighlighted = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"demoIconWhite" ofType:@"png"]];
    
    
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusImageHighlighted];
    
    
    
    [statusItem setMenu:statusMenu];
    [statusItem setHighlightMode:YES];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)openMap:(id)sender {
    NSLog(@"Hi!");
}

@end
