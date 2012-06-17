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
    
    // Normal image for the icon in the menu bar
    statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"demoIcon" ofType:@"png"]];
    
    // Image for the icon in the menu bar while you click on it
    statusImageHighlighted = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"demoIconWhite" ofType:@"png"]];
    
    // Image for the icon in the menu bar when you are offline
    statusImageDisabled = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"demoIconDisabled" ofType:@"png"]];
    
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusImageHighlighted];
    
    [statusItem setMenu:statusMenu];
    [statusItem setHighlightMode:YES];
    
    // Set up the view for the current location menu item (The progress spinner can only be added via a custom view)
    locationViewController = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
    locationView = [locationViewController view];
    [locationIndicator setView: locationView];

    // Set up the networkManager for tasks like wifi scanning, authentication, and API requests
    networkManager = [[NetworkManager alloc] init];
    [networkManager initiateAuthentication];
    
    [statusMenu setDelegate:self];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    isOnline = TRUE;
    
    [prefsPanel center];
}

// Open a web browser with the map's main address
- (IBAction)openMap:(id)sender {
    NSLog(@"Open Map");
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://map.fwol.in"]];
}

- (IBAction)manualRefresh:(id)sender {
    NSLog(@"Refresh");  
    [networkManager scan];
}

- (IBAction)correctLocation:(id)sender {
    NSLog(@"Correct Location");
}

- (IBAction)toggleOnline:(id)sender {
    NSLog(@"Toggle Online");
    if (isOnline) {
        [toggleOnlineItem setTitle:NSLocalizedString(@"Go Online", nil)];
        [statusItem setImage:statusImageDisabled];
        // TODO: Actually go offline
    } else {
        [toggleOnlineItem setTitle:NSLocalizedString(@"Go Offline", nil)];
        [statusItem setImage:statusImage];
        // TODO: Actually go online
    }
    isOnline = !isOnline;
}

- (IBAction)quit:(id)sender {
    // Cleanup
    [NSApp terminate:self];
}

- (void)menuWillOpen:(NSMenu *)menu {
    NSLog(@"Great!");
    [locationViewController startSpinner];
}

@end
