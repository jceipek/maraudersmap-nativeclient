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
        
        libHandle = dlopen("/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Apple80211", RTLD_LAZY);
        apple80211Open = dlsym(libHandle, "Apple80211Open");
        apple80211Bind = dlsym(libHandle, "Apple80211BindToInterface");
        apple80211Close = dlsym(libHandle, "Apple80211Close");
        apple80211Scan = dlsym(libHandle, "Apple80211Scan");
        
        apple80211Associate = dlsym(libHandle, "Apple80211Associate");
        apple80211GetPower = dlsym(libHandle, "Apple80211GetPower");
        apple80211SetPower = dlsym(libHandle, "Apple80211SetPower");
        
        int op = apple80211Open(&airportHandle);
        NSLog(@"Open: %i", op);
        
        apple80211Bind(airportHandle, @"en0");
    }
    return self;
}

- (void) scan {
    NSArray *scan_networks = [[NSArray alloc] init];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"YES" forKey:@"SCAN_MERGE"];
    apple80211Scan(airportHandle, &scan_networks, (__bridge_retained void*) parameters);
    
    //apple80211Scan(airportHandle, &scan_result, (__bridge_retained void*) parameters);
    
    NSLog(@"Hai");
    NSLog(@"%@", [scan_networks objectAtIndex:0]);
    NSLog(@"Bye");
    
    // XXX: Doesn't work for some reason!
    apple80211Close(&airportHandle);
}

@end
