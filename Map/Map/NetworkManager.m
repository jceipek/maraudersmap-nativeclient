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
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *dataDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:TRUE] forKey:@"Success"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"authFinished" object:self userInfo:dataDict];
                                             NSString *sessionid = [JSON valueForKey:@"sessionid"];
                                             NSLog(@"Storing Sessionid: %@", sessionid);
        [[NSUserDefaults standardUserDefaults] setObject:sessionid forKey:@"sessionid"];
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Auth Fail\n");
        NSDictionary *dataDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:FALSE] forKey:@"Success"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"authFinished" object:self userInfo:dataDict];
        NSLog(@"Error! Unable to authenticate!%@\n", error);
        //TODO: Handle special cases like unauthorized, not being connected to the internet, etc...
    }];
    
    [[[NSOperationQueue alloc] init] addOperation:operation];
}

-(void)createUserIfNecessaryWithAlias: (NSString*)alias {
    NSLog(@"Create user if necessary");
    NSString *sessionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    NSLog(@"Getting sessionid: %@\n", sessionid);
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *usernamePath = [[NSString alloc] initWithFormat:@"/api/users/%@?sessionid=%@", username, sessionid];

    NSURLRequest *getUserRequest = [mapClient requestWithMethod:@"GET" path:usernamePath parameters:nil];
    
    AFJSONRequestOperation *getUserOperation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:getUserRequest
                                         success:^(NSURLRequest *getUserRequest, NSHTTPURLResponse *getUserResponse, id JSON) {
                                            NSLog(@"User: %@", [JSON valueForKeyPath:@"user"]);
                                         } failure:^(NSURLRequest *getUserRequest, NSHTTPURLResponse *getUserResponse, NSError *error, id JSON) {
                                             NSLog(@"No such user!\n");
                                             NSLog(@"URL: %@", usernamePath);

                                             NSLog(@"Error! %@\n", error);
                                             NSLog(@"Making new request...\n");
                                             
                                             NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                     alias, @"alias",
                                                                     nil];

                                             NSURLRequest *addUserRequest = [mapClient requestWithMethod:@"PUT" path:usernamePath parameters:params];
                                             
                                             NSLog(@"Actual request...\n");
                                             AFJSONRequestOperation *addUserOperation = [AFJSONRequestOperation
                                                                                         JSONRequestOperationWithRequest:addUserRequest
                                                                                         success:^(NSURLRequest *addUserRequest, NSHTTPURLResponse *addUserResponse, id JSON) {
                                                                                             NSLog(@"Succeeded in creation\n");
                                                                                             NSLog(@"User: %@", [JSON valueForKeyPath:@"user"]);
                                                                                         } failure:^(NSURLRequest *addUserRequest, NSHTTPURLResponse *addUserResponse, NSError *error, id JSON) {
                                                                                             NSLog(@"Unable to create user!\n");
                                                                                             NSLog(@"Error! %@\n", error);
                                                                                             
                                                                                             //TODO: Handle special cases like unauthorized, not being connected to the internet, etc...
                                                                                         }];
                                             
                                             [[[NSOperationQueue alloc] init] addOperation:addUserOperation];
                                             
                                             
                                             //TODO: Handle special cases like unauthorized, not being connected to the internet, etc...
                                         }];
    
    [[[NSOperationQueue alloc] init] addOperation:getUserOperation];
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
