//
//  AppDelegate.m
//  Map
//
//  Created by Julian Ceipek on 5/19/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize frequencyIndicator;
@synthesize updateFrequencySlider;

float *secondIntervals;

- (void) awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    NSBundle *bundle = [NSBundle mainBundle];
    statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"demoIcon" ofType:@"png"]];
    statusImageHighlighted = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"demoIconWhite" ofType:@"png"]];
    statusImageDisabled = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"demoIconDisabled" ofType:@"png"]];
    
    [statusItem setImage:statusImage];
    [statusItem setAlternateImage:statusImageHighlighted];
    
    [statusItem setMenu:statusMenu];
    [statusItem setHighlightMode:YES];
    
    
    locationViewController = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
    //[locationViewController loadView];
    
    locationView = [locationViewController view];
    [locationIndicator setView: locationView];
    
    //TODO:
    //WifiScanner *scanner = [[WifiScanner alloc] init];
    //[scanner scan];
    
    [statusMenu setDelegate:self];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    isOnline = TRUE;
    
     NSLog(@"THREAD: %@", [NSThread currentThread]);
    
    [prefsPanel center];
    
    // START
    struct timeUnitTuple intervals[] = {
        {10, "s"},
        {1, "m"},
        {5, "m"},
        {10, "m"},
        {30, "m"},
        {1, "hr"}};
    
    secondIntervals = secondsArrayFromTimeUnitTuples(intervals, 6);
    if(secondIntervals == NULL) {
        [NSException raise:@"Out of memory!" format:@"Not enough memory to allocate intervals array!"];
    }
    
    for (int i=0; i<6; i++) {
        NSLog(@"This %f", secondIntervals[i]);
    }
    
}

- (IBAction)openMap:(id)sender {
    NSLog(@"Open Map");
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://map.fwol.in"]];
}

- (IBAction)manualRefresh:(id)sender {
    NSLog(@"Refresh");
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

- (IBAction)sliderMoved:(id)sender
{
    
    NSLog(@"THREAD: %@", [NSThread currentThread]);
    for (int i=0; i<6; i++) {
        NSLog(@"This %f", secondIntervals[i]);
    }
    
    // update the value here
    
    float sliderValue = [updateFrequencySlider floatValue];
    NSLog(@"The slidervalue is %f", sliderValue);
    float value = unevenArrayInterp(sliderValue, secondIntervals, 6);
    NSLog(@"The value is %f", value);

    [frequencyIndicator setStringValue:[[NSString alloc] initWithFormat:@"%f", value]];
    
    NSLog(@"InExpensive operation");
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(sliderDoneMoving:) object:sender];
    [self performSelector:@selector(sliderDoneMoving:)
               withObject:sender afterDelay:0];
}

- (void)sliderDoneMoving:(id)sender
{
    // do your expensive update here
    NSLog(@"Expensive operation");
}

- (void)dealloc {
    free(secondIntervals);
}

@end
