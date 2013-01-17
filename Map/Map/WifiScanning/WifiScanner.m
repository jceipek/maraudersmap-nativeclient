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
    NSMutableSet *scanResults;
    CWInterface *currentInterface = [CWInterface interface];
    NSLog(@"currInterface: %@\n", currentInterface);
	NSError *err = nil;
	scanResults = [NSMutableSet setWithSet:[currentInterface scanForNetworksWithSSID:nil error:&err]];
    NSLog(@"Error: %@\n", err);
    NSLog(@"Getting Scan results\n");

    return scanResults;
    
    /* // FOR TESTING //
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
     return fakeSignals;
     */
}

@end
