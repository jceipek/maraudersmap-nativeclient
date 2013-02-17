//
//  AppDelegate.m
//  MapHelper
//
//  Created by Julian Ceipek on 2/16/13.
//  Copyright (c) 2013 SLAC. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSLog(@"LAUNCHER!");
    NSString *appPath = [[[[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent] stringByDeletingLastPathComponent]  stringByDeletingLastPathComponent] stringByDeletingLastPathComponent];
    // get to the waaay top. Goes through LoginItems, Library, Contents, Applications
    [[NSWorkspace sharedWorkspace] launchApplication:appPath];
    [NSApp terminate:nil];
}

@end
