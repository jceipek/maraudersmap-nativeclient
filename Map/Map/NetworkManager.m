//
//  NetworkManager.m
//  Map
//
//  Created by Julian Ceipek on 6/14/12.
//  Copyright (c) 2012 ohack. All rights reserved.
//

#import "NetworkManager.h"

#import "NSString+NSString_URLManipulation.h"

static AFHTTPClient *authClient;
static AFHTTPClient *mapClient;
static WifiScanner *wifiScanner;

@implementation NetworkManager

+ (NetworkManager *)theNetworkManager
{
    static NetworkManager* networkManager = nil;
    @synchronized([NetworkManager class]) {
        if (networkManager == nil) {
            // Set up the wifi scanner (it will be used every scan interval or manually invoked)
            networkManager = [[NetworkManager alloc] init];
            wifiScanner = [[WifiScanner alloc] init];
            NSURL *authUrl = [NSURL URLWithString:@"https://ohack-fwolin.herokuapp.com"];
            NSURL *mapUrl = [NSURL URLWithString:@"http://map.olinapps.com/"];
            authClient = [[AFHTTPClient alloc] initWithBaseURL:authUrl];
            mapClient = [[AFHTTPClient alloc] initWithBaseURL:mapUrl];
        }
    }
    return networkManager;
}

-(void)authenticateWithUsername: (NSString*)username password: (NSString*)password {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"username",
                            password, @"password",
                            nil];
    
    NSURLRequest *request = [authClient requestWithMethod:@"POST" path:@"/api/exchangelogin" parameters:params];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dataDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:TRUE] forKey:@"Success"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"authFinished" object:self userInfo:dataDict];
        [[NSUserDefaults standardUserDefaults] setObject:operation.responseString forKey:@"sessionid"];
        NSLog(@"SessionID: %@", operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary *dataDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:FALSE] forKey:@"Success"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"authFinished" object:self userInfo:dataDict];
        NSLog(@"Error! Unable to authenticate!%@", operation.error);
        //TODO: Handle special cases like unauthorized, not being connected to the internet, etc...
    }];
    
    [[[NSOperationQueue alloc] init] addOperation:operation];
}

-(void)getPlaces {
    //http://map.fwol.in/api/places
}

-(void)getLocations {    

}

-(void)scan {
    NSString *urlWithQueryString = [@"https://themap" addQueryStringToUrlStringWithDictionary:[wifiScanner scan]];
    NSLog(@"%@", urlWithQueryString);
}

@end
