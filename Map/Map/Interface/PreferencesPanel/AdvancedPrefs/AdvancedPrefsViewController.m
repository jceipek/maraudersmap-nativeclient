//
//  AdvancedPrefsViewController.m
//  Map
//
//  Created by Julian Ceipek on 5/20/12.
//  Copyright (c) 2012 ohack. All rights reserved.
//

#import "AdvancedPrefsViewController.h"

@implementation AdvancedPrefsViewController

float *secondIntervals;

@synthesize frequencyIndicator;
@synthesize updateFrequencySlider;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    //[updateFrequencySlider setAction:@selector(sliderMoved:)];
    
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
    
    return self;
}

- (void)loadView {
    [super loadView];
    // Restore slider position if it was saved previously
    NSNumber *refreshSliderPos = [[NSUserDefaults standardUserDefaults] objectForKey:@"refreshSliderPos"];
    if (refreshSliderPos != NULL) {
        [updateFrequencySlider setFloatValue:[refreshSliderPos floatValue]];
    }
}

- (IBAction)sliderMoved:(id)sender
{
    // update the value here
    float value = unevenArrayInterp([updateFrequencySlider floatValue], secondIntervals, 6);
    
    char longForm[50];
    
    [frequencyIndicator setStringValue:[[NSString alloc] initWithFormat:@"%s", timeUnitTupleLongForm(timeUnitTupleFromSeconds(value), longForm)]];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(sliderDoneMoving:) object:sender];
    [self performSelector:@selector(sliderDoneMoving:)
               withObject:sender afterDelay:0];
}

- (void)sliderDoneMoving:(id)sender
{
    [frequencyIndicator setStringValue:@""];
    NSLog(@"Expensive operation");
    [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithFloat:[updateFrequencySlider floatValue]] forKey:@"refreshSliderPos"];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSNumber alloc] initWithFloat:unevenArrayInterp([updateFrequencySlider floatValue], secondIntervals, 6)] forKey:@"refreshInterval"];
    //NSDictionary *dataDict = [NSDictionary dictionaryWithObject:nearestBinds forKey:@"nearestBinds"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changedRefreshInterval" object:self userInfo:nil];
}

- (void)dealloc {
    free(secondIntervals);
}

@end
