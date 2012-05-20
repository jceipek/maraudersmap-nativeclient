//
//  PreferencesPanel.m
//  Map
//
//  Created by Julian Ceipek on 5/19/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import "PreferencesPanel.h"

@implementation PreferencesPanel

- (BOOL)windowShouldClose:(id)sender{
    [self orderOut:self]; // Hide window instead of closing it
    return NO;
}

@end
