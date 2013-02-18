//
//  MapTests.m
//  MapTests
//
//  Created by Julian Ceipek on 5/19/12.
//  Copyright (c) 2012-2013 SLAC. All rights reserved.
//

#import "MapTests.h"
#include <math.h>

@implementation MapTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

#import "SliderHelper.h"

- (void)testSliderHelper {     
    float test;
    float testArray[] = {0.0f, 100.0f, 1000.0f};
    
    test = unevenArrayInterp(0.0f, testArray, 3);
    STAssertEqualsWithAccuracy(test, 0.0f, 0.0001f,
                               @"unevenArrayInterp is broken");
    if (isnan(test)) {
        STFail(@"Division by zero in unevenArrayInterp");
    }
    
    test = unevenArrayInterp(0.5f, testArray, 3);
    STAssertEqualsWithAccuracy(100.0f, test, 0.0001f,
                               @"unevenArrayInterp is broken");
    if (isnan(test)) {
        STFail(@"Division by zero in unevenArrayInterp");
    }
    
    test = unevenArrayInterp(1.0f, testArray, 3);
    STAssertEqualsWithAccuracy(1000.0f, test, 0.0001f,
                               @"unevenArrayInterp is broken");
    if (isnan(test)) {
        STFail(@"Division by zero in unevenArrayInterp");
    }
    
    test = unevenArrayInterp(0.6f, testArray, 3);
    STAssertEqualsWithAccuracy(test, 280.0f, 0.0001f,
                               @"unevenArrayInterp is broken");
    if (isnan(test)) {
        STFail(@"Division by zero in unevenArrayInterp");
    }
    
    test = unevenArrayInterp(0.20f, testArray, 3);
    
    STAssertEqualsWithAccuracy(test, 40.0f, 0.0001f,
                               @"unevenArrayInterp is broken");
    if (isnan(test)) {
        STFail(@"Division by zero in unevenArrayInterp");
    }

}

@end
