//
//  WifiScanner.h
//  Map
//
//  Created by Julian Ceipek on 5/27/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreWLAN/CoreWLAN.h>

@class HTTPServer;

@interface WifiScanner : NSObject {
    NSMutableArray *scanResults;
    CWInterface *currentInterface;
    HTTPServer *httpServer;
}

+(NSString*)urlEscapeString:(NSString *)unencodedString;
+(NSString*)addQueryStringToUrlString:(NSString *)urlString withDictionary:(NSDictionary *)dictionary;


- (void) scan;
- (void) info;

@end
