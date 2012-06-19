//
//  NetworkManager.m
//  Map
//
//  Created by Julian Ceipek on 6/14/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import "NetworkManager.h"

#import "NSString+NSString_URLManipulation.h"

@implementation NetworkManager

- (id)init
{
    self = [super init];
    if (self) {
        // Set up the wifi scanner (it will be used every scan interval or manually invoked)
        wifiScanner = [[WifiScanner alloc] init];
        
        // Set up the local authentication server
        httpServer = [[HTTPServer alloc] init];
        [httpServer setConnectionClass:[AuthHTTPConnection class]];
        
        // Serve files from the embedded Web folder for authentication
        NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
        [httpServer setDocumentRoot:webPath];
        NSLog(@"Path: %@",webPath);
        
        // Start the authentication server locally on a random free port
        NSError *error = nil;
        if(![httpServer start:&error])
        {
            NSLog(@"Error starting HTTP Server: %@", error);
        }

    }
    return self;
}

-(void)initiateAuthentication {
    // Visit the authentication URL of the map server, passing it the port of our local auth server
    NSMutableString *requestURL = [[NSMutableString alloc] initWithString:@"http://map.fwol.in/local/"];
    [requestURL appendFormat:@"?%@=%hu", @"port", [httpServer listeningPort]];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:requestURL]];
}

-(void)getPlaces {
    //http://map.fwol.in/api/places
    
}

/*-(void)getLocations {
 [NSHTTPCookie cookieWithProperties:NSDICT]
 // http://www.calaresu.com/2011/06/01/using-cookies-with-cocoa-nshttpcookie/
 
 
 // getting the stored cookies 
 NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]
 cookiesForURL:[NSURL URLWithString:@"http://www.calaresu.com"]];
 // Make a new header from the cookies 
 NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies]
 
 
 NSMutableURLRequest* req = [[NSMutableURLRequest alloc] init];
 
 [req setURL:[NSURL URLWithString:@"http://www.calaresu.com/cookie.php"]];
 
 [req setAllHTTPHeaderFields:headers];
 //Send the request 
 
 [NSURLConnection sendSynchronousRequest:req
 
 returningResponse:&response
 
 error:&error];
 }*/

-(void)scan {
    NSString *urlWithQueryString = [@"https://themap" addQueryStringToUrlStringWithDictionary:[wifiScanner scan]];
    NSLog(@"%@", urlWithQueryString);
}

@end
