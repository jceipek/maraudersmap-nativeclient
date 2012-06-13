//
//  WifiScanner.m
//  Map
//
//  Created by Julian Ceipek on 5/27/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import "JSONKit.h"
#import "HTTPServer.h"

#import "AuthHTTPConnection.h"
#import "WifiScanner.h"

#import "DDLog.h"
#import "DDTTYLogger.h"

@implementation WifiScanner

- (id)init
{
    self = [super init];
    if (self) {
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        currentInterface = [CWInterface interface];
        httpServer = [[HTTPServer alloc] init];
        [httpServer setConnectionClass:[AuthHTTPConnection class]];
        
        // Tell the server to broadcast its presence via Bonjour.
        // This allows browsers such as Safari to automatically discover our service.
        [httpServer setType:@"_http._tcp."];
        
        // Serve files from our embedded Web folder
        NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
        [httpServer setDocumentRoot:webPath];
        NSLog(@"Path: %@",webPath);
        
        NSError *error = nil;
        if(![httpServer start:&error])
        {
            NSLog(@"Error starting HTTP Server: %@", error);
        }
    }
    return self;
}

// From http://stackoverflow.com/questions/718429/creating-url-query-parameters-from-nsdictionary-objects-in-objectivec
+(NSString*)urlEscapeString:(NSString *)unencodedString 
{
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, NULL,kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return s;
}


+(NSString*)addQueryStringToUrlString:(NSString *)urlString withDictionary:(NSDictionary *)dictionary
{
    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:urlString];
    
    for (id key in dictionary) {
        NSString *keyString = [key description];
        NSString *valueString = [[dictionary objectForKey:key] description];
        
        if ([urlWithQuerystring rangeOfString:@"?"].location == NSNotFound) {
            [urlWithQuerystring appendFormat:@"?%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        } else {
            [urlWithQuerystring appendFormat:@"&%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        }
    }
    return urlWithQuerystring;
}

- (void) scan {
    NSMutableDictionary *signalsDict = [[NSMutableDictionary alloc] init];
	NSError *err = nil;
	scanResults = [NSMutableSet setWithSet:[currentInterface scanForNetworksWithSSID:nil error:&err]];
    for (CWNetwork *network in scanResults) {
        NSString *key = [[NSString alloc] initWithFormat: @"nearest[%@]", [network bssid]];
        
        /* Most platforms (nm-tool doesn't for some reason) return the Received Signal Strength 
         Indication (RSSI) in dBm units (http://en.wikipedia.org/wiki/DBm) Adding 100 is a convenient
         way to indicate, for example, that -85 is weaker than -10 */
        
        NSNumber *value = [[NSNumber alloc] initWithFloat: (float)(100.0f+[network rssiValue])];
        [signalsDict setObject: value forKey: key];
    }
    
    NSString *urlWithQueryString = [WifiScanner addQueryStringToUrlString:@"https://themap" withDictionary:signalsDict];
    
    NSLog(@"%@", urlWithQueryString);
}

/* {'nearest[30:46:9A:86:35:FE]': 21.666666666666668, 'nearest[60:33:4B:E2:5E:2D]': 36.333333333333336, 'nearest[00:22:75:70:99:2A]': 13.333333333333334, 'nearest[00:12:17:D2:FD:2E]': 22.0, 'nearest[C8:60:00:94:83:08]': 18.0, 'limit': 1, 'nearest[94:44:52:FE:53:5A]': 13.0, 'nearest[10:BF:48:53:E2:D0]': 54.333333333333336, 'nearest[10:BF:48:53:E2:D4]': 43.0, 'nearest[60:33:4B:E2:5E:2E]': 21.666666666666668} */

@end
