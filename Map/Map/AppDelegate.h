//
//  AppDelegate.h
//  Map
//
//  Created by Julian Ceipek on 5/19/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusImageHighlighted;
}

- (IBAction)openMap:(id)sender;

@property (assign) IBOutlet NSPanel *preferencesWindow;

@end
