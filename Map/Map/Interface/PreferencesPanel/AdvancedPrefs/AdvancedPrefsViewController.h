//
//  AdvancedPrefsViewController.h
//  Map
//
//  Created by Julian Ceipek on 5/20/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SliderHelper.h"

@interface AdvancedPrefsViewController : NSViewController {

}

- (IBAction)sliderMoved:(id)sender;
- (void)sliderDoneMoving:(id)sender;

@property IBOutlet NSTextField *frequencyIndicator;
@property IBOutlet NSSlider *updateFrequencySlider;

@end
