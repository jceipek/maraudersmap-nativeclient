//
//  WifiScanner.m
//  Map
//
//  Created by Julian Ceipek on 5/27/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import "WifiScanner.h"

@implementation WifiScanner

- (id)init
{
    self = [super init];
    if (self) {
        currentInterface = [CWInterface interface];
    }
    return self;
}

- (void) scan {
	NSError *err = nil;
	scanResults = [NSMutableSet setWithSet:[currentInterface scanForNetworksWithSSID:nil error:&err]];
    for (CWNetwork *network in scanResults) {
        NSLog(@"%@", [network bssid]);
        /* Most platforms (nm-tool doesn't for some reason) return the Received Signal Strength Indication (RSSI) in dBm units (http://en.wikipedia.org/wiki/DBm) The following is a convenient way to indicate, for example, that -85 is weaker than -10 */
        NSLog(@"%ld", 100+[network rssiValue]);
    }
}

@end
