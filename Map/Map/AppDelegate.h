//
//  AppDelegate.h
//  Map
//
//  Created by Julian Ceipek on 5/19/12.
//  Copyright (c) 2012 ohack. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreWLAN/CoreWLAN.h>

#import "LocationViewController.h"
#import "PreferencesPanel.h"
#import "NetworkManager.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate> {
    IBOutlet NSMenu *mapMenu;
    IBOutlet NSMenuItem *locationIndicator;
    IBOutlet NSMenuItem *toggleOnlineItem;
    IBOutlet PreferencesPanel *prefsPanel;
    
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusImageHighlighted;
    NSImage *statusImageDisabled;

    LocationViewController *locationViewController;
    NSView *locationView;
    
    BOOL isOnline;
    
    BOOL menuIsOpen;
}

- (IBAction)openMap:(id)sender;
- (IBAction)manualRefresh:(id)sender;
- (void)scanComplete: (NSNotification *)notificationData;
- (void)initiateRefresh;
- (void)performRefresh;
- (IBAction)correctLocation:(id)sender;
- (IBAction)toggleOnline:(id)sender;
- (IBAction)quit:(id)sender;

- (void)scheduleRefresh;

@end
