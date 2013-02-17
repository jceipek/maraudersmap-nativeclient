//
//  NetworkManager.m
//  Map
//
//  Created by Julian Ceipek on 6/14/12.
//  Copyright (c) 2012-2013 ohack. All rights reserved.
//

#import "NetworkManager.h"

#import "NSString+NSString_URLManipulation.h"

static AFHTTPClient *authClient;
static AFHTTPClient *mapClient;
static AFHTTPClient *directoryClient;
static WifiScanner *wifiScanner;

typedef void (^deferredMethodWithString)(NSString *);

@implementation NetworkManager

+ (NetworkManager *)theNetworkManager
{
    static NetworkManager* networkManager = nil;
    @synchronized([NetworkManager class]) {
        if (networkManager == nil) {
            // Set up the wifi scanner (it will be used every scan interval or manually invoked)
            networkManager = [[NetworkManager alloc] init];
            wifiScanner = [[WifiScanner alloc] init];
            NSURL *authUrl = [NSURL URLWithString:@"https://olinapps.herokuapp.com"];
            NSURL *mapUrl = [NSURL URLWithString:@"http://map.olinapps.com/"];
            NSURL *directoryUrl = [NSURL URLWithString:@"http://directory.olinapps.com/"];
            authClient = [[AFHTTPClient alloc] initWithBaseURL:authUrl];
            mapClient = [[AFHTTPClient alloc] initWithBaseURL:mapUrl];
            directoryClient = [[AFHTTPClient alloc] initWithBaseURL:directoryUrl];
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
                                             NSString *sessionid = [JSON valueForKey:@"sessionid"];
                                             NSString *userid = [[JSON valueForKey:@"user"] valueForKey:@"id"];
                                             NSLog(@"Storing Sessionid: %@", sessionid);
                                             [[NSUserDefaults standardUserDefaults] setObject:sessionid forKey:@"sessionid"];
                                             [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
                                             [[NSUserDefaults standardUserDefaults] setObject:userid forKey:@"userid"];
                                             
                                             NSDictionary *dataDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:TRUE] forKey:@"Success"];
                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"authFinished" object:self userInfo:dataDict];
                                             
                                         } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                             NSLog(@"Auth Fail\n");
                                             NSDictionary *dataDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:FALSE] forKey:@"Success"];
                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"authFinished" object:self userInfo:dataDict];
                                             NSLog(@"Error! Unable to authenticate!%@\n", error);
                                             //TODO: Handle special cases like unauthorized, not being connected to the internet, etc...
                                         }];
    
    [[[NSOperationQueue alloc] init] addOperation:operation];
}

-(void)createUser {
    NSString *sessionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    NSLog(@"Getting sessionid: %@\n", sessionid);
    if (sessionid != NULL) {
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSLog(@"Getting userid: %@\n", userid);
        NSString *usernamePath = [[NSString alloc] initWithFormat:@"/api/users/%@/?sessionid=%@", userid, sessionid];
        
        
        NSString *mePath = [[NSString alloc] initWithFormat:@"/api/me?sessionid=%@", sessionid];
        NSURLRequest *getMeRequest = [directoryClient requestWithMethod:@"GET" path:mePath parameters:nil];
        

        AFJSONRequestOperation *getMeOperation = [AFJSONRequestOperation
                                                    JSONRequestOperationWithRequest:getMeRequest
                                                    success:^(NSURLRequest *getMeRequest, NSHTTPURLResponse *getMeResponse, id JSON) {
                                                        
                                                        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                                [JSON valueForKey:@"name"], @"alias",
                                                                                [JSON valueForKey:@"email"], @"email",
                                                                                nil];
                                                        
                                                        NSLog(@"%@",usernamePath);
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
                                                        
                                                    } failure:^(NSURLRequest *addUserRequest, NSHTTPURLResponse *addUserResponse, NSError *error, id JSON) {
                                                        NSLog(@"Unable to fetch info about me!\n");
                                                        NSLog(@"Error! %@\n", error);
                                                        
                                                        //TODO: Handle special cases like unauthorized, not being connected to the internet, etc...
                                                    }];
        
        [[[NSOperationQueue alloc] init] addOperation:getMeOperation];
    }
}

-(void)getPlaces {
    NSString *sessionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    NSLog(@"Getting sessionid: %@\n", sessionid);
    
    if (sessionid != NULL) {
        NSString *pathWithQueryString = [[NSString alloc] initWithFormat: @"/api/places?sessionid=%@", sessionid];
        NSLog(@"%@", pathWithQueryString);
        
        NSURLRequest *request = [mapClient requestWithMethod:@"GET" path:pathWithQueryString parameters:nil];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                             JSONRequestOperationWithRequest:request
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                 NSString *places = [JSON valueForKey:@"places"];
                                                 NSLog(@"Places: %@\n", places);
                                             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                 NSLog(@"Get places fail: %@\n", error);
                                                 //TODO: Handle special cases like unauthorized, not being connected to the internet, etc...
                                             }];
        
        [[[NSOperationQueue alloc] init] addOperation:operation];
    }
}

-(void)postToPositionTheBindWithId: (NSString*)theId {
    NSLog(@"POSTING ID: %@", theId);
    NSString *sessionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    NSLog(@"Getting sessionid: %@\n", sessionid);
    if (sessionid != NULL) {
        NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
        NSLog(@"Getting userid: %@\n", userid);
        
        NSString *positionPath = [[NSString alloc] initWithFormat:@"/api/positions/?sessionid=%@", sessionid];
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                theId, @"bind",
                                nil];
        
        NSLog(@"%@",positionPath);
        NSURLRequest *addUserRequest = [mapClient requestWithMethod:@"POST" path:positionPath parameters:params];
        
        NSLog(@"Actual request...\n");
        AFJSONRequestOperation *postPositionOperation = [AFJSONRequestOperation
                                                         JSONRequestOperationWithRequest:addUserRequest
                                                         success:^(NSURLRequest *addUserRequest, NSHTTPURLResponse *addUserResponse, id JSON) {
                                                             NSLog(@"Succeeded in posting position\n");
                                                             NSLog(@"Position: %@", JSON);
                                                         } failure:^(NSURLRequest *addUserRequest, NSHTTPURLResponse *addUserResponse, NSError *error, id JSON) {
                                                             NSLog(@"Unable to post position!\n");
                                                             NSLog(@"Error! %@\n", error);
                                                             
                                                             //TODO: Handle special cases like unauthorized, not being connected to the internet, etc...
                                                         }];
        
        [[[NSOperationQueue alloc] init] addOperation:postPositionOperation];
    }
}

-(void)getPlaceWithId: (NSString*)theId andDo: (deferredMethodWithString)meth {
    // TODO: Actually implement
    NSString *sessionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    NSLog(@"Getting sessionid: %@\n", sessionid);
    
    if (sessionid != NULL) {
        NSString *pathWithQueryString = [[NSString alloc] initWithFormat: @"/api/places/%@/?sessionid=%@", theId, sessionid];
        NSLog(@"%@", pathWithQueryString);
        
        NSURLRequest *request = [mapClient requestWithMethod:@"GET" path:pathWithQueryString parameters:nil];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                             JSONRequestOperationWithRequest:request
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                 NSString *place = [JSON valueForKey:@"place"];
                                                 NSLog(@"Place: %@\n", place);
                                                 
                                             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                 NSLog(@"Get place fail: %@\n", error);
                                                 //TODO: Handle special cases like unauthorized, not being connected to the internet, etc...
                                             }];
        
        [[[NSOperationQueue alloc] init] addOperation:operation];
    }
}

-(void)postNewBindFromSignals: (NSDictionary *)signals andBind: (id) bind {
    id place = [bind objectForKey:@"place"];
    NSString *placeid;
    if ([place objectForKey:@"id"] != nil) {
        placeid = [place objectForKey:@"id"];
    } else {
        placeid = place;
    }
    id x = [bind objectForKey:@"x"];
    id y = [bind objectForKey:@"y"];

    NSLog(@"Signals Dict: %@", signals);
    
    NSString *sessionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    NSLog(@"Getting sessionid: %@\n", sessionid);
    if (sessionid != NULL) {
        
        NSString *bindPath = [[NSString alloc] initWithFormat:@"/api/binds/?sessionid=%@", sessionid];
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                x, @"x",
                                y, @"y",
                                placeid, @"place",
                                signals, @"signals",
                                nil];
        
        NSLog(@"%@",bindPath);
        NSURLRequest *addUserRequest = [mapClient requestWithMethod:@"POST" path:bindPath parameters:params];
        
        NSLog(@"Actual request...\n");
        AFJSONRequestOperation *postBindOperation = [AFJSONRequestOperation
                                                         JSONRequestOperationWithRequest:addUserRequest
                                                         success:^(NSURLRequest *addUserRequest, NSHTTPURLResponse *addUserResponse, id JSON) {
                                                             NSLog(@"Succeeded in posting bind\n");
                                                             NSLog(@"Position: %@", JSON);
                                                         } failure:^(NSURLRequest *addUserRequest, NSHTTPURLResponse *addUserResponse, NSError *error, id JSON) {
                                                             NSLog(@"Unable to post bind!\n");
                                                             NSLog(@"Error! %@\n", error);
                                                             
                                                             //TODO: Handle special cases like unauthorized, not being connected to the internet, etc...
                                                         }];
        
        [[[NSOperationQueue alloc] init] addOperation:postBindOperation];
    }
}

-(void)scan {
    NSString *sessionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionid"];
    NSLog(@"Getting sessionid: %@\n", sessionid);
    
    if (sessionid != NULL) {
        NSMutableSet *scanResultsSet = [wifiScanner scan];
        NSMutableDictionary *scanResultsNearestFormat = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *scanResultsBareFormat = [[NSMutableDictionary alloc] init];
        
        for (CWNetwork *network in scanResultsSet) {
            NSString *nearestKey = [[NSString alloc] initWithFormat: @"nearest[%@]", [network bssid]];
            
            /* Most platforms (nm-tool doesn't for some reason) return the Received Signal Strength
             Indication (RSSI) in dBm units (http://en.wikipedia.org/wiki/DBm) Adding 100 is a convenient
             way to indicate, for example, that -85 is weaker than -10 */
            
            NSNumber *value = [[NSNumber alloc] initWithFloat: (float)(100.0f+[network rssiValue])];
            
            [scanResultsNearestFormat setObject: value forKey: nearestKey];
            [scanResultsBareFormat setObject: value forKey: [network bssid]];
        }
        
        NSString *pathWithQueryString = [[[NSString alloc] initWithFormat: @"/api/binds?sessionid=%@", sessionid] addQueryStringToUrlStringWithDictionary:scanResultsNearestFormat];
        
        NSLog(@"%@", pathWithQueryString);
        
        NSURLRequest *request = [mapClient requestWithMethod:@"GET" path:pathWithQueryString parameters:nil];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                             JSONRequestOperationWithRequest:request
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                 NSArray *nearestBinds = [JSON valueForKey:@"binds"];
                                                 
                                                 NSLog(@"Nearest: %@\n", nearestBinds);
                                                 
                                                 NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                           nearestBinds, @"nearestBinds",
                                                                           scanResultsBareFormat, @"scanResultsBareFormat",
                                                                           nil];
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"scanComplete" object:self userInfo:dataDict];
                                                 
                                             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                 NSLog(@"Get nearest fail: %@\n", error);
                                                 //TODO: Handle special cases like unauthorized, not being connected to the internet, etc...
                                             }];
        
        [[[NSOperationQueue alloc] init] addOperation:operation];
    }
}

@end
