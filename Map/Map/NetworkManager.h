//
//  NetworkManager.h
//  Map
//
//  Created by Julian Ceipek on 6/14/12.
//  Copyright (c) 2012 Franklin W. Olin College of Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONKit.h"
#import "HTTPServer.h"

#import "AuthHTTPConnection.h"
#import "WifiScanner.h"

@interface NetworkManager : NSObject {

    HTTPServer *httpServer;
    WifiScanner *wifiScanner;
    
}


-(void)initiateAuthentication;
-(void)getLocations;
-(void)scan;

@end
