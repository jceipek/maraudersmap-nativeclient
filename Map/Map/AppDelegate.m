//
//  AppDelegate.m
//  Map
//
//  Created by Julian Ceipek on 5/19/12.
//  Copyright (c) 2012-2013 SLAC. All rights reserved.
//

#import "AppDelegate.h"
#import <Foundation/Foundation.h>

#import "NSString+NSString_URLManipulation.h"


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
    
    

    StartAtLoginController *loginController = [[StartAtLoginController alloc] initWithIdentifier:@"com.olinapps.MapHelper"];
    NSNumber *launchOnStartup = [[NSUserDefaults standardUserDefaults] objectForKey:@"launchOnStartup"];
    if (launchOnStartup == NULL) {
        if (![loginController startAtLogin]) {
            loginController.startAtLogin = YES;
        }
    }

}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Initialize Application
    [mapMenu setAutoenablesItems: FALSE];
    [correctLocationItem setEnabled:FALSE];
    isOnline = TRUE;
    menuIsOpen = FALSE;
    [prefsPanel center];
    
    NSString *sessionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    if (sessionid != NULL) {
        [prefsPanel close];
    }
}

#pragma mark -- Direct Menu Options --

- (IBAction)openMap:(id)sender {
    NSLog(@"Open Map");
    NSString *sessionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    NSString *mapURLString;
    NSLog(@"Getting sessionid: %@\n", sessionid);
    if (sessionid != NULL) {
        mapURLString = [NSString stringWithFormat: @"http://map.olinapps.com/?sessionid=%@", sessionid];
    } else {
        mapURLString = @"http://map.olinapps.com";
    }
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:mapURLString]];
}

- (IBAction)manualRefresh:(id)sender {
    NSLog(@"Manual Refresh");
    [self initiateRefresh];
}

- (IBAction)toggleOnline:(id)sender {
    NSLog(@"Toggle Online");
    if (isOnline) {
        [toggleOnlineItem setTitle:NSLocalizedString(@"Go Online", nil)];
        [statusItem setImage:statusImageDisabled];
        // TODO: Actually go offline
        [refreshTimer invalidate];
        [correctLocationItem setEnabled:FALSE];
        [refreshLocationItem setEnabled:FALSE];
    } else {
        [toggleOnlineItem setTitle:NSLocalizedString(@"Go Offline", nil)];
        [statusItem setImage:statusImage];
        // TODO: Actually go online
        [self scheduleRefresh];
        [correctLocationItem setEnabled:TRUE];
        [refreshLocationItem setEnabled:TRUE];
    }
    isOnline = !isOnline;
}

- (IBAction)quit:(id)sender {
    // TODO: Cleanup
    [NSApp terminate:self];
}

# pragma mark -- Correcting Positions --

- (void)correctPositionWithMenuItem: (NSMenuItem *)item {
    NSDictionary *bindAndScanResults = [item representedObject];
    id bind = [bindAndScanResults objectForKey:@"bind"];
    [locationViewController setLocationText:[[bind valueForKey:@"place"] valueForKey:@"alias"]];
    NSDictionary *scanResultsBareFormat = [bindAndScanResults objectForKey:@"scanResultsBareFormat"];
    [[NetworkManager theNetworkManager] postNewBindFromSignals: scanResultsBareFormat andBind: bind];
    NSLog(@"Place from menu item: %@", [[bind valueForKey:@"place"] valueForKey:@"alias"]);
}

- (void)manuallyCorrectPositionWithMenuItem: (NSMenuItem *)item {
    NSDictionary *scanResultsBareFormat = [item representedObject];
    
    NSString *sessionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    NSLog(@"Getting sessionid: %@\n", sessionid);
    if (sessionid != NULL) {
        NSMutableString *encodedSignals = [[NSMutableString alloc] init];
        for (NSString *key in scanResultsBareFormat) {
            NSString *signalStringToAppend = [NSString stringWithFormat:@"signals[%@]=%@&", key, [scanResultsBareFormat valueForKey:key]];
            [encodedSignals appendString: [signalStringToAppend urlEncodeString]];
        }
        if ([encodedSignals length] > 0) {
            [encodedSignals deleteCharactersInRange:NSMakeRange([encodedSignals length]-1, 1)];
            NSString *path = [NSString stringWithFormat:@"http://map.olinapps.com/ui/index.html?action=place&sessionid=%@&%@", sessionid, encodedSignals];
            [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:path]];
        }
    }
}

# pragma mark -- Performing Location Refreshes --

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
        refreshTimer = [NSTimer timerWithTimeInterval:120.0 invocation:inv repeats:YES]; // Default is once every 2 minutes
        [[NSRunLoop currentRunLoop] addTimer:refreshTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)initiateRefresh {
    NSLog(@"init refresh");
    [locationViewController startSpinner];
    [self performSelectorInBackground:@selector(performRefresh) withObject:nil];
}

- (void)performRefresh {
    [[NetworkManager theNetworkManager] scan];
}

- (void)changeRefreshInterval: (NSNotification *)notificationData {
    [refreshTimer invalidate];
    [self scheduleRefresh];
}

- (void)scanComplete: (NSNotification *)notificationData {
    NSDictionary *theData = [notificationData userInfo];
    NSLog(@"Scan completed");
    if (theData != nil) {
        NSArray *nearestBinds = [theData objectForKey:@"nearestBinds"];
        NSDictionary *scanResultsBareFormat = [theData objectForKey:@"scanResultsBareFormat"];        
        if ([scanResultsBareFormat count] > 0) {

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
            if ([nearestBinds count] > 0) {
                NSMenuItem *divider = [NSMenuItem separatorItem];
                [submenu addItem:divider];
                NSMenuItem *manualCorrectionItem = [[NSMenuItem alloc] initWithTitle:@"I'm Somewhere Else!" action:@selector(manuallyCorrectPositionWithMenuItem:) keyEquivalent:@""];
                [manualCorrectionItem setRepresentedObject:scanResultsBareFormat];
                [submenu addItem:manualCorrectionItem];
                [mapMenu setSubmenu:submenu forItem:correctLocationItem];
                [correctLocationItem setTitle:@"Correct My Location"];
            } else {
                [correctLocationItem setTitle:@"I'm Somewhere Else!"];
                [correctLocationItem setAction:@selector(manuallyCorrectPositionWithMenuItem:)];
                [correctLocationItem setRepresentedObject:scanResultsBareFormat];
                [mapMenu setSubmenu:NULL forItem:correctLocationItem];
            }
            
            [correctLocationItem setEnabled:TRUE];
        } else {
            [mapMenu setSubmenu:NULL forItem:correctLocationItem];
            [correctLocationItem setTitle:@"Correct My Location"];
            [correctLocationItem setEnabled:FALSE];
        }

    }
}

# pragma mark -- NSMenuDelegate methods --

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
