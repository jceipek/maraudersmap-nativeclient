//
//  AppDelegate.m
//  Map
//
//  Created by Julian Ceipek on 5/19/12.
//  Copyright (c) 2012 ohack. All rights reserved.
//

#import "AppDelegate.h"

#import <Foundation/Foundation.h>
#import <CoreWLAN/CoreWLAN.h>

@implementation AppDelegate

- (void) awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength];
    NSBundle *bundle = [NSBundle mainBundle];
    
    // Normal image for the icon in the menu bar
    statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"demoIcon" ofType:@"png"]];
    
    // Image for the icon in the menu bar while you click on it
    statusImageHighlighted = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"demoIconWhite" ofType:@"png"]];
    
    // Image for the icon in the menu bar when you are offline
    statusImageDisabled = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"demoIconDisabled" ofType:@"png"]];
    
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusImageHighlighted];
    
    [statusItem setMenu:mapMenu];
    [statusItem setHighlightMode:YES];
    
    // Set up the view for the current location menu item (The progress spinner can only be added via a custom view)
    locationViewController = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
    locationView = [locationViewController view];
    [locationIndicator setView: locationView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scanComplete:)
                                                 name:@"scanComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeRefreshInterval:)
                                                 name:@"changedRefreshInterval"
                                               object:nil];
    [self scheduleRefresh];
    
    [mapMenu setDelegate:self];
}

- (void)scheduleRefresh {
    NSLog(@"Refresh Scheduled");

    SEL sel = @selector(initiateRefresh);
    NSInvocation* inv = [NSInvocation invocationWithMethodSignature:
                         [self methodSignatureForSelector:sel]];
    [inv setTarget:self];
    [inv setSelector:sel];
    
    NSNumber *refreshInterval = [[NSUserDefaults standardUserDefaults] objectForKey:@"refreshInterval"];
    if (refreshInterval != NULL) {
        refreshTimer = [NSTimer timerWithTimeInterval:[refreshInterval floatValue] invocation:inv repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:refreshTimer forMode:NSRunLoopCommonModes];
    } else {
        refreshTimer = [NSTimer timerWithTimeInterval:10.0 invocation:inv repeats:YES]; // Default is once every 10 seconds
        [[NSRunLoop currentRunLoop] addTimer:refreshTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    isOnline = TRUE;
    menuIsOpen = FALSE;
    [prefsPanel center];
}

// Open a web browser with the map's main address
- (IBAction)openMap:(id)sender {
    NSLog(@"Open Map");
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://map.olinapps.com/"]];
}

// Initiate a location scan manually
- (IBAction)manualRefresh:(id)sender {
    NSLog(@"Manual Refresh");
    [self initiateRefresh];
}

- (void)initiateRefresh {
    NSLog(@"init refresh");
    [locationViewController startSpinner];
    [self performSelectorInBackground:@selector(performRefresh) withObject:nil];
}

- (void)performRefresh {
    [[NetworkManager theNetworkManager] scan];
}

- (void)scanComplete: (NSNotification *)notificationData {
    NSDictionary *theData = [notificationData userInfo];
    NSLog(@"Scan completed");
    if (theData != nil) {
        NSArray *nearestBinds = [theData objectForKey:@"nearestBinds"];
        NSDictionary *scanResultsBareFormat = [theData objectForKey:@"scanResultsBareFormat"];
        if ([nearestBinds count] > 0) {
            id firstBind = [nearestBinds objectAtIndex:0];
            [locationViewController setLocationText:[[firstBind valueForKey:@"place"] valueForKey:@"alias"]];
            [[NetworkManager theNetworkManager] postToPositionTheBindWithId:[firstBind valueForKey:@"id"]];
        } else {
            [locationViewController setLocationText:@"Unknown Location"];
        }
        [locationViewController stopSpinner];
        NSMenu *submenu = [[NSMenu alloc] init];
        for (id bind in nearestBinds) {
            NSLog(@"Place: %@", (NSString *)[bind valueForKey:@"place"]);
            NSMenuItem *correctPositionMenuItem = [[NSMenuItem alloc] initWithTitle:[[bind valueForKey:@"place"] valueForKey:@"alias"] action:@selector(correctPositionWithMenuItem:) keyEquivalent:@""];
            NSDictionary *bindAndScanResults = [NSDictionary dictionaryWithObjectsAndKeys:
                                             scanResultsBareFormat, @"scanResultsBareFormat",
                                             bind, @"bind",
                                             nil];
            [correctPositionMenuItem setRepresentedObject:bindAndScanResults];
            [submenu addItem:correctPositionMenuItem];
        }
        [mapMenu setSubmenu:submenu forItem:correctLocationItem];
    }
}

- (void)correctPositionWithMenuItem: (NSMenuItem *)item {
    NSDictionary *bindAndScanResults = [item representedObject];
    id bind = [bindAndScanResults objectForKey:@"bind"];
    [locationViewController setLocationText:[[bind valueForKey:@"place"] valueForKey:@"alias"]];
    NSDictionary *scanResultsBareFormat = [bindAndScanResults objectForKey:@"scanResultsBareFormat"];
    [[NetworkManager theNetworkManager] postNewBindFromSignals: scanResultsBareFormat andBind: bind];
    NSLog(@"Place from menu item: %@", [[bind valueForKey:@"place"] valueForKey:@"alias"]);
}

- (void)changeRefreshInterval: (NSNotification *)notificationData {
    [refreshTimer invalidate];
    [self scheduleRefresh];
}

- (IBAction)correctLocation:(id)sender {
    NSLog(@"Correct Location");
    //[[NetworkManager theNetworkManager] getLocations];
    // TODO: Implement
}

- (IBAction)toggleOnline:(id)sender {
    NSLog(@"Toggle Online");
    if (isOnline) {
        [toggleOnlineItem setTitle:NSLocalizedString(@"Go Online", nil)];
        [statusItem setImage:statusImageDisabled];
        // TODO: Actually go offline
        [refreshTimer invalidate];
    } else {
        [toggleOnlineItem setTitle:NSLocalizedString(@"Go Offline", nil)];
        [statusItem setImage:statusImage];
        // TODO: Actually go online
        [self scheduleRefresh];
    }
    isOnline = !isOnline;
}

- (IBAction)quit:(id)sender {
    // TODO: Cleanup
    [NSApp terminate:self];
}

- (void)menuWillOpen:(NSMenu *)menu {
    NSLog(@"Menu about to open!");
    menuIsOpen = TRUE;
    [locationViewController menuOpened];
}

- (void)menuDidClose:(NSMenu *)menu {
    NSLog(@"Menu closed!");
    menuIsOpen = FALSE;
    [locationViewController menuClosed];
}

@end
