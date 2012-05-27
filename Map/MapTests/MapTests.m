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
    float val = linearInterp(0.0f, 100.0f, 4.0f, 0.0f, 500.0f);
    STAssertEqualsWithAccuracy(4.0f, val, 0.000001f,
                               @"bad amount; 4.0f != %f",
                               val);
}



@end
