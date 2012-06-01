//
//  AppDelegate.m
//  Map
//
//  Created by Julian Ceipek on 5/19/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void) awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    NSBundle *bundle = [NSBundle mainBundle];
    statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"demoIcon" ofType:@"png"]];
    statusImageHighlighted = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"demoIconWhite" ofType:@"png"]];
    
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusImageHighlighted];
    
    [statusItem setMenu:statusMenu];
    [statusItem setHighlightMode:YES];
    
    
    locationViewController = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
    //[locationViewController loadView];

    NSLog(@"Assigned0");
    locationView = [locationViewController view];
    NSLog(@"Assigned1%@", locationView);
    [locationIndicator setView: locationView];
    NSLog(@"Assigned2");
    
    
    
    //TODO:
    //WifiScanner *scanner = [[WifiScanner alloc] init];
    //[scanner scan];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
}

- (IBAction)openMap:(id)sender {
    NSLog(@"Open Map");
    [[NSWorkspace sharedWorkspace] openFile:@"http://map.fwol.in"];
}

- (IBAction)manualRefresh:(id)sender {
    NSLog(@"Refresh");
}

- (IBAction)correctLocation:(id)sender {
    NSLog(@"Correct Location");
}

- (IBAction)toggleOnline:(id)sender {
    NSLog(@"Toggle Online");
}

- (IBAction)quit:(id)sender {
    // Cleanup
    [NSApp terminate:self];
}

@end
