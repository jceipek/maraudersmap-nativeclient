//
//  FakeScanResult.m
//  Map
//
//  Created by Julian Ceipek on 1/16/13.
//  Copyright (c) 2013 Franklin W. Olin College of Engineering. All rights reserved.
//

#import "FakeScanResult.h"

@implementation FakeScanResult

+ (CWNetwork *) fakeScanResultWithRSSI: (int)rssi andBSSID: (NSString *)bssid {
    return [[FakeScanResult alloc] initWithRSSI:rssi andBSSID:bssid];
}

- (FakeScanResult *) initWithRSSI: (int)rssi andBSSID: (NSString *)bssid {
    fakeRSSIValue = (NSInteger *)rssi;
    fakeBSSID = bssid;
    return self;
}

- (NSInteger *)rssiValue {
    return fakeRSSIValue;
}

- (NSString *)bssid {
    return fakeBSSID;
}

@end
