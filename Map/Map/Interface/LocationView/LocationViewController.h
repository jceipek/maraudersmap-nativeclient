//
//  LocationViewController.h
//  Map
//
//  Created by Julian Ceipek on 5/30/12.
//  Copyright (c) 2012 ohack. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LocationViewController : NSViewController {
    IBOutlet NSProgressIndicator *spinner;
    IBOutlet NSTextField *locationLabel;
    BOOL shouldBeSpinning;
    BOOL menuIsOpen;
}

@property (nonatomic, strong) IBOutlet NSTextField *curLoc;

- (void) setLocationText:(NSString *)text;
- (void) makeSpinnerSpinIfItShould;
- (void)startSpinner;
- (void)stopSpinner;

- (void)menuOpened;
- (void)menuClosed;

@end
