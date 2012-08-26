//
//  AuthHTTPConnection.m
//  Map
//
//  Created by Julian Ceipek on 6/11/12.
//  Copyright (c) 2012 ohack. All rights reserved.
//

#import "AuthHTTPConnection.h"
#import "HTTPMessage.h"
#import "HTTPRedirectResponse.h"

#import "NSString+NSString_URLManipulation.h"
#import "DDData.h"

@implementation AuthHTTPConnection

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path
{
	// Add support for POST    
    if ([method isEqualToString:@"POST"] && [path isEqualToString:@"/"]) {
        
        NSLog(@"requestContentLength: %llu", requestContentLength);
        // Make sure the request isn't too big!
        if (requestContentLength < 3000) {
            return TRUE;
        } else {
            NSLog(@"Request is too big!");
            return FALSE;
        }

    }
    
	return [super supportsMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{    
    NSString *postStr = nil;
    NSData *postData = [request body];

    if (postData)
    {
        postStr = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"THE POST STRING: %@", postStr);
        NSLog(@"URL DECODED: %@", [postStr urlDecodeString]);
        
        NSDictionary *theParams = [self parseParams:[postStr urlDecodeString]];
        
        // TODO: Save the session and browserid properties in a persistent data store
        // They can then be used in a cookie
        
        for(id key in theParams) {
            NSData *encodedData = [[theParams objectForKey:key] dataUsingEncoding:NSUTF8StringEncoding];
            NSString *string = [[NSString alloc] initWithData:[encodedData base64Decoded] encoding:NSUTF8StringEncoding];
            NSLog(@"KEY: %@ ; Value: %@", key, [theParams objectForKey:key]);
        }
        
        // TODO: Save to file
        NSError *error;
        NSString *errorDesc;
        NSURL *rootUrl = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                                inDomain:NSUserDomainMask
                                                       appropriateForURL:nil
                                                                  create:YES
                                                                   error: &error];
        
        NSLog(@"Error: %@", [error description]);
        
        
        [[NSFileManager defaultManager] createDirectoryAtURL:[rootUrl URLByAppendingPathComponent:@"MaraudersMap" ]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        if (error != nil) {
            NSLog(@"error creating directory: %@", error);
        }
        
        NSURL *plistPath = [[rootUrl URLByAppendingPathComponent:@"MaraudersMap" ] URLByAppendingPathComponent: @"Secret.plist"];
        NSDictionary *plistDict = [NSDictionary dictionaryWithObject: theParams
                                                              forKey: @"BrowserID"];
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList: plistDict
                                                                       format: NSPropertyListXMLFormat_v1_0
                                                             errorDescription: &errorDesc];
        NSLog(@"BIGError: %@", [error description]);
        if(plistData) {
            [plistData writeToURL:plistPath atomically:YES];
            NSLog(@"PATH: %@", plistPath);
        }
        else {
            NSLog(@"%@", errorDesc);
        }

    }
	
	if ([method isEqualToString:@"POST"])
	{
        return [[HTTPRedirectResponse alloc] initWithPath:@"http://map.fwol.in/ui/index.html"];
    }
    
    return [super httpResponseForMethod:method URI:path];
}

- (void)processBodyData:(NSData *)postDataChunk
{	
	// Remember: In order to support LARGE POST uploads, the data is read in chunks.
	// This prevents a 50 MB upload from being stored in RAM.
	// The size of the chunks are limited by the POST_CHUNKSIZE definition.
	// Therefore, this method may be called multiple times for the same POST request.
	
	BOOL result = [request appendData:postDataChunk];
	if (!result)
	{
		NSLog(@"Unable to append data to request!");
	}
}

@end
