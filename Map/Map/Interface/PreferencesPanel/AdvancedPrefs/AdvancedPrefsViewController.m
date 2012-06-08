//
//  AdvancedPrefsViewController.m
//  Map
//
//  Created by Julian Ceipek on 5/20/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
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
    // do your expensive update here
    NSLog(@"Expensive operation");
}

- (void)dealloc {
    free(secondIntervals);
}

@end
