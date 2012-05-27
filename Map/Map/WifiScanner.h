//
//  WifiScanner.h
//  Map
//
//  Created by Julian Ceipek on 5/27/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <dlfcn.h>

@interface WifiScanner : NSObject {
    void *libHandle;
    void *airportHandle;    
    int (*apple80211Open)(void *);
    int (*apple80211Bind)(void *, NSString *);
    int (*apple80211Close)(void *);
    int (*apple80211Associate)(void *, NSDictionary*, NSString*);
    int (*apple80211Scan)(void *, NSArray **, void *);
	int (*apple80211GetPower)(void *, char *);
	int (*apple80211SetPower)(void*, char*);
}

- (void) scan;

@end
