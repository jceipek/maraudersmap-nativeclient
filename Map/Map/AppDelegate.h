//
//  AppDelegate.h
//  Map
//
//  Created by Julian Ceipek on 5/19/12.
//  Copyright (c) 2012-2013 SLAC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreWLAN/CoreWLAN.h>
#import <ServiceManagement/ServiceManagement.h>

#import "StartAtLoginController.h"
#import "LocationViewController.h"
#import "PreferencesPanel.h"
#import "NetworkManager.h"

/**
 `AppDelegate` is the central hub of the Marauder's Map OS X Client.
 */

@interface AppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate> {
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusImageHighlighted;
    NSImage *statusImageDisabled;
    
    IBOutlet NSMenu *mapMenu;
    IBOutlet NSMenuItem *locationIndicator;
    LocationViewController *locationViewController;
    IBOutlet NSMenuItem *toggleOnlineItem;
    IBOutlet NSMenuItem *correctLocationItem;
    IBOutlet NSMenuItem *refreshLocationItem;
    
    IBOutlet PreferencesPanel *prefsPanel;
    
    NSView *locationView;
    NSTimer *refreshTimer;
    
    BOOL menuIsOpen;
    BOOL isOnline;
}


///---------------------------------------------
/// @name Direct Menu Options
///---------------------------------------------

/**
  Launch the Marauder's Map website in the default webbrowser
 */
- (IBAction)openMap:(id)sender;

/**
 Manually initiate a network scan to refresh your location.
 */
- (IBAction)manualRefresh:(id)sender;

/**
 Toggle whether the application is online (will scan the network and update your location)
 */
- (IBAction)toggleOnline:(id)sender;

/**
 Close the Marauder's Map application
 */
- (IBAction)quit:(id)sender;


///---------------------------------------------
/// @name Correcting Positions
///---------------------------------------------

/**
 Creates and initializes an `AFHTTPClient` object with the specified base URL.
 
 @param url The base URL for the HTTP client. This argument must not be `nil`.
 
 @return The newly-initialized HTTP client
 */
- (void)correctPositionWithMenuItem: (NSMenuItem *)item;

/**
 Creates and initializes an `AFHTTPClient` object with the specified base URL.
 
 @param url The base URL for the HTTP client. This argument must not be `nil`.
 
 @return The newly-initialized HTTP client
 */
- (void)manuallyCorrectPositionWithMenuItem: (NSMenuItem *)item;


///---------------------------------------------
/// @name Performing Location Refreshes
///---------------------------------------------

/**
 Schedule a location refresh with the currently set `NSUserDefaults` `refreshInterval`
 */
- (void)scheduleRefresh;

/**
 Perform a location refresh in the background.
 */
- (void)initiateRefresh;

/**
 Directly perform a blocking location refresh.
 */
- (void)performRefresh;

/**
 Change the interval at which refreshes occur.
 
 @param notificationData Set by the notification system when the slider is used. The contents are ignored.
 */
- (void)changeRefreshInterval: (NSNotification *)notificationData;

/**
 Called by the notification system when the latest location refresh has been completed.
 
 When this happens, the menu is populated with options to correct your location based on the nature of the scan results and
   the `nearestBinds` reported by the server.
 
 @param notificationData Set by the notification system when the slider is used. The values under the keys
   `nearestBinds` and `scanResultsBareFormat` are used.
 
 */
- (void)scanComplete: (NSNotification *)notificationData;

@end
