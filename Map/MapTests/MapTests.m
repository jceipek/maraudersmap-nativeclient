//
//  MapTests.m
//  MapTests
//
//  Created by Julian Ceipek on 5/19/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import "MapTests.h"

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
    STAssertEqualsWithAccuracy(0.0f, test, 0.000001f,
                               @"unevenArrayInterp is broken; 0.0f != %f",
                               test);
    test = unevenArrayInterp(0.5f, testArray, 3);
    STAssertEqualsWithAccuracy(100.0f, test, 0.000001f,
                               @"unevenArrayInterp is broken; 100.0f != %f",
                               test);
    test = unevenArrayInterp(1.0f, testArray, 3);
    STAssertEqualsWithAccuracy(1000.0f, test, 0.000001f,
                               @"unevenArrayInterp is broken; 1000.0f != %f",
                               test);
    test = unevenArrayInterp(0.6f, testArray, 3);
    STAssertEqualsWithAccuracy(850.0f, test, 0.000001f,
                               @"unevenArrayInterp is broken; 850.0f != %f",
                               test);
}

@end
