//
//  WifiScanner.h
//  Map
//
//  Created by Julian Ceipek on 5/27/12.
//  Copyright (c) 2012 ohack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreWLAN/CoreWLAN.h>

#import "FakeScanResult.h"

@class HTTPServer;

@interface WifiScanner : NSObject {
}

- (NSMutableSet*) scan;

@end
