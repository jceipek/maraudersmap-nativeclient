//
//  NetworkManager.m
//  Map
//
//  Created by Julian Ceipek on 6/14/12.
//  Copyright (c) 2012 ohack. All rights reserved.
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

-(void)getLocations {
    // TODO: Clean this up to reduce file access (static class? notification center? maybe better solution?)
    
    NSDictionary *theParams;
    NSPropertyListFormat format;
    
    NSError *directoryCreationerror;
    NSString *errorDesc;
    NSURL *rootUrl = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                            inDomain:NSUserDomainMask
                                                   appropriateForURL:nil
                                                              create:YES
                                                               error: &directoryCreationerror];
    if (directoryCreationerror != nil) {
        NSLog(@"Error getting 'Application Support' directory: %@", [directoryCreationerror description]);
    }
    
    NSURL *maraudersMapUrl = [rootUrl URLByAppendingPathComponent:@"MaraudersMap"];
    
    [[NSFileManager defaultManager] createDirectoryAtURL:maraudersMapUrl
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:&directoryCreationerror];
    if (directoryCreationerror != nil) {
        NSLog(@"Error creating 'MaraudersMap' directory: %@", directoryCreationerror);
    }
    
    NSURL *plistPath = [maraudersMapUrl URLByAppendingPathComponent: @"Secret.plist"];
    
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:[plistPath path]];
    theParams = (NSDictionary *)[NSPropertyListSerialization
                                 propertyListFromData:plistXML
                                 mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                 format:&format
                                 errorDescription:&errorDesc];
    if (!theParams) {
        NSLog(@"Path: %@", plistPath);
        NSLog(@"Error reading plist: %@, format: %ld", errorDesc, format);
    }
    
    NSDictionary *browserIDParams = [theParams objectForKey:@"BrowserID"];
    
    /* XXX: This should be enough, but there seems to be a server bug (may be due to bad parsing in the Python version)
     NSMutableArray *cookies;
     
     for (NSString *key in browserIDParams) {
     NSDictionary *currProps = [NSDictionary dictionaryWithObjectsAndKeys:
     @"map.fwol.in", NSHTTPCookieDomain,
     @"\\", NSHTTPCookiePath,  // IMPORTANT!
     key, NSHTTPCookieName,
     [browserIDParams objectForKey:key], NSHTTPCookieValue,
     nil];
     NSHTTPCookie *currCookie = [NSHTTPCookie cookieWithProperties:currProps];
     [cookies addObject:currCookie];
     }
     NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
     */
    
    
    // XXX Hack to get around server bug (the server and the old Python clients should be fixed to address this)
    NSMutableString *lumpedAttributes = [[NSMutableString alloc] initWithString:[browserIDParams objectForKey:@"session"]];
    [lumpedAttributes appendFormat:@"&_permanent=%@&assertion=%@&email=%@", [browserIDParams objectForKey:@"_permanent"], [browserIDParams objectForKey:@"assertion"], [browserIDParams objectForKey:@"email"]];
    NSString *browserid = [browserIDParams objectForKey:@"browserid"];
    
    NSLog(@"THE BID: %@", browserid);
        NSLog(@"THE Session: %@", lumpedAttributes);
    
    
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"map.fwol.in", NSHTTPCookieDomain,
                                @"\\", NSHTTPCookiePath,  // IMPORTANT!
                                @"browserid", NSHTTPCookieName,
                                browserid, NSHTTPCookieValue,
                                nil];
    NSHTTPCookie *browserIDCookie = [NSHTTPCookie cookieWithProperties:properties];
    
    properties = [NSDictionary dictionaryWithObjectsAndKeys:
                  @"map.fwol.in", NSHTTPCookieDomain,
                  @"\\", NSHTTPCookiePath,  // IMPORTANT!
                  @"session", NSHTTPCookieName,
                  lumpedAttributes, NSHTTPCookieValue,
                  nil];
    NSHTTPCookie *sessionCookie = [NSHTTPCookie cookieWithProperties:properties];
    
    NSArray *cookies = [NSArray arrayWithObjects: browserIDCookie, sessionCookie, nil];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    // XXX
    
    
    NSURLResponse *response;
    NSError *error;
    
    NSMutableString *requestString = [[NSMutableString alloc] initWithString:@"http://map.fwol.in/api/places/"];
    NSURL *requestURL = [[NSURL alloc] initWithString:requestString];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    [request setAllHTTPHeaderFields:headers];
    // XXX: This needs to be asynchronous
    NSData *result = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:&response
                                                       error:&error];
    
    
    if (!result) {
        //Display error message here
        NSLog(@"ERR: %@", error);
        NSLog(@"Error");
    } else {
        NSString* newStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"RESPONSE: %@", newStr);
    }
}

-(void)scan {
    NSString *urlWithQueryString = [@"https://themap" addQueryStringToUrlStringWithDictionary:[wifiScanner scan]];
    NSLog(@"%@", urlWithQueryString);
}

@end
