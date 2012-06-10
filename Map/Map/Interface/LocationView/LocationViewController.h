//
//  LocationViewController.h
//  Map
//
//  Created by Julian Ceipek on 5/30/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LocationViewController : NSViewController {
    IBOutlet NSProgressIndicator *spinner;
    
}

@property (nonatomic, strong) IBOutlet NSTextField *curLoc;

- (void)startSpinner;
- (void)stopSpinner;

@end
