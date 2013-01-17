//
//  WifiScanner.m
//  Map
//
//  Created by Julian Ceipek on 5/27/12.
//  Copyright (c) 2012 ohack. All rights reserved.
//


#import "WifiScanner.h"

@implementation WifiScanner

- (id)init
{
    self = [super init];
    if (self) {

        }
    return self;
}

- (NSMutableSet*) scan {
    /* XXX: This method currently won't work with Sandboxing turned on */
    NSMutableArray *scanResults;
    CWInterface *currentInterface = [CWInterface interface];
    NSLog(@"currInterface: %@\n", currentInterface);
	NSError *err = nil;
	scanResults = [NSMutableSet setWithSet:[currentInterface scanForNetworksWithSSID:nil error:&err]];
    NSLog(@"Error: %@\n", err);
    NSLog(@"Getting Scan results\n");

    NSMutableSet *fakeSignals = [[NSMutableSet alloc] initWithObjects:
                                 [FakeScanResult fakeScanResultWithRSSI:(44.0-100.0) andBSSID:@"00:20:d8:2d:85:41"],
                                 [FakeScanResult fakeScanResultWithRSSI:(8.6-100.0) andBSSID:@"00:0b:0e:38:34:01"],
                                 [FakeScanResult fakeScanResultWithRSSI:(8.66666666667-100.0) andBSSID:@"00:0b:0e:38:34:01"],
                                 [FakeScanResult fakeScanResultWithRSSI:(17-100.0) andBSSID:@"00:0b:0e:38:34:00"],
                                 [FakeScanResult fakeScanResultWithRSSI:(30.6666666667-100.0) andBSSID:@"00:20:d8:2d:2c:c0"],
                                 [FakeScanResult fakeScanResultWithRSSI:(21.3333333333-100.0) andBSSID:@"00:20:d8:2d:2c:c1"],
                                 [FakeScanResult fakeScanResultWithRSSI:(35.6666666667-100.0) andBSSID:@"00:15:e8:e3:75:81"],
                                 [FakeScanResult fakeScanResultWithRSSI:(38.3333333333-100.0) andBSSID:@"00:15:e8:e3:75:80"],
                                 [FakeScanResult fakeScanResultWithRSSI:(53.3333333333-100.0) andBSSID:@"00:20:d8:2d:85:40"],
                                 [FakeScanResult fakeScanResultWithRSSI:(4.66666666667-100.0) andBSSID:@"00:20:d8:28:a8:02"],
                                 [FakeScanResult fakeScanResultWithRSSI:(12.6666666667-100.0) andBSSID:@"00:20:d8:2d:64:80"],
                                 [FakeScanResult fakeScanResultWithRSSI:(8-100.0) andBSSID:@"00:20:d8:2d:65:02"],
                                 [FakeScanResult fakeScanResultWithRSSI:(18-100.0) andBSSID:@"00:20:d8:2d:b3:c0"],
                                 [FakeScanResult fakeScanResultWithRSSI:(21-100.0) andBSSID:@"00:20:d8:2d:b6:80"],
                                 [FakeScanResult fakeScanResultWithRSSI:(8.66666666667-100.0) andBSSID:@"00:20:d8:2d:b6:81"], nil];
    
    /*NSDictionary *fakeSignals = [[NSDictionary alloc] initWithObjectsAndKeys:
    [[NSNumber alloc] initWithFloat: 44.0], @"nearest[00:20:d8:2d:85:41]",
    [[NSNumber alloc] initWithFloat: 8.6], @"nearest[00:0b:0e:38:34:01]",
    [[NSNumber alloc] initWithFloat: 8.66666666667], @"nearest[00:0b:0e:38:34:01]",
    [[NSNumber alloc] initWithFloat: 17], @"nearest[00:0b:0e:38:34:00]",
    [[NSNumber alloc] initWithFloat: 30.6666666667], @"nearest[00:20:d8:2d:2c:c0]",
    [[NSNumber alloc] initWithFloat: 21.3333333333], @"nearest[00:20:d8:2d:2c:c1]",
    [[NSNumber alloc] initWithFloat: 35.6666666667], @"nearest[00:15:e8:e3:75:81]",
    [[NSNumber alloc] initWithFloat: 38.3333333333], @"nearest[00:15:e8:e3:75:80]",
    [[NSNumber alloc] initWithFloat: 53.3333333333], @"nearest[00:20:d8:2d:85:40]",
    [[NSNumber alloc] initWithFloat: 4.66666666667], @"nearest[00:20:d8:28:a8:02]",
    [[NSNumber alloc] initWithFloat: 12.6666666667], @"nearest[00:20:d8:2d:64:80]",
    [[NSNumber alloc] initWithFloat: 8], @"nearest[00:20:d8:2d:65:02]",
    [[NSNumber alloc] initWithFloat: 18], @"nearest[00:20:d8:2d:b3:c0]",
    [[NSNumber alloc] initWithFloat: 21], @"nearest[00:20:d8:2d:b6:80]",
    [[NSNumber alloc] initWithFloat: 8.66666666667], @"nearest[00:20:d8:2d:b6:81]",
    nil];*/
    
    //return scanResults;
    return fakeSignals;
}

/* {'nearest[30:46:9A:86:35:FE]': 21.666666666666668, 'nearest[60:33:4B:E2:5E:2D]': 36.333333333333336, 'nearest[00:22:75:70:99:2A]': 13.333333333333334, 'nearest[00:12:17:D2:FD:2E]': 22.0, 'nearest[C8:60:00:94:83:08]': 18.0, 'limit': 1, 'nearest[94:44:52:FE:53:5A]': 13.0, 'nearest[10:BF:48:53:E2:D0]': 54.333333333333336, 'nearest[10:BF:48:53:E2:D4]': 43.0, 'nearest[60:33:4B:E2:5E:2E]': 21.666666666666668} */

@end
