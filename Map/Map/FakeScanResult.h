//
//  FakeScanResult.h
//  Map
//
//  Created by Julian Ceipek on 1/16/13.
//  Copyright (c) 2013 Franklin W. Olin College of Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreWLAN/CoreWLAN.h>

@interface FakeScanResult : CWNetwork {
    NSInteger *fakeRSSIValue;
    NSString *fakeBSSID;
}

+ (CWNetwork *) fakeScanResultWithRSSI: (int)rssi andBSSID: (NSString *)bssid;
- (FakeScanResult *) initWithRSSI: (int)rssi andBSSID: (NSString *)bssid;

- (NSInteger*)rssiValue;
- (NSString*)bssid;

@end
