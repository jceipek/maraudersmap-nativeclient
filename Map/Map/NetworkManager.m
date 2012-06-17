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

-(void)scan {
    NSString *urlWithQueryString = [@"https://themap" addQueryStringToUrlStringWithDictionary:[wifiScanner scan]];
    NSLog(@"%@", urlWithQueryString);
}

@end
