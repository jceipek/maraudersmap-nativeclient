//
//  WifiScanner.h
//  Map
//
//  Created by Julian Ceipek on 5/27/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreWLAN/CoreWLAN.h>

@interface WifiScanner : NSObject {
    NSMutableArray *scanResults;
    CWInterface *currentInterface;
}

- (void) scan;

@end
