//
//  AppDelegate.h
//  Map
//
//  Created by Julian Ceipek on 5/19/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "WifiScanner.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusImageHighlighted;
}

//@property (assign) IBOutlet NSPanel *preferencesWindow;

- (IBAction)openMap:(id)sender;
- (IBAction)manualRefresh:(id)sender;
- (IBAction)correctLocation:(id)sender;
- (IBAction)toggleOnline:(id)sender;
- (IBAction)quit:(id)sender;

@end
