//
//  NetworkManager.h
//  Map
//
//  Created by Julian Ceipek on 6/14/12.
//  Copyright (c) 2012-2013 SLAC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"



#import "WifiScanner.h"

@interface NetworkManager : NSObject {
    
}

+ (NetworkManager *)theNetworkManager;
-(void)authenticateWithUsername: (NSString*)username password: (NSString*)password;
-(void)createUser;
-(void)scan;
-(void)postToPositionTheBindWithId: (NSString*)theId;
-(void)postNewBindFromSignals: (NSDictionary *)signals andBind: (id) bind;

@end
