//
//  AppDelegate.h
//  Map
//
//  Created by Julian Ceipek on 5/19/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "WifiScanner.h"
#import "LocationViewController.h"
//#import "LocViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu *statusMenu;
    IBOutlet NSMenuItem *locationIndicator;
    IBOutlet NSMenuItem *toggleOnlineItem;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusImageHighlighted;
    NSImage *statusImageDisabled;
    
    LocationViewController *locationViewController;
    NSView *locationView;
    
    BOOL isOnline;
}

//@property (assign) IBOutlet NSPanel *preferencesWindow;

- (IBAction)openMap:(id)sender;
- (IBAction)manualRefresh:(id)sender;
- (IBAction)correctLocation:(id)sender;
- (IBAction)toggleOnline:(id)sender;
- (IBAction)quit:(id)sender;

@end
