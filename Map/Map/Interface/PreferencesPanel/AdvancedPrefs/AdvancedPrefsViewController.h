//
//  AdvancedPrefsViewController.h
//  Map
//
//  Created by Julian Ceipek on 5/20/12.
//  Copyright (c) 2012-2013 ohack. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SliderHelper.h"
#import "StartAtLoginController.h"

@interface AdvancedPrefsViewController : NSViewController {

}

- (IBAction)checkboxChanged:(id)sender;
- (IBAction)sliderMoved:(id)sender;
- (void)sliderDoneMoving:(id)sender;

@property (nonatomic, strong) IBOutlet NSButton *launchOnStartupCheckbox;
@property (nonatomic, strong) IBOutlet NSTextField *frequencyIndicator;
@property (nonatomic, strong) IBOutlet NSSlider *updateFrequencySlider;

@end
